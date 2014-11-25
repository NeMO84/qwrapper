require "qwrapper/version"
require "qwrapper/support"
require "qwrapper/message"
require "qwrapper/queues"

# Qwrapper is an idomatic API for working with message queues.
module Qwrapper

  class << self

    include Loggable

    attr_reader :version
    attr_accessor :config

    # @return [String] Qwrapper version
    def version
      @version ||= Qwrapper::VERSION
    end

    def config=(value)
      @config = value
    end

    def config
      @config ||= {}
    end

    def connect!
      queue.connect! if queue
    end

    def disconnect!
      queue.disconnect! if queue
    end

    def queue
      @queue ||= begin
        base = Qwrapper::Queues::Base
        q = case self.config[:queue_type].to_s.to_sym
          when :rabbitmq
            then Qwrapper::Queues::RabbitMQ.new(self.config)
          when :"" then nil
          when nil then nil
          else raise "Unsupported queue_type '#{queue_type}'"
        end
      end
    end

  end

  class RequeueError < StandardError; end

end
