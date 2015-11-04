module Account
  class SignupService

    def initialize
    end

    # @param email [String]
    # @return [Account::Signup]
    def create!(email)
      signup = Signup.find_or_initialize_by(email: email)

      signup.save && SignupWorker.perform_async(signup.id)
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
      ::ActiveRecord::Base.transaction do
        user = ::Account::User.create email: signup.email,
                                      username: options[:username],
                                      password: options[:password],
                                      password_confirmation: options[:password_confirmation],
                                      first_name: options[:first_name],
                                      last_name: options[:last_name]
        signup.destroy
        user
      end
    end
  end
end
