require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module BasicResources
  module Api
    module V1
      describe GroupsController do
        routes { Engine.routes }

        let(:user) do
          user = FactoryGirl.create(:user)
          User.find(user.id)
        end
        let(:group) { FactoryGirl.create(:group) }

        context 'Not authenticaded user' do
          describe 'GET #index' do
            subject { get :index }

            it_behaves_like 'an unauthorized request'
          end

          describe 'GET #show' do
            subject { get :show, id: group.id }

            it_behaves_like 'an unauthorized request'
          end

          describe 'POST #create' do
            subject { post :create, name: 'ciola' }

            it_behaves_like 'an unauthorized request'
          end

          describe 'PUT #update' do
            subject { put :update, id: group.id, name: 'ciola' }

            it_behaves_like 'an unauthorized request'
          end

          describe 'DELETE #destroy' do
            subject { delete :destroy, id: group.id }

            it_behaves_like 'an unauthorized request'
          end
        end

        context 'Authenticated user' do
          before { authenticate_as user }

          describe 'GET #index' do
            subject { get :index }

            it_behaves_like 'a successful request'
            its(:body) { is_expected.to eq('[]') }

            context 'Group admin user' do
              let(:first_group) { FactoryGirl.create(:group) }
              let(:second_group) { FactoryGirl.create(:group) }

              before do
                Membership.create!(
                  user: user,
                  basic_resource_group_id: first_group.id,
                  role: Membership::ROLES[:admin]
                )
                Membership.create!(
                  user: user,
                  basic_resource_group_id: second_group.id,
                  role: Membership::ROLES[:member]
                )
              end

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { get :index }

                subject { JSON.parse(response.body) }

                its(:size) { is_expected.to eq(2) }
                it { is_expected.to include(JSON.parse(first_group.to_json)) }
                it { is_expected.to include(JSON.parse(second_group.to_json)) }
              end
            end
          end

          describe 'GET #show' do
            let(:group) { FactoryGirl.create(:group) }

            subject { get :show, id: group.id }

            context 'requesting a non existent producer' do
              let(:group) { instance_double(Group, id: 666) }

              it_behaves_like 'a not found request'
            end

            context 'requesting a group where the user is not a member' do
              it_behaves_like 'a forbidden request'
            end

            context 'requesting a group where the user is admin' do
              before do
                Membership.create!(
                  user: user,
                  basic_resource_group_id: group.id,
                  role: Membership::ROLES[:admin]
                )
              end

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { get :show, id: group.id }

                subject { JSON.parse(response.body) }

                it { is_expected.to eq(JSON.parse(group.to_json)) }
              end
            end
          end

          describe 'POST #create' do
            subject { post :create, name: 'coope' }

            it_behaves_like 'a successful request'
          end

          describe 'PUT #update' do
            let(:group) { FactoryGirl.create(:group) }

            subject { put :update, id: group.id, name: 'Pummarola' }

            context 'updating a non existent producer' do
              let(:group) { instance_double(Group, id: 666) }

              it_behaves_like 'a not found request'
            end

            context 'requesting a group where the user is not a member' do
              it_behaves_like 'a forbidden request'
            end

            context 'requesting a group where the user is a member' do
              let!(:membership) do
                Membership.create!(
                  user: user,
                  basic_resource_group_id: group.id,
                  role: role
                )
              end

              context 'as an `admin`' do
                let(:role) { Membership::ROLES[:admin] }

                it_behaves_like 'a successful request'

                describe 'its body' do
                  before { put :update, id: group.id, name: 'Pummarola' }

                  subject { JSON.parse(response.body) }

                  its(['name']) { is_expected.to eq('Pummarola') }
                end
              end

              context 'as a `member`' do
                let(:role) { Membership::ROLES[:member] }

                it_behaves_like 'a forbidden request'
              end
            end
          end

          describe 'DELETE #destroy' do
            let(:group) { FactoryGirl.create(:group) }

            subject { delete :destroy, id: group.id }

            context 'destroying a non existent producer' do
              let(:group) { instance_double(Group, id: 666) }

              it_behaves_like 'a not found request'
            end

            context 'destroying a group where the user is not a member' do
              it_behaves_like 'a forbidden request'
            end

            context 'destroying a group where the user is a member' do
              let!(:membership) do
                Membership.create!(
                  user: user,
                  basic_resource_group_id: group.id,
                  role: role
                )
              end

              context 'as an `admin`' do
                let(:role) { Membership::ROLES[:admin] }

                it_behaves_like 'a successful request'

                it 'destroys the group' do
                  expect { subject }.to change(Group, :count).from(1).to(0)
                end

                describe 'its body' do
                  before { delete :destroy, id: group.id }

                  subject { JSON.parse(response.body) }

                  it { is_expected.to eq(JSON.parse(group.to_json)) }
                end
              end

              context 'as a `member`' do
                let(:role) { Membership::ROLES[:member] }

                it_behaves_like 'a forbidden request'
              end
            end
          end
        end
      end
    end
  end
end
