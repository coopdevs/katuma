require_relative '../../../../lib/engines/with_migrations'

module Group
  class Engine < ::Rails::Engine
    extend ::Engines::WithMigrations

    isolate_namespace Group

    config.autoload_paths += %W(#{config.root}/lib)

    config.generators do |c|
      c.test_framework :rspec
    end
  end
end
