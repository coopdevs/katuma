module Account
  class SignupMailer < ActionMailer::Base

    default from: 'info@katuma.org'

    # @param signup [Account::Signup]
    def confirm_email(signup)
      @signup = signup
      @url = confirm_url

      mail to: @signup.email, subject: "Welcome to Katuma!"
    end

    private

    # @return [String]
    def confirm_url
      "#{::Shared::FrontendUrl.base_url}/signup/complete/#{@signup.token}"
    end
  end
end
