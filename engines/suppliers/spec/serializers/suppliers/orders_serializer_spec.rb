require 'rails_helper'

module Suppliers
  describe OrdersSerializer do
    let(:first_order) do
      instance_double(
        Order,
        id: 13,
        from_user_id: 333,
        to_group_id: 666,
        confirm_before: Time.now.utc,
        created_at: Time.now.utc,
        updated_at: Time.now.utc
      )
    end
    let(:second_order) do
      instance_double(
        Order,
        id: 17,
        from_user_id: 335,
        to_group_id: 667,
        confirm_before: Time.now.utc,
        created_at: Time.now.utc,
        updated_at: Time.now.utc
      )
    end
    let(:first_order_attributes) do
      {
        id: first_order.id,
        user_id: first_order.user_id,
        group_id: first_order.group_id,
        confirm_before: first_order.confirm_before,
        created_at: first_order.created_at,
        updated_at: first_order.updated_at
      }
    end
    let(:second_order_attributes) do
      {
        id: second_order.id,
        user_id: second_order.user_id,
        group_id: second_order.group_id,
        confirm_before: second_order.confirm_before,
        created_at: second_order.created_at,
        updated_at: second_order.updated_at
      }
    end

    subject { described_class.new([first_order, second_order]).to_hash }

    it do
      is_expected.to contain_exactly(
        match(first_order_attributes),
        match(second_order_attributes)
      )
    end
  end
end
