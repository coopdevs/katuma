module Shared
  class Engine < ::Rails::Engine
    isolate_namespace Shared

    initializer "shared.assets.precompile" do |app|
      app.config.assets.precompile += %w(application.css application.js)
    end
  end
end
