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
    when :member
      1
    end
  end
end
