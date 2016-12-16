require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module Suppliers
  module Api
    module V1
      describe OrderLinesController do
        routes { Engine.routes }

        context 'Not authenticaded user' do
          describe 'GET #index' do
            subject { get :index }

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
          let!(:producer_for_group) do
            producer = FactoryGirl.build(:producer, name: 'Related to group')
            ::BasicResources::ProducerCreator.new(
              producer: producer,
              creator: user,
              group: group
            ).create!
          end
          let!(:manzana) do
            FactoryGirl.create(
              :product,
              producer_id: producer_for_group.id,
              price: 1.99
            )
          end
          let!(:pera) do
            FactoryGirl.create(
              :product,
              producer_id: producer_for_group.id,
              price: 1.99
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
          let(:order_line_manzana) do
            FactoryGirl.create(
              :order_line,
              order_id: order.id,
              quantity: 1,
              price: 1.99,
              product_id: manzana.id
            )
          end
          let(:order_line_pera) do
            FactoryGirl.create(
              :order_line,
              order_id: order.id,
              quantity: 1,
              price: 2.05,
              product_id: pera.id
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
          let(:other_order_line) do
            FactoryGirl.create(
              :order_line,
              order_id: other_user_order.id,
              quantity: 1,
              price: 2.05,
              product_id: pera.id
            )
          end

          before { authenticate_as user }

          describe 'GET #index' do
            subject { get :index, order_id: order.id }

            it_behaves_like 'a successful request'

            describe 'its body' do
              before { order_line_manzana }
              before { order_line_pera }

              before { get :index, order_id: order.id }

              subject { JSON.parse(response.body) }

              it do
                is_expected.to contain_exactly(
                  match(
                    'id' => order_line_manzana.id,
                    'order_id' => order.id,
                    'product_id' => manzana.id,
                    'quantity' => order_line_manzana.quantity,
                    'price' => order_line_manzana.price.to_s,
                    'created_at' => order_line_manzana.created_at.to_i,
                    'updated_at' => order_line_manzana.updated_at.to_i
                  ),
                  match(
                    'id' => order_line_pera.id,
                    'order_id' => order.id,
                    'product_id' => pera.id,
                    'quantity' => order_line_pera.quantity,
                    'price' => order_line_pera.price.to_s,
                    'created_at' => order_line_pera.created_at.to_i,
                    'updated_at' => order_line_pera.updated_at.to_i
                  )
                )
              end
            end
          end

          describe 'PUT #update' do
            let(:params) do
              {
                id: order_line_id,
                quantity: 3
              }
            end

            before { order_line_manzana }

            subject { put :update, params }

            context 'updating a non existent order_line' do
              let(:order_line_id) { 666 }

              it_behaves_like 'a not found request'
            end

            context 'when the user is associated to the order' do
              let(:order_line_id) { order_line_manzana.id }

              context 'with valid parameters' do
                it_behaves_like 'a successful request'

                describe 'its body' do
                  before { put :update, params }

                  subject { JSON.parse(response.body) }

                  it do
                    is_expected.to match(
                      'id' => order_line_manzana.id,
                      'order_id' => order.id,
                      'product_id' => manzana.id,
                      'quantity' => params[:quantity],
                      'price' => order_line_manzana.price.to_s,
                      'updated_at' => order_line_manzana.updated_at.to_i,
                      'created_at' => order_line_manzana.created_at.to_i
                    )
                  end
                end
              end

              context 'with not valid parameters' do
                let(:params) do
                  {
                    id: order_line_id,
                    order_id: nil
                  }
                end

                it_behaves_like 'a bad request'

                describe 'its body' do
                  before { put :update, params }

                  subject { JSON.parse(response.body) }

                  it do
                    is_expected.to match(
                      'errors' => {
                        'order' => ["can't be blank"]
                      }
                    )
                  end
                end
              end
            end

            context 'when the user is not associated to the order' do
              let(:order_line_id) { other_order_line.id }

              it_behaves_like 'a forbidden request'
            end
          end

          describe 'PUT #destroy' do
            subject { delete :destroy, id: order_line_id }

            context 'destroying a non existent order_line' do
              let(:order_line_id) { 666 }

              it_behaves_like 'a not found request'
            end

            context 'when the user is associated to the order' do
              let(:order_line_id) { order_line_manzana.id }

              it_behaves_like 'a successful request (204)'
            end

            context 'when the user is not associated to the order' do
              let(:order_line_id) { other_order_line.id }

              it_behaves_like 'a forbidden request'
            end
          end
        end
      end
    end
  end
end
