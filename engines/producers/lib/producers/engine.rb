require_relative '../../../../lib/engines/with_migrations'

module Producers
  class Engine < ::Rails::Engine
    extend ::Engines::WithMigrations

    isolate_namespace Producers

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
