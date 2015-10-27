module Account
  class SignupService

    def initialize
    end

    # @param email [String]
    # @return [Account::Signup]
    def create!(email)
      signup = Signup.find_by_email(email) || Signup.new(email: email)

      if signup.save
        SignupMailer.confirm_email(signup).deliver
      end

      signup
    end

    # @param signup [Account::Signup]
    # @param options [Hash]
    # @option options [String] :username
    # @option options [String] :password
    # @option options [String] :password_confirmation
    # @option options [String] :first_name
    # @option options [String] :last_name
    # @return [Account::User]
    def complete!(signup, options)
      user = ::Account::User.new(
        email: signup.email,
        username: options[:username],
        password: options[:password],
        password_confirmation: options[:password_confirmation],
        first_name: options[:first_name],
        last_name: options[:last_name]
      )

      ::ActiveRecord::Base.transaction do
        signup.destroy if user.save
      end

      user
    end
  end
end
