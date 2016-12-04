require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module Suppliers
  module Api
    module V1
      describe OrdersController do
        routes { Engine.routes }

        context 'Not authenticaded user' do
          describe 'GET #index' do
            subject { get :index }

            it_behaves_like 'an unauthorized request'
          end

          describe 'GET #show' do
            subject { get :show, id: 666 }

            it_behaves_like 'an unauthorized request'
          end

          describe 'POST #create' do
            subject { post :create, name: 'ciola' }

            it_behaves_like 'an unauthorized request'
          end

          describe 'PUT #update' do
            subject { put :update, id: 666 }

            it_behaves_like 'an unauthorized request'
          end
        end

        context 'Authenticated user' do
          let(:user) do
            u = FactoryGirl.create(:user)
            User.find(u.id)
          end
          let(:other_user) do
            u = FactoryGirl.create(:user)
            User.find(u.id)
          end
          let(:group) { FactoryGirl.create(:group) }
          let!(:group_membership) do
            FactoryGirl.create(
              :membership,
              basic_resource_group_id: group.id,
              user_id: user.id,
              role: ::BasicResources::Membership::ROLES[:admin]
            )
          end
          let(:order) do
            FactoryGirl.create(
              :order,
              user_id: user.id,
              group_id: group.id,
              confirm_before: 3.days.from_now.utc
            )
          end
          let(:other_order) do
            FactoryGirl.create(
              :order,
              user_id: user.id,
              group_id: group.id,
              confirm_before: 4.days.from_now.utc
            )
          end
          let(:other_user_order) do
            FactoryGirl.create(
              :order,
              user_id: other_user.id,
              group_id: group.id,
              confirm_before: 5.days.from_now.utc
            )
          end

          before { authenticate_as user }

          describe 'GET #index' do
            before { order }
            before { other_order }
            before { other_user_order }

            subject { get :index, group_id: group_id }

            let(:group_id) { group.id }

            it_behaves_like 'a successful request'

            describe 'its body' do
              before { get :index, group_id: group.id }

              subject { JSON.parse(response.body) }

              it do
                is_expected.to contain_exactly(
                  match(
                    'id' => order.id,
                    'user_id' => order.user_id,
                    'group_id' => order.group_id,
                    'confirm_before' => order.confirm_before.as_json,
                    'created_at' => order.created_at.as_json,
                    'updated_at' => order.updated_at.as_json
                  ),
                  match(
                    'id' => other_order.id,
                    'user_id' => other_order.user_id,
                    'group_id' => other_order.group_id,
                    'confirm_before' => other_order.confirm_before.as_json,
                    'created_at' => other_order.created_at.as_json,
                    'updated_at' => other_order.updated_at.as_json
                  )
                )
              end
            end
          end

          describe 'GET #show' do
            before { order }

            subject { get :show, id: order_id }

            context 'requesting a non existent order' do
              let(:order_id) { 666 }

              it_behaves_like 'a not found request'
            end

            context 'requesting an existent order' do
              context 'when the user is associated to the group' do
                let(:order_id) { order.id }

                it_behaves_like 'a successful request'

                describe 'its body' do
                  before { get :show, id: order_id }

                  subject { JSON.parse(response.body) }

                  it do
                    is_expected.to match(
                      'id' => order.id,
                      'user_id' => order.user_id,
                      'group_id' => order.group_id,
                      'confirm_before' => order.confirm_before.as_json,
                      'created_at' => order.created_at.as_json,
                      'updated_at' => order.updated_at.as_json
                    )
                  end
                end
              end

              context 'when the user is not associated to the order' do
                let(:order_id) { other_user_order.id }

                it_behaves_like 'a forbidden request'
              end
            end
          end

          describe 'POST #create' do
            let(:params) do
              {
                group_id: group.id,
                confirm_before: 3.days.from_now.utc.as_json
              }
            end

            subject { post :create, params }

            context 'when the user is associated to the group' do
              it_behaves_like 'a successful request'

              describe 'its body' do
                before { post :create, params }

                subject { JSON.parse(response.body) }

                it do
                  is_expected.to include(
                    'user_id' => user.id,
                    'group_id' => params[:group_id],
                    'confirm_before' => params[:confirm_before]
                  )
                end
              end
            end

            context 'when the user is not associated to the group' do
              before { group_membership.destroy! }

              it_behaves_like 'a forbidden request'
            end

            context 'with wrong parameters' do
              let(:params) do
                {
                  group_id: group.id
                }
              end

              it_behaves_like 'a bad request'

              describe 'its body' do
                before { post :create, params }

                subject { JSON.parse(response.body) }

                it do
                  is_expected.to match(
                    'errors' => {
                      'confirm_before' => ["can't be blank"]
                    }
                  )
                end
              end

              context 'passing a non existent group_id' do
                let(:params) do
                  {
                    group_id: 666
                  }
                end

                it_behaves_like 'a not found request'
              end
            end
          end

          describe 'PUT #update' do
            let(:params) do
              {
                id: order_id,
                confirm_before: 1.week.from_now.utc.as_json
              }
            end

            before { order }

            subject { put :update, params }

            context 'updating a non existent order' do
              let(:order_id) { 666 }

              it_behaves_like 'a not found request'
            end

            context 'when the user is associated to the order' do
              let(:order_id) { order.id }

              context 'with valid parameters' do
                it_behaves_like 'a successful request'

                describe 'its body' do
                  before { put :update, params }

                  subject { JSON.parse(response.body) }

                  it do
                    is_expected.to include(
                      'id' => order.id,
                      'group_id' => order.group_id,
                      'created_at' => order.created_at.as_json
                    )
                  end
                end
              end

              context 'with not valid parameters' do
                let(:params) do
                  {
                    id: order_id,
                    group_id: nil
                  }
                end

                it_behaves_like 'a bad request'

                describe 'its body' do
                  before { put :update, params }

                  subject { JSON.parse(response.body) }

                  it do
                    is_expected.to match(
                      'errors' => {
                        'group' => ["can't be blank"]
                      }
                    )
                  end
                end
              end
            end

            context 'when the user is not associated to the order' do
              let(:order_id) { other_user_order.id }

              it_behaves_like 'a forbidden request'
            end
          end

          describe 'PUT #destroy' do
            subject { delete :destroy, id: order_id }

            context 'destroying a non existent order' do
              let(:order_id) { 666 }

              it_behaves_like 'a not found request'
            end

            context 'when the user is associated to the order' do
              let(:order_id) { order.id }

              it_behaves_like 'a successful request (204)'
            end

            context 'when the user is not associated to the order' do
              let(:order_id) { other_user_order.id }

              it_behaves_like 'a forbidden request'
            end
          end
        end
      end
    end
  end
end
