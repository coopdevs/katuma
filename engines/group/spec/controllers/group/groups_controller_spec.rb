require 'rails_helper'
require_relative '../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../spec/support/authentication.rb'

module Group
  describe Api::V1::GroupsController do
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
      end

      describe 'GET #show' do
        subject { get :show, id: group.id }

        it_behaves_like 'a forbidden request'
      end

      describe 'PUT #update' do
        subject { put :update, id: group.id, name: 'ciola' }

        it_behaves_like 'a forbidden request'
      end

      describe 'DELETE #destroy' do
        subject { delete :destroy, id: group.id }

        it_behaves_like 'a forbidden request'
      end

      describe 'POST #create' do
        subject { post :create, name: 'coope' }

        it_behaves_like 'a successful request'

        it 'returns group details' do
          group = JSON.parse(subject.body)

          expect(group['name']).to eq('coope')
        end

        it 'creates a new Group' do
          subject

          expect(Group.last.name).to eq('coope')
        end

        it 'adds user as group admin' do
          subject

          expect(Group.last.admins).to include user
        end
      end
    end

    context 'Group admin user' do
      before do
        group.memberships.create(user: user, role: Membership::ROLES[:admin])
        authenticate_as user
      end

      describe 'GET #index' do
        subject { get :index }

        it_behaves_like 'a successful request'

        it 'returns an array of groups which user pertains' do
          expect(JSON.parse(subject.body)).to eq [JSON.parse(group.to_json)]
        end
      end

      describe 'GET #show' do
        subject { get :show, id: group.id }

        it_behaves_like 'a successful request'

        it 'returns the group details' do
          expect(JSON.parse(subject.body)).to eq JSON.parse(group.to_json)
        end
      end

      describe 'PUT #update' do
        subject { put :update, id: group.id, name: 'Pummarola' }

        it_behaves_like 'a successful request'

        it 'returns the group details with updated attributes' do
          group = JSON.parse(subject.body)

          expect(group['name']).to eq('Pummarola')
        end
      end

      describe 'DELETE #destroy' do
        subject { delete :destroy, id: group.id }

        it_behaves_like 'a successful request'

        it 'deletes the group' do
          expect(subject.body).to eq(group.to_json)
        end
      end
    end
  end
end
