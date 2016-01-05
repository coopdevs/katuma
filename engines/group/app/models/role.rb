class Role
  include Comparable

  attr_reader :index

  class InvalidRole < ArgumentError; end

  VALUES = { admin: 1, member: 2, waiting: 3 }

  def self.from_index(index)
    case index
    when 1
      new(:admin)
    when 2
      new(:member)
    when 3
      new(:waiting)
    end
  end

  def initialize(role)
    validate!(role)

    @role = role
    @index = VALUES[role]
  end

  def validate!(role)
    return if VALUES.key?(role)
    raise InvalidRole, 'No supported role'
  end

  def <=>(other)
    other.to_s <=> to_s
  end

  def hash
    role.hash
  end

  def eql?(other)
    to_s == other.to_s
  end

  def to_s
    role.to_s
  end

  private

  attr_reader :role
end
