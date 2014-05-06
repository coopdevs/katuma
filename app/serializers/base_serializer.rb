require 'oat/adapters/json_api'

class BaseSerializer < Oat::Serializer

  adapter Oat::Adapters::JsonAPI

end
