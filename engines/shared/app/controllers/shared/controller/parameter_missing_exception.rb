module Shared
  module Controller
    module ParameterMissingException
      extend ::ActiveSupport::Concern

      included do
        rescue_from ActionController::ParameterMissing, with: :missing_parameter
      end

      protected

      def missing_parameter(error)
        render(
          status: :bad_request,
          json: { errors: error_message_for_required_field(error.param) }
        )
      end

      def error_message_for_required_field(field)
        {
          field => t("#{controller_name}.#{action_name}.#{field}",
            field: field,
            default: [:generic],
            scope: :missing_param
          )
        }
      end
    end
  end
end
