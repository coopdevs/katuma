module Account
  class UserPolicy < Shared::ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def show?
      record == user
    end

    def update?
      record == user
    end

    def destroy?
      record == user
    end
  end
end
