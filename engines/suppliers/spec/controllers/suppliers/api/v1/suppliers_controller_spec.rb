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
            FactoryGirl.create(:user)
          end
          let(:group_user) { ::Group::User.find(user.id) }
          let(:suppliers_user) { User.find(user.id) }
          let(:group_membership) do
            FactoryGirl.create(
              :membership,
              user: group_user,
              role: ::Group::Membership::ROLES[:admin]
            )
          end
          let(:group) do
            ::Suppliers::Group.find(group_membership.group.id)
          end
          let(:producer_for_group) do
            FactoryGirl.build(:producer, name: 'Related to group')
          end
          let(:producer_for_user) do
            FactoryGirl.build(:producer, name: 'Related to user')
          end
          let(:producer) do
            ::Producers::ProducerCreator.new(
              producer: producer_for_group,
              creator: suppliers_user,
              group: ::Producers::Group.find(group.id)
            ).create

            Producer.last
          end

          before { authenticate_as suppliers_user }

          describe 'GET #index' do
            let!(:supplier) do
              FactoryGirl.create(
                :supplier,
                group: group,
                producer: producer
              )
            end

            subject { get :index, group_id: group.id }

            it_behaves_like 'a successful request'

            describe 'its body' do
              before { get :index, group_id: group.id }

              subject { JSON.parse(response.body) }

              its(:size) { is_expected.to eq(1) }
              it { is_expected.to include(JSON.parse(supplier.to_json)) }
            end
          end

          describe 'GET #show' do
            let(:supplier) do
              FactoryGirl.create(
                :supplier,
                producer: producer,
                group: group
              )
            end
            let(:params) { { id: supplier.id } }

            subject { get :show, params }

            context 'requesting a non existent supplier' do
              let(:supplier) { instance_double(Supplier, id: 666) }

              it_behaves_like 'a not found request'
            end

            xcontext 'requesting a supplier which producer is associated to a user' do
            end

            context 'requesting a supplier which producer is associated to a group' do
              it_behaves_like 'a successful request'

              describe 'its body' do
                before { get :show, params }

                subject { JSON.parse(response.body) }

                it { is_expected.to include(JSON.parse(supplier.to_json)) }
              end

              context 'when the user is not a group admin' do
                before do
                  group_membership.role = ::Group::Membership::ROLES[:member]
                  group_membership.save!
                end

                it_behaves_like 'a successful request'
              end
            end

            context 'requesting a supplier not associated to the current user' do
              let(:suppliers_user) do
                user = FactoryGirl.create(:user)
                User.find(user.id)
              end

              it_behaves_like 'a forbidden request'
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

            it_behaves_like 'a successful request'

            describe 'its body' do
              before { post :create, params }

              subject { JSON.parse(response.body) }

              its(['group_id']) { is_expected.to eq(params[:group_id]) }
              its(['producer_id']) { is_expected.to eq(params[:producer_id]) }
            end

            context 'with wrong parameters' do
              let(:params) do
                {
                  group_id: 'hola',
                  provider_id: 666
                }
              end

              it_behaves_like 'a not found request'
            end

            xcontext 'when the producer is related to a user' do
            end

            context 'when the producer is related to a group' do
              context 'and the user is an admin of the group' do
                it_behaves_like 'a successful request'
              end

              context 'and the user is not an admin of the group' do
                before do
                  group_membership.role = ::Group::Membership::ROLES[:member]
                  group_membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end
          end

          describe 'DELETE #destroy' do
            let(:supplier) do
              FactoryGirl.create(
                :supplier,
                producer: producer,
                group: group
              )
            end
            let(:params) { { id: supplier.id } }

            subject { delete :destroy, params }

            context 'destroying a non existent supplier' do
              let(:supplier) { instance_double(Supplier, id: 666) }

              it_behaves_like 'a not found request'
            end

            xcontext 'destroying a supplier which producer is associated to a user' do
            end

            context 'destroying a supplier which producer is associated to a group' do
              it_behaves_like 'a successful request (204)'

              context 'when the user is not a group admin' do
                before do
                  group_membership.role = ::Group::Membership::ROLES[:member]
                  group_membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end

            context 'destroying a supplier not associated to the current user' do
              let(:suppliers_user) do
                user = FactoryGirl.create(:user)
                User.find(user.id)
              end

              it_behaves_like 'a forbidden request'
            end
          end
        end
      end
    end
  end
end
