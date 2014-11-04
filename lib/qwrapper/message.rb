module Qwrapper
  class Message

    include Loggable

    attr_reader :original_body, :hash

    def initialize(body)
      raise ArgumentError.new "Message body cannot be blank" if body.blank?
      @original_body = body
      begin
        @hash = eval(body.to_s) rescue JSON.parse(body.to_s)
        logger.info "Message evaluated: #{@hash}"
      rescue => ex
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

  end
end
