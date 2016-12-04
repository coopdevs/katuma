require 'rails_helper'
require 'pundit/rspec'

module Suppliers
  describe OrderPolicy do
    subject { described_class }

    permissions :show?, :update?, :destroy? do
      let(:user) { FactoryGirl.create(:user) }
      let(:group) { FactoryGirl.create(:group) }
      let(:order) do
        FactoryGirl.create(
          :order,
          user_id: user.id,
          group_id: group.id,
          confirm_before: 3.days.from_now.utc
        )
      end

      context "when the current user is the order's user" do
        it 'grants access' do
          expect(subject).to permit(user, order)
        end
      end

      context "when the current user is not the order's user" do
        let(:other_user) { FactoryGirl.create(:user) }

        it 'denies access' do
          expect(subject).to_not permit(other_user, order)
        end
      end
    end

    permissions :create? do
      it 'is set to `false` by default' do
        expect(subject).to_not permit(instance_double(User), instance_double(Producer))
      end
    end
  end
end
