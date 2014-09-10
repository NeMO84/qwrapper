module Qwrapper

  module Queues

    class Base

      include Loggable

      attr_accessor :config
      attr_reader :requeue_exceptions

      def initialize(options)
        @config = options
        logger = options[:logger] if options.has_key?(:logger)
      end

      def requeue_exceptions
        @requeue_exceptions ||= begin
          requeueable_exceptions = config[:requeue_exceptions] || []
          requeueable_exceptions << Qwrapper::RequeueError
          requeueable_exceptions.uniq
        end
      end

    end

  end

end
