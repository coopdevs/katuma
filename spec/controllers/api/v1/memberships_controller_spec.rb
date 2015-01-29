require 'rails_helper'
require_relative '../../../support/shared_examples/controllers.rb'
require_relative '../../../support/authentication.rb'

describe Api::V1::MembershipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  let(:membership) { FactoryGirl.create(:membership) }

  context 'Not authenticaded user' do

    describe 'GET #index' do

      subject { get :index, user_id: 666 }

      it_behaves_like 'an unauthorized request'
    end

    describe 'GET #show' do

      subject { get :show, user_id: 666, id: 666 }

      it_behaves_like 'an unauthorized request'
    end

    describe 'POST #create' do

      subject { post :create, user_id: 666, name: 'ciola' }

      it_behaves_like 'an unauthorized request'
    end

    describe 'PUT #update' do

      subject { put :update, user_id: 666, id: 666, name: 'ciola' }

      it_behaves_like 'an unauthorized request'
    end

    describe 'DELETE #destroy' do

      subject { delete :destroy, user_id: 666, id: 666 }

      it_behaves_like 'an unauthorized request'
    end
  end

  context 'Authenticated user' do

    before { authenticate_as user }

    describe 'GET #index' do

      subject { get :index, user_id: user.id }

      it_behaves_like 'a successful request'
      its(:body) { is_expected.to eq('[]') }
    end

    describe 'GET #show' do

      subject { get :show, user_id: user.id, id: membership.id }

      it_behaves_like 'a successful request'

      it 'returns the membership details' do
        expect(JSON.parse(subject.body)).to eq JSON.parse(membership.to_json)
      end
    end

    describe 'PUT #update' do

      subject { put :update, user_id: user.id, id: membership.id, name: 'ciola' }

      it_behaves_like 'a forbidden request'
    end

    describe 'DELETE #destroy' do

      subject { delete :destroy, user_id: user.id, id: membership.id }

      it_behaves_like 'a forbidden request'
    end

    describe 'POST #create' do

      subject { post :create, user_id: user.id, group_id: group.id, role: Membership::ROLES[:admin] }

      it_behaves_like 'a successful request'

      it 'returns membership details' do
        membership = JSON.parse(subject.body)

        expect(membership['group_id']).to eq group.id
        expect(membership['user_id']).to eq user.id
        expect(membership['role']).to eq Membership::ROLES[:admin]
      end

      it 'creates a new Membership' do
        subject

        membership = Membership.first
        expect(membership.group).to eq group
        expect(membership.user).to eq user
        expect(membership.role).to eq Membership::ROLES[:admin]
      end
    end
  end

  context 'Group admin user' do

    let(:member) { FactoryGirl.create(:user) }
    let!(:membership) do
      group.memberships.create(user: member, role: Membership::ROLES[:member])
    end

    before do
      group.memberships.create(user: user, role: Membership::ROLES[:admin])
      authenticate_as user
    end

    describe 'GET #index' do

      subject { get :index, user_id: member.id }

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

      subject { put :update, user_id: member.id, id: membership.id, role: Membership::ROLES[:admin] }

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
        expect {
          subject
        }.to change { Membership.count }.from(2).to(1)
      end
    end
  end
end
