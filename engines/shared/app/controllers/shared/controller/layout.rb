module Shared
  module Controller
    module Layout
      extend ::ActiveSupport::Concern

      included do
        layout 'shared/layouts/application'
      end
    end
  end
end
