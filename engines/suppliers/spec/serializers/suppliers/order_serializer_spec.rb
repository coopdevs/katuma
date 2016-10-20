require 'rails_helper'

module Suppliers
  describe OrderSerializer do
    let(:user) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group) }
    let(:order) do
      FactoryGirl.create(
        :order,
        user_id: user.id,
        group_id: group.id,
        confirm_before: Time.now.utc
      )
    end
    let(:attributes) do
      {
        id: order.id,
        user_id: order.user_id,
        group_id: order.group_id,
        confirm_before: order.confirm_before,
        created_at: order.created_at,
        updated_at: order.updated_at
      }
    end

    subject { described_class.new(order).to_hash }

    it { is_expected.to match(attributes) }
  end
end
