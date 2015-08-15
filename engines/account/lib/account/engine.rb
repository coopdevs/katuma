require_relative '../../../../lib/engines/with_migrations'

module Account
  class Engine < ::Rails::Engine
    extend ::Engines::WithMigrations

    isolate_namespace Account
  end
end
