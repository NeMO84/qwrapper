module Qwrapper

  module Queues

    class Base

      include Loggable

      attr_accessor :config
      attr_reader :requeue_errors, :requeue_lambda

      def initialize(options)
        @config = options
        @logger = options[:logger] if options.has_key?(:logger)
      end

      def requeue_errors
        @requeue_errors ||= begin
          requeueable_exceptions = config[:requeue_errors] || []
          requeueable_exceptions << Qwrapper::RequeueError
          requeueable_exceptions.uniq
        end
      end

      def requeue_lambda
        @requeue_lambda ||= begin
          config[:requeue_lambda]
        end
      end

    end

  end

end
