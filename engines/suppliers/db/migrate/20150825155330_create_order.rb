class CreateOrder < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE orders (
        id             serial  PRIMARY KEY,
        from_user_id   integer REFERENCES users,
        from_group_id  integer REFERENCES groups,
        to_group_id    integer REFERENCES groups,
        to_producer_id integer REFERENCES producers,
        confirm_before timestamp without time zone NOT NULL,
        created_at     timestamp without time zone NOT NULL,
        updated_at     timestamp without time zone NOT NULL,
        CHECK(
          (
            (from_user_id IS NOT NULL)::integer +
            (from_group_id IS NOT NULL)::integer
          ) = 1
        ),
        CHECK(
          (
            (to_group_id IS NOT NULL)::integer +
            (to_producer_id IS NOT NULL)::integer
          ) = 1
        )
      );

      CREATE INDEX ON orders (from_user_id, to_group_id);
      CREATE INDEX ON orders (from_group_id, to_producer_id);
    SQL
  end

  def down
    drop_table :orders
  end
end
