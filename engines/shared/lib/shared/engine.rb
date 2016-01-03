module Shared
  class Engine < ::Rails::Engine
    isolate_namespace Shared

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "shared.assets.precompile" do |app|
      app.config.assets.precompile += %w(application.css application.js)
    end
  end
end
