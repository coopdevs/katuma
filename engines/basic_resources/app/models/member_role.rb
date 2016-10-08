class MemberRole
  def initialize(role)
    @index = index_from(role)
  end

  def to_i
    index
  end

  private

  attr_reader :index

  def index_from(role)
    case role
    when :admin
      1
    when :member
      2
    end
  end
end
