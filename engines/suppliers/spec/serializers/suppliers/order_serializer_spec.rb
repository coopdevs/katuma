require 'rails_helper'

module Suppliers
  describe OrderSerializer do
    let(:user) { FactoryGirl.build(:user) }
    let(:group) { FactoryGirl.build(:group) }
    let(:order) do
      FactoryGirl.build(
        :order,
        from_user_id: user.id,
        to_group_id: group.id,
        confirm_before: Time.now.utc
      )
    end

    subject { described_class.new(order).to_hash }

    it do
      is_expected.to eq(
        id: order.id,
        from_user_id: order.from_user_id,
        to_group_id: order.to_group_id,
        from_group_id: nil,
        to_producer_id: nil,
        confirm_before: order.confirm_before.to_i,
        created_at: order.created_at.to_i,
        updated_at: order.updated_at.to_i
      )
    end
  end
end
