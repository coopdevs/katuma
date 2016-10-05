require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module BasicResources
  module Api
    module V1
      describe MembershipsController do
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
            subject { get :show, id: 666 }

            it_behaves_like 'an unauthorized request'
          end

          describe 'POST #create' do
            subject { post :create }

            it_behaves_like 'an unauthorized request'
          end

          describe 'PUT #update' do
            subject { put :update, id: 666 }

            it_behaves_like 'an unauthorized request'
          end

          describe 'DELETE #destroy' do
            subject { delete :destroy, id: 666 }

            it_behaves_like 'an unauthorized request'
          end
        end

        xcontext 'Authenticated user' do
          before { authenticate_as user }

          describe 'GET #index' do
            before { membership }

            subject { get :index }

            it_behaves_like 'a successful request'
            its(:body) { is_expected.to_not eq('[]') }
          end

          describe 'GET #show' do
            subject { get :show, id: membership.id }

            it_behaves_like 'a successful request'
            it 'returns the membership details' do
              expect(JSON.parse(subject.body)).to eq JSON.parse(membership.to_json)
            end
          end

          describe 'PUT #update' do
            subject { put :update, id: membership.id }

            it_behaves_like 'a forbidden request'
          end

          describe 'DELETE #destroy' do
            subject { delete :destroy, id: membership.id }

            it_behaves_like 'a forbidden request'
          end

          describe 'POST #create' do
            let(:other_group) { FactoryGirl.create(:group) }
            let(:params) do
              {
                user_id: user.id,
                group_id: other_group.id,
                role: Membership::ROLES[:admin]
              }
            end

            subject { post :create, params }

            it_behaves_like 'a successful request'

            it 'returns membership details' do
              membership = JSON.parse(subject.body)

              expect(membership['group_id']).to eq other_group.id
              expect(membership['user_id']).to eq user.id
              expect(membership['role']).to eq Membership::ROLES[:admin]
            end

            it 'creates a new Membership' do
              subject

              membership = Membership.last
              expect(membership.group).to eq other_group
              expect(membership.user).to eq user
              expect(membership.role).to eq Membership::ROLES[:admin]
            end
          end
        end

        xcontext 'Group admin user' do
          let(:member) do
            user = FactoryGirl.create(:user)
            User.find(user.id)
          end
          let!(:membership) do
            group.memberships.create(user: member, role: Membership::ROLES[:member])
          end

          before do
            group.memberships.create(user: user, role: Membership::ROLES[:admin])
            authenticate_as user
          end

          describe 'GET #index' do
            subject { get :index }

            let(:memberships) { Membership.where(group_id: member.group_ids) }

            it_behaves_like 'a successful request'

            it 'returns an array of memberships of the user groups' do
              expect(JSON.parse(subject.body)).to eq JSON.parse(memberships.to_json)
            end
          end

          describe 'GET #show' do
            subject { get :show, user_id: member.id, id: membership.id }

            it_behaves_like 'a successful request'
            it 'returns the membership details' do
              expect(JSON.parse(subject.body)).to eq JSON.parse(membership.to_json)
            end
          end

          describe 'PUT #update' do
            let(:params) do
              {
                id: membership.id,
                user_id: member.id,
                role: Membership::ROLES[:admin]
              }
            end

            subject { put :update, params }

            it_behaves_like 'a successful request'
            it 'returns the membership details with updated attributes' do
              membership = JSON.parse(subject.body)

              expect(membership['role']).to eq Membership::ROLES[:admin]
            end
          end

          describe 'DELETE #destroy' do
            subject { delete :destroy, user_id: member.id, id: membership.id }

            it_behaves_like 'a successful request'
            it 'deletes the membership' do
              expect { subject }.to change { Membership.count }.from(2).to(1)
            end
          end
        end
      end
    end
  end
end