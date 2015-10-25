module Account
  class User < ActiveRecord::Base

    self.table_name = :users

    has_secure_password

    validates :first_name, :last_name, presence: true
    validates :email,    presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true
    validates :username, format: {
      with: /\A[a-zA-Z0-9_\-]+\Z/,
      message: 'Solo puede contener letras, numeros, _ y -. Sin espacios ni otros caracteres como: ;, *, ^, $, ...'
      }

    # @return [String]
    def full_name
      return username if first_name.blank? && last_name.blank?
      return first_name if last_name.blank?

      "#{first_name} #{last_name}"
    end
  end
end
