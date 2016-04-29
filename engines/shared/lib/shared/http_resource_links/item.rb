module Shared
  module HttpResourceLinks
    class Item
      API_VERSION = 1

      attr_accessor :object

      # @param object [ActiveRecord::Base]
      def initialize(object)
        @object = object
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
        "#{::Shared::FrontendUrl.base_url}/api/#{API_VERSION}/#{object.model_name.route_key}/#{object.id}"
      end

      # @return [String]
      def relation
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
