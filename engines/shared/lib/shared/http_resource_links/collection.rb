module Shared
  module HttpResourceLinks
    class Collection

      # @param objects [Array<ActiveRecord::Base>]
      # @param custom_relation [String] optional, e.g. 'created'
      def initialize(objects, custom_relation=nil)
        @collection = objects.map { |object| Item.new(object, custom_relation) }
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
