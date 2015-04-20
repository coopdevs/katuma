module Group
  class GroupsSerializer < Shared::BaseSerializer

    schema do
      type 'groups'

      collection :groups, item, GroupSerializer
    end
  end
end
