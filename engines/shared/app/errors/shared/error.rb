module Shared
  class Error < Shared::BaseSerializer
    ERRORS = {
      not_found: NotFoundError,
      bad_request: BadRequestError
    }

    schema do
      type 'error'

      property :status, error.status_code
      property :name, error.name
      property :errors, error.messages
    end

    private

    def error
      @error ||= error_class.new(item, context)
    end

    def error_class
      error_name = context[:name]
      ERRORS[error_name]
    end
  end
end
