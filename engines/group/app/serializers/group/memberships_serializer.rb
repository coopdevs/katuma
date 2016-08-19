module Group
  class MembershipsSerializer < ::Shared::BaseSerializer
    schema do
      type 'memberships'

      collection :memberships, item, MembershipSerializer
    end
  end
end
