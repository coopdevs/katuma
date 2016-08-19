module Engines
  # It DRYies the common snippet to append engine's migrations to the main app
  module WithMigrations

    # Rails extended hook
    #
    # @params base [?] modules extender
    def self.extended(base)
      base.append_migrations
    end

    # Appends the caller engine's migrations to the main app
    def append_migrations
      initializer :append_migrations do |app|
        unless app.root.to_s.match root.to_s+File::SEPARATOR
          app.config.paths["db/migrate"].concat config.paths["db/migrate"].expanded
        end
      end
    end
  end
end
