require 'rails_helper'

module Suppliers
  module OrdersCollection
    describe ToGroup do
      let(:group_admin) do
        FactoryGirl.create(:user)
      end
      let(:group_member) do
        FactoryGirl.create(:user)
      end
      let(:group) { FactoryGirl.create(:group) }
      let!(:admin_group_membership) do
        FactoryGirl.create(
          :membership,
          basic_resource_group_id: group.id,
          user_id: group_admin.id,
          role: Membership::ROLES[:admin]
        )
      end
      let!(:member_group_membership) do
        FactoryGirl.create(
          :membership,
          basic_resource_group_id: group.id,
          user_id: group_member.id,
          role: Membership::ROLES[:member]
        )
      end

      describe '#relation' do
        let!(:first_order) do
          FactoryGirl.create(
            :order,
            from_user_id: group_admin.id,
            to_group_id: group.id,
            confirm_before: Time.now.utc
          )
        end
        let!(:second_order) do
          FactoryGirl.create(
            :order,
            from_user_id: group_admin.id,
            to_group_id: group.id,
            confirm_before: Time.at(1318996912).utc.to_datetime
          )
        end
        let!(:other_order) do
          FactoryGirl.create(
            :order,
            from_user_id: group_member.id,
            to_group_id: group.id,
            confirm_before: Time.now.utc
          )
        end

        subject { described_class.new(user: group_admin, params: params).relation }

        context 'passing no parameters' do
          let(:params) { {} }

          it do
            is_expected.to match(
              [
                first_order,
                second_order
              ]
            )
          end
        end

        context 'passing `confirm_before` parameter' do
          let(:params) do
            {
              confirm_before: Time.at(1318996912).utc.to_datetime
            }
          end

          it do
            is_expected.to match(
              [
                second_order
              ]
            )
          end
        end

        context 'passing `to_group_id` parameter' do
          context 'without passing `all` parameter' do
            let(:params) do
              {
                to_group_id: group.id
              }
            end

            it do
              is_expected.to match(
                [
                  first_order,
                  second_order
                ]
              )
            end
          end

          context 'passing `all` parameter' do
            let(:params) do
              {
                to_group_id: group.id,
                all: true
              }
            end

            it do
              is_expected.to match(
                [
                  first_order,
                  second_order,
                  other_order
                ]
              )
            end
          end
        end
      end
    end
  end
end
