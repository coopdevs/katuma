module BasicResources
  class Group < ActiveRecord::Base

    self.table_name = :groups

    has_many :memberships, dependent: :destroy, foreign_key: :basic_resource_group_id
    has_many :users, through: :memberships

    validates :name, presence: true

    def admin?(user)
      memberships.where(
        role: Membership::ROLES[:admin],
        user_id: user.id
      ).any?
    end
  end
end
