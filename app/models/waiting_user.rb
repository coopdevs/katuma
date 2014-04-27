class WaitingUser
  attr_reader :group

  def initialize(group, user = nil)
    @group = group
    @user = user
  end

  def list
    User.with_role(:waiting_user, @group)
  end

  def add!
    @user.add_role :waiting_user, @group
  end

  def remove!
    @user.remove_role :waiting_user, @group
  end
end
