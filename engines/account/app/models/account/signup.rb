module Account
  class Signup < ActiveRecord::Base

    self.table_name = :signups

    before_validation do |signup|
      signup.token = SecureRandom.urlsafe_base64(32)
    end

    validates :email,
      presence: true
    validates :token,
      presence: true,
      uniqueness: true
  end
end
