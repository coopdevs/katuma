require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module Suppliers
  module Api
    module V1
      describe SuppliersController do
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

          describe 'DELETE #destroy' do
            subject { delete :destroy, id: 666 }

            it_behaves_like 'an unauthorized request'
          end
        end

        context 'Authenticated user' do
          let(:user) do
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
          let(:producer_for_group) do
            FactoryGirl.build(:producer, name: 'Related to group')
          end
          let(:producer) do
            ::BasicResources::ProducerCreator.new(
              producer: producer_for_group,
              creator: user,
              group: group
            ).create!
          end

          before { authenticate_as user }

          describe 'GET #index' do
            let!(:supplier) do
              FactoryGirl.create(
                :supplier,
                group_id: group.id,
                producer_id: producer.id
              )
            end

            subject { get :index, group_id: group.id }

            it_behaves_like 'a successful request'

            describe 'its body' do
              before { get :index, group_id: group.id }

              subject { JSON.parse(response.body) }

              its(:size) { is_expected.to eq(1) }

              it do
                is_expected.to include(
                  'id' => supplier.id,
                  'group_id' => supplier.group_id,
                  'producer_id' => supplier.producer_id,
                  'created_at' => supplier.created_at.as_json,
                  'updated_at' => supplier.updated_at.as_json
                )
              end
            end
          end

          describe 'GET #show' do
            let(:supplier) do
              FactoryGirl.create(
                :supplier,
                producer_id: producer.id,
                group_id: group.id
              )
            end
            let(:params) { { id: supplier.id } }

            subject { get :show, params }

            context 'requesting a non existent supplier' do
              let(:supplier) { instance_double(Supplier, id: 666) }

              it_behaves_like 'a not found request'
            end

            context 'requesting a supplier associated to a group' do
              context 'when the user is associated to the group' do
                it_behaves_like 'a successful request'

                describe 'its body' do
                  before { get :show, params }

                  subject { JSON.parse(response.body) }

                  it do
                    is_expected.to include(
                      'id' => supplier.id,
                      'group_id' => supplier.group_id,
                      'producer_id' => supplier.producer_id,
                      'created_at' => supplier.created_at.as_json,
                      'updated_at' => supplier.updated_at.as_json
                    )
                  end
                end
              end

              context 'when the user is not associated to the group' do
                before { group_membership.destroy! }

                it_behaves_like 'a forbidden request'
              end
            end
          end

          describe 'POST #create' do
            let(:params) do
              {
                group_id: group.id,
                producer_id: producer.id
              }
            end

            subject { post :create, params }

            context 'when the user is associated to the group' do
              context 'as an `admin`' do
                it_behaves_like 'a successful request'

                describe 'its body' do
                  before { post :create, params }

                  subject { JSON.parse(response.body) }

                  its(['group_id']) { is_expected.to eq(params[:group_id]) }
                  its(['producer_id']) { is_expected.to eq(params[:producer_id]) }
                end
              end

              context 'as a `member`' do
                before do
                  group_membership.role = ::BasicResources::Membership::ROLES[:member]
                  group_membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end

            context 'when the user is not associated to the group' do
              before { group_membership.destroy! }

              it_behaves_like 'a forbidden request'
            end

            context 'with wrong `producer_id` parameter' do
              let(:params) do
                {
                  group_id: 666,
                  producer_id: producer.id
                }
              end

              it_behaves_like 'a not found request'
            end

            context 'with wrong `producer_id` parameter' do
              let(:params) do
                {
                  group_id: group.id,
                  producer_id: 666
                }
              end

              it_behaves_like 'a bad request'

              describe 'its body' do
                before { post :create, params }

                subject { JSON.parse(response.body) }

                it do
                  is_expected.to include(
                    'errors' => {
                      'producer' => ["can't be blank"]
                    }
                  )
                end
              end
            end
          end

          describe 'DELETE #destroy' do
            let(:supplier) do
              FactoryGirl.create(
                :supplier,
                producer_id: producer.id,
                group_id: group.id
              )
            end
            let(:params) { { id: supplier.id } }

            subject { delete :destroy, params }

            context 'destroying a non existent supplier' do
              let(:supplier) { instance_double(Supplier, id: 666) }

              it_behaves_like 'a not found request'
            end

            context 'when the user is associated to the group' do
              context 'as an `admin`' do
                it_behaves_like 'a successful request (204)'
              end

              context 'as a `member`' do
                before do
                  group_membership.role = ::BasicResources::Membership::ROLES[:member]
                  group_membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end

            context 'when the user is not associated to the group' do
              before { group_membership.destroy! }

              it_behaves_like 'a forbidden request'
            end
          end
        end
      end
    end
  end
end
