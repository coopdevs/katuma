require_relative '../../../../lib/engines/with_migrations'

module Onboarding
  class Engine < ::Rails::Engine
    extend ::Engines::WithMigrations

    isolate_namespace Onboarding
  end
end
