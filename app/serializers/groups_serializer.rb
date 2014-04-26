class GroupsSerializer < BaseSerializer

  schema do
    type 'groups'

    collection :groups, item, GroupSerializer
  end
end
