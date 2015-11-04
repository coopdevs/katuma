module Account
  class SignupWorker
    include Sidekiq::Worker

    sidekiq_options queue: :low

    def perform(signup_id)
      signup = Signup.find_by(id: signup_id)

      SignupMailer.confirm_email(signup).deliver
    end
  end
end
