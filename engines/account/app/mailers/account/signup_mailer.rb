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

    def confirm_url
      complete_signup_url(@signup, host: 'localhost:3000', email: @signup.email, token: @signup.token)
    end
  end
end
