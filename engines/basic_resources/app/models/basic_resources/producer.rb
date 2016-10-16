module BasicResources
  class Producer < ActiveRecord::Base
    self.table_name = :producers

    has_many :memberships, dependent: :destroy, foreign_key: :basic_resource_producer_id
    # TODO: investigate how to scope memberships.role = $admin here
    has_many :groups, through: :memberships

    validates :name, :email, :address, presence: true

    # @return [Boolean]
    def admin?(user)
      memberships.where(
        user_id: user.id,
        role: Membership::ROLES[:admin]
      ).any?
    end
  end
end
