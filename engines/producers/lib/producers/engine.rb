require_relative '../../../../lib/engines/with_migrations'

module Producers
  class Engine < ::Rails::Engine
    extend ::Engines::WithMigrations

    isolate_namespace Producers
  end
end
