module MailingList
  class Client
    DEFAULT_PROVIDER = ::MailingList::Providers::Mailchimp

    attr_accessor :provider

    def initialize
      @provider = DEFAULT_PROVIDER.new
    end

    # Sends a request to the provider to add a user to the default list
    #
    # @param user [Account::User]
    def add_user_to_list!(user)
      provider.add_user_to_list!(user)
    end
  end
end
