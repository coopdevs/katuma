module Account
  class SignupJob < ActiveJob::Base
    queue_as :default

    def perform(signup_id)
      signup = Signup.find_by(id: signup_id)

      raise 'Signup not found' unless signup

      SignupMailer.confirm_email(signup).deliver
    end
  end
end
