require_relative '../../../../lib/engines/with_migrations'

module Group
  class Engine < ::Rails::Engine
    extend ::Engines::WithMigrations

    isolate_namespace Group

    config.autoload_paths += %W(#{config.root}/lib)

    config.generators do |c|
      c.test_framework :rspec
    end

    # TODO: use with_factories?
    initializer "model_core.factories", after: "factory_girl.set_factory_paths" do
      if defined?(FactoryGirl)
        FactoryGirl.definition_file_paths << File.expand_path('../../../spec/factories', __FILE__)
      end
    end
  end
end
