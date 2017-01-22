require 'rails_helper'
require 'pundit/rspec'

module Suppliers
  describe OrderPolicy do
    subject { described_class }

    permissions :show?, :update?, :destroy? do
      let(:user) { FactoryGirl.build(:user) }
      let(:group) { FactoryGirl.build(:group) }
      let(:order) do
        FactoryGirl.build(
          :order,
          from_user_id: user.id,
          to_group_id: group.id,
          confirm_before: 3.days.from_now.utc
        )
      end

      context "when the current user is the order's user" do
        it { is_expected.to permit(user, order) }
      end

      context "when the current user is not the order's user" do
        let(:other_user) { FactoryGirl.create(:user) }

        it { is_expected.not_to permit(other_user, order) }
      end
    end

    permissions :create? do
      it do
        is_expected
          .not_to permit(instance_double(User), instance_double(Producer))
      end
    end
  end
end
