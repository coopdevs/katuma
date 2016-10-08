module BasicResources
  class MembershipSerializer < ::Shared::BaseSerializer
    schema do
      type 'membership'

      map_properties :id, :basic_resource_group_id, :basic_resource_producer_id, :group_id,
        :user_id, :role, :created_at, :updated_at
    end
  end
end
