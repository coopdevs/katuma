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
              from_user_id: user.id,
              to_group_id: group.id,
              confirm_before: 3.days.from_now.utc
            )
          end
          let(:other_order) do
            FactoryGirl.create(
              :order,
              from_user_id: user.id,
              to_group_id: group.id,
              confirm_before: 4.days.from_now.utc
            )
          end
          let(:other_user_order) do
            FactoryGirl.create(
              :order,
              from_user_id: other_user.id,
              to_group_id: group.id,
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
                  {
                    'id' => order.id,
                    'from_user_id' => order.from_user_id,
                    'from_group_id' => order.from_group_id,
                    'to_group_id' => order.to_group_id,
                    'to_producer_id' => order.to_producer_id,
                    'confirm_before' => order.confirm_before.to_i,
                    'created_at' => order.created_at.to_i,
                    'updated_at' => order.updated_at.to_i
                  },
                  {
                    'id' => other_order.id,
                    'from_user_id' => other_order.from_user_id,
                    'from_group_id' => other_order.from_group_id,
                    'to_group_id' => other_order.to_group_id,
                    'to_producer_id' => other_order.to_producer_id,
                    'confirm_before' => other_order.confirm_before.to_i,
                    'created_at' => other_order.created_at.to_i,
                    'updated_at' => other_order.updated_at.to_i
                  }
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
                    is_expected.to eq(
                      'id' => order.id,
                      'from_user_id' => order.from_user_id,
                      'from_group_id' => order.from_group_id,
                      'to_group_id' => order.to_group_id,
                      'to_producer_id' => order.to_producer_id,
                      'confirm_before' => order.confirm_before.to_i,
                      'created_at' => order.created_at.to_i,
                      'updated_at' => order.updated_at.to_i
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
                to_group_id: group.id,
                confirm_before: 3.days.from_now.utc.as_json
              }
            end

            context 'when the user is associated to the group' do
              it_behaves_like 'a successful request' do
                subject { post :create, params }
              end

              describe 'its body' do
                before { post :create, params }

                subject { JSON.parse(response.body) }

                it do
                  is_expected.to include(
                    'from_user_id' => user.id,
                    'to_group_id' => params[:to_group_id],
                    'confirm_before' => DateTime.parse(params[:confirm_before]).to_i
                  )
                end
              end
            end

            context 'when the user is not associated to the group' do
              before { group_membership.destroy! }

              it_behaves_like 'a forbidden request' do
                subject { post :create, params }
              end
            end

            context 'with wrong parameters' do
              let(:params) { { to_group_id: group.id, confirm_before: nil } }

              it_behaves_like 'a bad request' do
                subject { post :create, params }
              end

              describe 'its body' do
                subject { JSON.parse(response.body) }

                before { post :create, params }

                it do
                  is_expected.to eq(
                    'errors' => { 'confirm_before' => ["can't be blank"] }
                  )
                end
              end

              context 'passing a non existent group_id' do
                let(:params) { { to_group_id: 666 } }

                it_behaves_like 'a not found request' do
                  subject { post :create, params }
                end
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
                      'to_group_id' => order.to_group_id,
                      'created_at' => order.created_at.to_i
                    )
                  end
                end
              end

              context 'with not valid parameters' do
                let(:params) { { id: order_id, to_group_id: nil } }

                it_behaves_like 'a bad request'

                describe 'its body' do
                  before { put :update, params }

                  subject { JSON.parse(response.body) }

                  it { is_expected.to have_key('errors') }
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
