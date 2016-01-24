module Shared
  class BadRequestError < StandardError
    STATUS_CODE = 400
    NAME = 'Bad Request'.freeze

    def initialize(item = nil)
      @item = item
    end

    def message
      message_hash || 'Malformed request'.freeze
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
