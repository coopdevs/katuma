module Account
  class SignupService

    # @param email [String]
    def initialize(email)
      @email = email
      @signup = Signup.find_by_email(email) || Signup.new(email: email)
    end

    # @return [Account::Signup]
    def execute
      if @signup.save
        SignupMailer.confirm_email(@signup).deliver
      end

      @signup
    end
  end
end
