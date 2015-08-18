module Landing
  class Engine < ::Rails::Engine
    isolate_namespace Landing

    initializer "landing.assets.precompile" do |app|
      app.config.assets.precompile += %w(application.css)
    end
  end
end
