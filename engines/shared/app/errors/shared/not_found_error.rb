module Shared
  # Represents an HTTP Not Found error as an exception. It allows to customize
  # the error message with the data of the provided id and item. Otherwise,
  # a default message is used
  class NotFoundError < StandardError
    STATUS_CODE = 404
    NAME = 'Not Found'.freeze

    # Constructor
    #
    # @param id [Integer]
    # @param item [#name, #model_name]
    def initialize(id = nil, item = nil)
      @id = id
      @item = item
    end

    # Returns the exception's message. Note this is the message shown in a
    # backtrace. If no item is provided a default one is returned
    #
    # @return [String]
    def message
      message_hash || 'The item could not be found'.freeze
    end

    # Returns the HTTP status code
    #
    # @return [Integer]
    def status_code
      STATUS_CODE
    end

    # Returns the HTTP error name
    #
    # @return [String]
    def name
      NAME
    end

    private

    attr_reader :id, :item

    # Returns the errors hash to be returned as the API error
    #
    # @return [Maybe<Hash>]
    def message_hash
      return unless model_name
      { model_name => item_message }
    end

    # Returns the specific error the item caused
    #
    # @return [Maybe<String>]
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
