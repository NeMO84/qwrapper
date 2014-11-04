require 'bunny'
require 'qwrapper/queues/base'

module Qwrapper

  module Queues

    class RabbitMQ < Base

      def subscribe(queue_name, options={}, &block)
        begin
          logger.info "Subscribed to '#{queue_name}'"
          queue = get_queue(queue_name, options)
          queue.subscribe(ack: true, block: true) do |delivery_info, metadata, payload|
            # TODO find unique way to identify a message and list that as part
            # of the wrap message
            begin
              if logger.respond_to?(:wrap)
                logger_wrapped_block_execution(payload, &block)
              else
                block_execution(payload, &block)
              end
            rescue *requeue_exceptions => ex
              logger.error "Requeue logic"
              logger.error ex
            end
            queue.channel.ack(delivery_info.delivery_tag)
          end
          connection.close if connection
        rescue Exception => ex
          logger.error "TODO: What logic goes here?"
          logger.error ex
        end
      end

      def publish(queue_name, messages, options={})
        messages = [messages] unless messages.is_a?(Array)
        queue = get_queue(queue_name, options={})
        [messages].each do |message|
          queue.publish(message.to_s, :persistent => true)
        end
        connection.close if connection
      end

    private

      def logger_wrapped_block_execution(payload, &block)
        logger.wrap("SubscribedMessage") do |nested_logger|
          block.call(payload, nested_logger)
        end
      end

      def block_execution(payload, &block)
        block.call(payload, logger)
      end


      def get_queue(queue_name, options={})
        ch = connection.create_channel
        ch.queue(queue_name, options.merge(durable: true))
      end

      def connection
        #@conn ||= begin
          Bunny.new(connection_details).tap do |c|
            c.start
          end
        #end
      end

      def connection_details
        {
          host: config[:host] || "localhost",
          port: config[:port] || 5672,
          logger: dup_logger,
          keepalive: config[:keepalive] || true
        }
      end

      def dup_logger
        logger.respond_to?(:duplicate) ? logger.duplicate("bunny") : logger
      end

    end

  end

end
