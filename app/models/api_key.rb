class ApiKey < ActiveRecord::Base
  after_initialize do
    generate_access_token unless access_token?
  end
  belongs_to :user

  validates :user,
    presence: true
  validates :access_token,
    presence: true,
    uniqueness: true

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end
end
