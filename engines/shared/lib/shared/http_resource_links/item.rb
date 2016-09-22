module Shared
  module HttpResourceLinks
    class Item
      API_VERSION = 1

      attr_accessor :object, :custom_relation

      # @param object [ActiveRecord::Base]
      # @param custom_relation [String] optional, e.g. 'created'
      def initialize(object, custom_relation=nil)
        @object = object
        @custom_relation = custom_relation
      end

      # Returns the link header
      #
      # @return [String]
      def link
        "<#{api_link}>; rel=\"#{relation}\" type=\"#{object.class.name}\""
      end

      private

      # Returns an API uri for the given model
      #
      # @return [String] resource api url
      def api_link
        [
          ::Shared::FrontendUrl.base_url,
          "/api/#{API_VERSION}/",
          object.model_name.route_key,
          '/',
          object.id
        ].join
      end

      # @return [String]
      def relation
        return custom_relation unless custom_relation.blank?
        return 'created' if new_record?

        'updated'
      end

      # @return [Boolean]
      def new_record?
        object.previous_changes['id'] == [nil, object.id]
      end
    end
  end
end
