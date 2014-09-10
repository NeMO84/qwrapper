module Qwrapper

  class Config

    SETTINGS = [
      :requeue_exceptions, :queue_type
    ]

    class << self

      attr_accessor(*SETTINGS)

      def requeue_exceptions
        @requeue_exceptions ||= []
      end

    end

  end

end
