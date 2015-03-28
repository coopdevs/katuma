module Group
  class MembershipsSerializer < BaseSerializer

    schema do
      type 'memberships'

      collection :memberships, item, MembershipSerializer
    end
  end
end
