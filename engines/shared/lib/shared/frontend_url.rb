module Shared
  module FrontendUrl
    # The environment variable will allow to override the default host,
    # useful while running development environments in containers
    DEVELOPMENT_HOST = ENV['DEVELOPMENT_HOST'] || 'localhost'
    DEVELOPMENT_PORT = 8000

    def self.base_url
      "#{protocol}://#{host}"
    end

    private

    # HTTP protocol
    #
    # TODO: implement SSL and switch to https in production
    #
    # @return [String]
    def self.protocol
      'http'
    end

    # Domain name
    #
    # @return [String]
    def self.host
      return development_host if Rails.env.development?

      'alfa.katuma.org'
    end

    # Domain name for developmnent environment
    #
    # @return [String]
    def self.development_host
      "#{DEVELOPMENT_HOST}:#{DEVELOPMENT_PORT}"
    end
  end
end
