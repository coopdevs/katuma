module Shared
  module HttpResourceLinks
    class Collection

      # @param objects [Array<ActiveRecord::Base>]
      def initialize(objects)
        @collection = objects.map { |object| Item.new(object) }
      end

      # Returns the resource link header
      #
      # @return [String]
      def links
        collection.map(&:link).join(', ')
      end

      private

      attr_accessor :collection
    end
  end
end
