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

    # TODO Find a way to manage express URLs
    #
    # @return [String]
    def confirm_url
      "http://10.0.3.70:8000?token=#{@signup.token}"
    end
  end
end
