module Shared
  class UnprocessableEntity < StandardError
    STATUS_CODE = 422
    NAME = 'Unprocessable Entity'.freeze

    def initialize(item = nil)
      @item = item
    end

    def message
      message_hash || 'The entity could not be processed'.freeze
    end

    def status_code
      STATUS_CODE
    end

    def name
      NAME
    end

    private

    attr_reader :item

    def message_hash
      item.try(:errors)
    end
  end
end
