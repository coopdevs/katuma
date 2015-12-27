module Group
  class Membership < ActiveRecord::Base

    self.table_name = :memberships

    belongs_to :group
    belongs_to :user

    validates :group, :user, :role, presence: true
    validates :user_id, uniqueness: { scope: :group_id }

    def role=(value)
      @role = Role.new(value)
      self[:role] = @role.index
      @role
    end

    def role
      @role ||= Role.from_index(self[:role])
    end
  end
end
