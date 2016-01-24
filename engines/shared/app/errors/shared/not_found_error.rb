module Shared
  class NotFoundError < StandardError
    STATUS_CODE = 404
    NAME = 'Not Found'.freeze

    def initialize(id = nil, item = nil)
      @id = id
      @item = item
    end

    def message
      message_hash || 'The item could not be found'.freeze
    end

    def status_code
      STATUS_CODE
    end

    def name
      NAME
    end

    private

    attr_reader :id, :item

    def message_hash
      return unless model_name
      { model_name => item_message }
    end

    def item_message
      "#{model_name.capitalize} with id #{id} not found".freeze
    end

    # TODO: doesn't AR provide this?
    def model_name
      return unless item
      @model_name ||= item.name.demodulize.downcase
    end
  end
end
