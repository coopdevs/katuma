module Shared
  # Represents an HTTP Bad Request error as an exception. It allows to
  # customize the error message with the data of the provided item. Otherwise,
  # a default message is used
  class BadRequestError < StandardError
    STATUS_CODE = 400
    NAME = 'Bad Request'.freeze

    # Constructor
    #
    # @param item [#name, #errors]
    def initialize(item = nil)
      @item = item
    end

    # Returns the exception's message. Note this is the message shown in a
    # backtrace. If no item is provided a default one is returned
    #
    # @return [String]
    def message
      message_hash || 'Malformed request'.freeze
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

    attr_reader :item

    # Returns the errors hash to be returned as the API error
    #
    # @return [Maybe<Hash>]
    def message_hash
      item.try(:errors)
    end
  end
end
