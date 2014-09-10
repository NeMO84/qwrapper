require 'logification'

module Qwrapper

  module Loggable

    def logger
      @logger ||= begin
        Logification::Logger.new(name: "qwrapper")
      end
    end

    def logger=(value)
      @logger = value
    end

  end

end