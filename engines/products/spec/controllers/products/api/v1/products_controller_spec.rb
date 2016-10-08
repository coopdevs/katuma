require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module Products
  module Api
    module V1
      describe ProductsController do
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
            subject { put :update, id: 666, name: 'ciola' }

            it_behaves_like 'an unauthorized request'
          end

          describe 'DELETE #destroy' do
            subject { delete :destroy, id: 666 }

            it_behaves_like 'an unauthorized request'
          end
        end

        context 'Authenticated user' do
          let(:user) do
            FactoryGirl.create(:user)
          end
          let(:group_user) { ::BasicResources::User.find(user.id) }
          let(:producers_user) { User.find(user.id) }
          let(:group) { FactoryGirl.create(:group) }
          let!(:group_membership) do
            FactoryGirl.create(
              :membership,
              user: group_user,
              basic_resource_group_id: group.id
            )
          end
          let(:producer_for_group) do
            producer = FactoryGirl.build(:producer, name: 'Related to group')
            ::BasicResources::ProducerCreator.new(
              producer: producer,
              creator: producers_user,
              group: group
            ).create
          end
          let(:producer_for_user) do
            producer = FactoryGirl.build(:producer, name: 'Related to user')
            ::BasicResources::ProducerCreator.new(
              producer: producer,
              creator: ::BasicResources::User.find(producers_user.id)
            ).create
          end

          before { authenticate_as producers_user }

          describe 'GET #index' do
            let!(:first_product) do
              FactoryGirl.create(
                :product,
                producer: producer_for_group
              )
            end
            let!(:second_product) do
              FactoryGirl.create(
                :product,
                producer: producer_for_group
              )
            end

            subject { get :index, producer_id: producer_for_group.id }

            it_behaves_like 'a successful request'

            describe 'its body' do
              before { get :index, producer_id: producer_for_group.id }

              subject { JSON.parse(response.body) }

              its(:size) { is_expected.to eq(2) }
              it { is_expected.to include(JSON.parse(first_product.to_json)) }
              it { is_expected.to include(JSON.parse(second_product.to_json)) }
            end
          end

          describe 'GET #show' do
            let(:product) do
              FactoryGirl.create(
                :product,
                producer: producer_for_group
              )
            end

            context 'requesting a non existent product' do
              subject { get :show, id: 666 }

              it_behaves_like 'a not found request'
            end

            context 'requesting an existent product' do
              subject { get :show, id: product.id }

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { get :show, id: product.id }

                subject { JSON.parse(response.body) }

                it { is_expected.to include(JSON.parse(product.to_json)) }
              end
            end

            context 'requesting a product not associated to the current user' do
              let(:another_user) { FactoryGirl.create(:user) }
              let(:producers_user) { User.find(another_user.id) }

              subject { get :show, id: product.id }

              it_behaves_like 'a forbidden request'
            end
          end

          describe 'POST #create' do
            subject { post :create, params }

            context 'when the producer is directly associated to the user' do
              let(:params) do
                {
                  name: 'Tomatekken',
                  price: 10.13,
                  unit: Product::UNITS[:kg],
                  producer_id: producer_for_user.id
                }
              end

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { post :create, params }

                subject { JSON.parse(response.body) }

                its(['name']) { is_expected.to eq(params[:name]) }
                its(['price']) { is_expected.to eq(params[:price].to_s) }
                its(['unit']) { is_expected.to eq(params[:unit]) }
                its(['producer_id']) { is_expected.to eq(params[:producer_id]) }
              end

              context 'and the user is not a producer admin' do
                before do
                  producer_membership = ::BasicResources::Membership.where(
                    user_id: producers_user.id,
                    basic_resource_producer_id: producer_for_user.id
                  ).first
                  producer_membership.update_attribute(:role, Membership::ROLES[:member])
                end

                it_behaves_like 'a forbidden request'
              end
            end

            context 'when the producer is associated to the user through a group' do
              let(:params) do
                {
                  name: 'Tomatekken',
                  price: 10.13,
                  unit: Product::UNITS[:kg],
                  producer_id: producer_for_group.id
                }
              end

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { post :create, params }

                subject { JSON.parse(response.body) }

                its(['name']) { is_expected.to eq(params[:name]) }
                its(['price']) { is_expected.to eq(params[:price].to_s) }
                its(['unit']) { is_expected.to eq(params[:unit]) }
                its(['producer_id']) { is_expected.to eq(params[:producer_id]) }
              end

              context 'and the user is not a group admin' do
                before do
                  group_membership.role = ::BasicResources::Membership::ROLES[:member]
                  group_membership.save
                end

                it_behaves_like 'a forbidden request'
              end
            end

            context 'with wrong parameters' do
              let(:params) do
                {
                  name: 'Tomatekken',
                  unit: 42,
                  producer_id: producer_for_group.id
                }
              end

              it_behaves_like 'a bad request'

              describe 'its body' do
                before { post :create, params }

                subject { JSON.parse(response.body) }

                its(:size) { is_expected.to eq(2) }
                it { is_expected.to include('price' => ["can't be blank", 'is not a number']) }
                it { is_expected.to include('unit' => ['is not included in the list']) }
              end
            end
          end

          describe 'PUT #update' do
            let(:params) do
              {
                id: product.id,
                name: 'New name'
              }
            end

            subject { put :update, params }

            context 'updating a non existent product' do
              let(:product) { instance_double(Product, id: 666) }

              it_behaves_like 'a not found request'
            end

            context 'updating an existent product' do
              context 'when the producer is directly associated to the user' do
                let(:product) do
                  FactoryGirl.create(:product, producer: producer_for_user)
                end

                context 'when the user is a producer admin' do
                  it_behaves_like 'a successful request'

                  describe 'its body' do
                    before { put :update, params }

                    subject { JSON.parse(response.body) }

                    its(['name']) { is_expected.to eq(params[:name]) }
                  end
                end

                context 'when the user is not a producer admin' do
                  before do
                    producer_membership = ::BasicResources::Membership.where(
                      user_id: producers_user,
                      basic_resource_producer_id: producer_for_user
                    ).first
                    producer_membership.update_attribute(:role, Membership::ROLES[:member])
                  end

                  it_behaves_like 'a forbidden request'
                end
              end

              context 'when the producer is associated to the user through a group' do
                let!(:product) do
                  FactoryGirl.create(:product, producer: producer_for_group)
                end

                it_behaves_like 'a successful request'

                describe 'its body' do
                  before { put :update, params }

                  subject { JSON.parse(response.body) }

                  its(['name']) { is_expected.to eq(params[:name]) }
                end

                context 'when the user is not a group admin' do
                  before do
                    group_membership.update_attribute(:role, Membership::ROLES[:member])
                  end

                  it_behaves_like 'a forbidden request'
                end
              end

              context 'with wrong parameters' do
                let(:product) do
                  FactoryGirl.create(:product, producer: producer_for_user)
                end
                let(:params) { { id: product.id, unit: 42 } }

                it_behaves_like 'a bad request'

                describe 'its body' do
                  before { put :update, params }

                  subject { JSON.parse(response.body) }

                  its(:size) { is_expected.to eq(1) }
                  it { is_expected.to include('unit' => ['is not included in the list']) }
                end
              end
            end
          end

          describe 'DELETE #destroy' do
            let(:id) { product.id }

            subject { delete :destroy, id: id }

            context 'destroying a non existent product' do
              let(:product) { instance_double(Product, id: 666) }

              it_behaves_like 'a not found request'
            end

            context 'destroying an existent product' do
              context 'when the producer is directly associated to the user' do
                let(:product) do
                  FactoryGirl.create(
                    :product,
                    producer: producer_for_user
                  )
                end

                context 'when the user is a producer admin' do
                  it_behaves_like 'a successful request (204)'
                end

                context 'when the user is not a producer admin' do
                  before do
                    producer_membership = ::BasicResources::Membership.where(
                      user: producers_user,
                      basic_resource_producer_id: producer_for_user.id
                    ).first
                    producer_membership.role = ::BasicResources::Membership::ROLES[:member]
                    producer_membership.save
                  end

                  it_behaves_like 'a forbidden request'
                end
              end

              context 'when the producer is associated to the user through a group' do
                let(:product) do
                  FactoryGirl.create(:product, producer: producer_for_group)
                end

                context 'when the user is a group admin' do
                  it_behaves_like 'a successful request (204)'
                end

                context 'when the user is not a group admin' do
                  before do
                    group_membership.update_attribute(:role, Membership::ROLES[:member])
                  end

                  it_behaves_like 'a forbidden request'
                end
              end

              context 'when the producer is not associated to the current user' do
                let(:product) do
                  FactoryGirl.create(:product, producer: producer_for_group)
                end
                let(:another_user) do
                  user = FactoryGirl.create(:user)
                  User.find(user.id)
                end

                before { authenticate_as another_user }

                it_behaves_like 'a forbidden request'
              end
            end
          end
        end
      end
    end
  end
end
