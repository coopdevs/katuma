# This migration does not use Rails ActiveRecord ORM DSL since
# it doesn't provide data integrity (foreign key) for polymorphic models.
#
# The technique applied is called Exclusive Belongs To (AKA Exclusive Arc)
#
# Please read the following article for more details:
#
# https://hashrocket.com/blog/posts/modeling-polymorphic-associations-in-a-relational-database
#
class AddProducersMembership < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE producers_memberships (
        id          serial PRIMARY KEY,
        producer_id integer NOT NULL REFERENCES producers,
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
        )
      );

      CREATE UNIQUE INDEX ON producers_memberships (producer_id, user_id) WHERE user_id IS NOT NULL;
      CREATE UNIQUE INDEX ON producers_memberships (producer_id, group_id) WHERE group_id IS NOT NULL;
    SQL
  end

  def down
    drop_table :producers_memberships
  end
end
