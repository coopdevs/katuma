module Account
  class SignupService

    def initialize
    end

    # @param email [String]
    # @return [Account::Signup]
    def create!(email)
      signup = Signup.new(email: email)

      if signup.save
        SignupMailer.confirm_email(signup).deliver
      end

      signup
    end
  end
end
