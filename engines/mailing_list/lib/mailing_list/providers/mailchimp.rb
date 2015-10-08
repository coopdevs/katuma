require 'gibbon'

module MailingList
  module Providers
    class Mailchimp
      DEFAULT_LIST_ID = '01c2c12581' # Test list

      attr_accessor :client

      def initialize
        @client = ::Gibbon::Request.new
      end

      # Sends a request to MailChimp to add a user to the default list
      #
      # @param user [Account::User]
      def add_user_to_list!(user)
        options = {
          body: {
            email_address: user.email,
            status: 'subscribed',
            merge_fields: {
              FNAME: user.first_name,
              LNAME: user.last_name
            }
          }
        }

        client.lists(DEFAULT_LIST_ID).members.create(options)
      end
    end
  end
end
