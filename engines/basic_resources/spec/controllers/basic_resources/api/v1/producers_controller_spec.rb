require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module BasicResources
  module Api
    module V1
      describe ProducersController do
        routes { Engine.routes }

        context 'Not authenticaded user' do
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
            u = FactoryGirl.create(:user)
            User.find(u.id)
          end
          let(:group) { FactoryGirl.create(:group) }
          let!(:group_membership) do
            FactoryGirl.create(
              :membership,
              basic_resource_group_id: group.id,
              user: user,
              role: Membership::ROLES[:admin]
            )
          end
          let(:producer_for_group) do
            FactoryGirl.build(:producer, name: 'Related to group')
          end
          let(:producer_for_user) do
            FactoryGirl.build(:producer, name: 'Related to user')
          end

          before { authenticate_as user }

          describe 'POST #create' do
            let(:params) do
              {
                name: 'Tomatekken 3',
                email: 'tomatekken3@katuma.org',
                address: 'c/ dels tomatekkens, 3'
              }
            end

            subject { post :create, params }

            it_behaves_like 'a successful request'

            describe 'its body' do
              before { post :create, params }

              subject { JSON.parse(response.body) }

              its(['name']) { is_expected.to eq(params[:name]) }
              its(['email']) { is_expected.to eq(params[:email]) }
              its(['address']) { is_expected.to eq(params[:address]) }
            end

            describe 'side effects' do
              let(:created_membership) { Membership.last }

              before { post :create, params }

              describe 'response Link header' do
                let(:http_resource_links) do
                  ::Shared::HttpResourceLinks.build([created_membership], 'created')
                end
                subject { response['Link'] }

                it { is_expected.to eq(http_resource_links) }
              end

              describe 'membership created' do
                let(:link) { response['Link'] }
                let(:created_membership) do
                  id = link.split('/')[6].to_i
                  Membership.find(id)
                end

                subject { created_membership }

                its(:user_id) { is_expected.to eq(user.id) }
                its(:group_id) { is_expected.to eq(nil) }
                its(:role) { is_expected.to eq(Membership::ROLES[:admin]) }

                context 'passing a `group_id` parameter' do
                  let(:params) do
                    {
                      name: 'Tomatekken 3',
                      email: 'tomatekken3@katuma.org',
                      address: 'c/ dels tomatekkens, 3',
                      group_id: group.id
                    }
                  end

                  its(:user_id) { is_expected.to eq(nil) }
                  its(:group_id) { is_expected.to eq(group.id) }
                  its(:role) { is_expected.to eq(Membership::ROLES[:admin]) }
                end
              end
            end

            context 'with wrong parameters' do
              let(:params) do
                {
                  name: 'Tomatekken 3'
                }
              end

              it_behaves_like 'a bad request'

              describe 'its body' do
                before { post :create, params }

                subject { JSON.parse(response.body) }

                it do
                  is_expected.to include(
                    'errors' => {
                      'email' => ["can't be blank"],
                      'address' => ["can't be blank"]
                    }
                  )
                end
              end
            end

            context 'creating a producer for a group' do
              subject { post :create, params.merge(group_id: group.id) }

              context 'when the user is an admin of the group' do
                it_behaves_like 'a successful request'
              end

              context 'when the user is not an admin of the group' do
                before do
                  group_membership.role = Membership::ROLES[:member]
                  group_membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end
          end

          describe 'PUT #update' do
            let(:params) do
              {
                id: producer.id,
                name: 'New name'
              }
            end

            subject { put :update, params }

            context 'updating a non existent producer' do
              let(:producer) { instance_double(Producer, id: 666) }

              it_behaves_like 'a not found request'
            end

            context 'updating a producer directly associated to the user' do
              let(:producer) do
                ProducerCreator.new(
                  producer: producer_for_user,
                  creator: user
                ).create!
              end

              context 'when the user is a producer admin' do
                context 'with valid parameters' do
                  it_behaves_like 'a successful request'

                  describe 'its body' do
                    before { put :update, params }

                    subject { JSON.parse(response.body) }

                    it { is_expected.to include(JSON.parse(params.to_json)) }
                  end
                end

                context 'with not valid parameters' do
                  let(:params) do
                    {
                      id: producer.id,
                      email: nil
                    }
                  end

                  it_behaves_like 'a bad request'

                  describe 'its body' do
                    before { put :update, params }

                    subject { JSON.parse(response.body) }

                    it do
                      is_expected.to include(
                        'errors' => {
                          'email' => ["can't be blank"]
                        }
                      )
                    end
                  end
                end
              end

              context 'when the user is not a producer admin' do
                before do
                  membership = Membership.where(
                    basic_resource_producer_id: producer.id,
                    user: user,
                    role: Membership::ROLES[:admin]
                  ).first
                  membership.role = Membership::ROLES[:member]
                  membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end

            context 'updating a producer associated to the user through a group' do
              let(:producer) do
                ProducerCreator.new(
                  creator: user,
                  group: group,
                  producer: producer_for_group
                ).create!
              end

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { put :update, params }

                subject { JSON.parse(response.body) }

                it { is_expected.to include(JSON.parse(params.to_json)) }
              end

              context 'when the user is not a group admin' do
                before do
                  group_membership.role = Membership::ROLES[:member]
                  group_membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end

            context 'updating a producer not associated to the current user' do
              let(:another_user) do
                user = FactoryGirl.create(:user)
                User.find(user.id)
              end
              let(:producer) do
                ProducerCreator.new(
                  producer: producer_for_user,
                  creator: another_user
                ).create!
              end

              it_behaves_like 'a forbidden request'
            end
          end

          describe 'DELETE #destroy' do
            let(:id) { producer.id }

            subject { delete :destroy, id: id }

            context 'destroying a non existent producer' do
              let(:producer) { instance_double(Producer, id: 666) }

              it_behaves_like 'a not found request'
            end

            context 'destroying a producer directly associated to the user' do
              let(:producer) do
                ProducerCreator.new(
                  producer: producer_for_user,
                  creator: user
                ).create!
              end

              context 'when the user is a producer admin' do
                it_behaves_like 'a successful request (204)'
              end

              context 'when the user is not a producer admin' do
                before do
                  membership = Membership.where(
                    basic_resource_producer_id: producer.id,
                    user: user,
                    role: Membership::ROLES[:admin]
                  ).first
                  membership.role = Membership::ROLES[:member]
                  membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end

            context 'destroying a producer associated to the user through a group' do
              let(:producer) do
                ProducerCreator.new(
                  creator: user,
                  group: group,
                  producer: producer_for_group
                ).create!
              end

              it_behaves_like 'a successful request (204)'

              context 'when the user is not a group admin' do
                before do
                  group_membership.role = Membership::ROLES[:member]
                  group_membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end

            context 'destroying a producer not associated to the current user' do
              let(:another_user) do
                user = FactoryGirl.create(:user)
                User.find(user.id)
              end
              let(:producer) do
                ProducerCreator.new(
                  producer: producer_for_user,
                  creator: another_user
                ).create!
              end

              it_behaves_like 'a forbidden request'
            end
          end
        end
      end
    end
  end
end
