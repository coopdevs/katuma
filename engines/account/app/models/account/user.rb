module Account
  class User < ActiveRecord::Base

    self.table_name = :users

    has_secure_password

    validates :email,    presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true

    # @return [String]
    def full_name
      return username if first_name.blank? && last_name.blank?
      return first_name if last_name.blank?

      "#{first_name} #{last_name}"
    end
  end
end
