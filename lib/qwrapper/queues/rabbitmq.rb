require 'bunny'
require 'qwrapper/queues/base'

module Qwrapper

  module Queues

    class RabbitMQ < Base

      attr_reader :connection

      def subscribe(queue_name, options={}, &block)
        ch = nil
        begin
          logger.info "Subscribing to '#{queue_name}'"
          ch = connection.create_channel
          ch.prefetch(options[:prefetch] || 1)
          queue = ch.queue(queue_name, options.merge(durable: true))
          queue.subscribe(manual_ack: true, block: true) do |delivery_info, metadata, payload|
            begin
              if logger.respond_to?(:wrap)
                logger_wrapped_block_execution(payload, &block)
              else
                block_execution(payload, &block)
              end
            rescue *requeue_errors => ex
              if requeue_lambda
                requeue_lambda.call(queue_name, payload, ex)
              else
                logger.error "No requeue_lambda provided"
                raise ex
              end
            end
            queue.channel.ack(delivery_info.delivery_tag)
          end
        rescue Exception => ex
          logger.error ex
        ensure
          ch.close if ch
        end
      end

      def publish(queue_name, messages, options={})
        ch = nil
        begin
          logger.info "Publishing to '#{queue_name}'"
          messages = [messages] unless messages.is_a?(Array)
          messages.flatten!
          if messages.count > 0
            ch = connection.create_channel
            ch.prefetch(options[:prefetch] || 1)
            queue = ch.queue(queue_name, options.merge(durable: true))
            messages.each do |message|
              message_options = {persistent: true}
              message_options.merge!(expiration: options[:expiration]) unless options[:expiration].nil?
              queue.publish(message.to_s, message_options)
            end
          end
        rescue Exception => ex
          logger.error ex
        ensure
          ch.close if ch
        end
      end

      def connect!
        connection.start if connection
      end

      def disconnect!
        connection.close if connection
      end

    private

      def connection
        @conn ||= begin
          c = Bunny.new({
            host: config[:host] || "localhost",
            port: config[:port] || 5672,
            username: config[:username] || "guest",
            password: config[:password] || "guest",
            virtual_host: config[:virtual_host] || "/",
            logger: dup_logger,
            keepalive: config[:keepalive] || true
          })
          c.start
        end
      end

      def logger_wrapped_block_execution(payload, &block)
        logger.wrap("SubscribedMessage") do |nested_logger|
          block.call(payload, nested_logger)
        end
      end

      def block_execution(payload, &block)
        block.call(payload, logger)
      end

      def dup_logger
        logger.respond_to?(:duplicate) ? logger.duplicate("bunny") : logger
      end

    end

  end

end
