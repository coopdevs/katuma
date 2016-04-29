module Shared
  module HttpResourceLinks
    module_function

    # Returns the HTTP resource links for the given ActiveRecord collection
    #
    # The generated link is RFC 5988 compliant
    # for more info please visit https://www.w3c.org/wiki/LinkHeader
    #
    # @param objects [Array<ActiveRecord::Base>]
    # @return [String]
    def build(objects)
      Collection.new(objects).links
    end
  end
end
