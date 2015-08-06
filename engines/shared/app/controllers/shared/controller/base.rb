module Shared
  module Controller
    module Base
      extend ::ActiveSupport::Concern

      included do
        before_action :set_locale
      end

      def set_locale
        I18n.locale =
          params[:locale] ||
          extract_locale_from_accept_language_header ||
          I18n.default_locale
      end

      private

      # Method to get locale from browser
      # This method is not production ready
      # Maybe use a gem. Here we have info:
      # http://guides.rubyonrails.org/i18n.html#setting-the-locale-from-the-client-supplied-information
      def extract_locale_from_accept_language_header
        browser_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first.to_sym
        return nil unless I18n.available_locales.include? browser_locale
        browser_locale
      end
    end
  end
end
