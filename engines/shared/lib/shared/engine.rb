module Shared
  class Engine < ::Rails::Engine
    isolate_namespace Shared

    config.generators do |c|
      c.test_framework :rspec
    end

    config.autoload_paths += %W(#{config.root}/lib)
  end
end
