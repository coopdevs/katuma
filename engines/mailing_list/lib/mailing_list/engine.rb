module MailingList
  class Engine < ::Rails::Engine
    isolate_namespace MailingList

    config.autoload_paths += %W(#{config.root}/lib)
  end
end
