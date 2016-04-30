module Shared
  module Controller
    module WithSideEffects

      extend ::ActiveSupport::Concern

      included do
        attr_reader :side_effects

        before_action :initialize_side_effects
        after_action :add_side_effects_links
      end

      private

      def initialize_side_effects
        @side_effects = []
      end

      # Adds HTTP resource links for the generated side effects
      #
      # The generated link is RFC 5988 compliant
      # for more info please visit https://www.w3c.org/wiki/LinkHeader
      #
      def add_side_effects_links
        return unless side_effects.any?

        response.headers['Link'] = ::Shared::HttpResourceLinks.build(objects)
      end

      # Returns a flattened collection of unique AR objects
      #
      # @return [Array<ActiveRecord::Base>]
      def objects
        side_effects.flatten.uniq
      end
    end
  end
end
