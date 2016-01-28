module Shared
  class ErrorSerializer < Shared::BaseSerializer
    schema do
      type 'error'

      property :status, error.status_code
      property :name, error.name
      property :errors, error.message
    end

    private

    def error
      item
    end
  end
end
