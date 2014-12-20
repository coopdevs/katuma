module PublicPages
  class Engine < ::Rails::Engine
    isolate_namespace PublicPages

    initializer :assets do |config|
      Rails.application.config.assets.paths << root.join("app", "assets", "fonts")
    end
  end
end
