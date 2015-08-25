require_relative '../../../../lib/engines/with_migrations'

module Suppliers
  class Engine < ::Rails::Engine
    extend ::Engines::WithMigrations

    isolate_namespace Suppliers
  end
end
