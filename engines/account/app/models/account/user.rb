require 'email_validator'

module Account
  class User < ActiveRecord::Base

    self.table_name = :users

    has_secure_password

    validates :first_name, :last_name, presence: true
    validates :email,    presence: true, uniqueness: true, email: true
    validates :username, presence: true, uniqueness: true
    validates :username, format: {
      with: /\A[a-zA-Z0-9_\-]+\Z/,
      message: 'Solo puede contener letras, numeros, _ y -. Sin espacios ni otros caracteres como: ;, *, ^, $, ...'
    }

    def self.find_by_login(login)
      context = if EmailValidator.valid?(login)
                  where(email: login)
                else
                  where(username: login)
                end

      context.take
    end

    # @return [String]
    def full_name
      "#{first_name} #{last_name}"
    end
  end
end
