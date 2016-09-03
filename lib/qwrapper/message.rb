require 'json'

module Qwrapper
  class Message

    attr_reader :original_body, :hash

    def initialize(body)
      raise ArgumentError.new "Message body cannot be blank" if body.nil? or body.empty?
      @original_body = body
      begin
        begin
          @hash = eval(body.to_s)
        rescue SyntaxError => ex
          @hash = JSON.parse(body.to_s)
        end
        logger.info "Message evaluated: #{@hash}"
      rescue Exception => ex
        logger.error "Message body cannot be evaluated: #{body}"
        raise ex
      end
      validate!
    end

    def action
      ((hash[:action] || hash["action"])).to_sym
    end

    def method_missing(m, *args, &block)
      hash[m.to_s] || hash[m.to_s.to_sym]
    end

    private

    def validate!
      # TODO: Raise NotImplementedError? Client should implement their own custom error
    end

    def logger
      Qwrapper.logger
    end

  end
end
