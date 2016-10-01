# This migration does not use Rails ActiveRecord ORM DSL since
# it doesn't provide data integrity (foreign key) for polymorphic models.
#
# The technique applied is called Exclusive Belongs To (AKA Exclusive Arc)
#
# Please read the following article for more details:
#
# https://hashrocket.com/blog/posts/modeling-polymorphic-associations-in-a-relational-database
#
class CreateMemberships < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE memberships (
        id          serial PRIMARY KEY,
        basic_resource_producer_id integer REFERENCES producers,
        basic_resource_group_id integer REFERENCES groups,
        user_id     integer REFERENCES users,
        group_id    integer REFERENCES groups,
        role        integer NOT NULL CHECK (role IN (1, 2)),
        created_at  timestamp without time zone,
        updated_at  timestamp without time zone,
        CHECK(
          (
            (user_id IS NOT NULL)::integer +
            (group_id IS NOT NULL)::integer
          ) = 1
        ),
        CHECK(
          (
            (basic_resource_producer_id IS NOT NULL)::integer +
            (basic_resource_group_id IS NOT NULL)::integer
          ) = 1
        )
      );

      CREATE UNIQUE INDEX ON memberships (basic_resource_producer_id, user_id) WHERE user_id IS NOT NULL;
      CREATE UNIQUE INDEX ON memberships (basic_resource_producer_id, group_id) WHERE group_id IS NOT NULL;
      CREATE UNIQUE INDEX ON memberships (basic_resource_group_id, user_id) WHERE user_id IS NOT NULL;
      CREATE UNIQUE INDEX ON memberships (basic_resource_group_id, group_id) WHERE group_id IS NOT NULL;
    SQL
  end

  def down
    drop_table :memberships
  end
end
