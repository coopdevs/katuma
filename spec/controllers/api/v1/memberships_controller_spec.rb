require 'spec_helper'

shared_examples 'a successful request' do

  describe 'response is success' do

    it 'respond with a 200 status code' do
      expect(api_response.code).to eq('200')
    end
  end
end

shared_examples 'an unauthorized request' do

  describe 'response is unauthorized' do

    it 'respond with a 401 status code' do
      expect(api_response.code).to eq('401')
    end
  end
end

describe Api::V1::MembershipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  let(:membership) { FactoryGirl.create(:membership) }

  context 'Not authenticaded user' do

    describe 'GET #index' do

      subject :api_response do
        get :index, user_id: 666
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'GET #show' do

      subject :api_response do
        get :show, user_id: 666, id: 666
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'POST #create' do

      subject :api_response do
        post :create, user_id: 666, name: 'ciola'
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'PUT #update' do

      subject :api_response do
        put :update, user_id: 666, id: 666, name: 'ciola'
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'DELETE #destroy' do

      subject :api_response do
        delete :destroy, user_id: 666, id: 666
        response
      end

      it_behaves_like 'an unauthorized request'
    end
  end

  context 'Authenticated user' do

    before { authenticate_as user }

    describe 'GET #index' do

      subject :api_response do
        get :index, user_id: user.id
        response
      end

      it_behaves_like 'a successful request'

      it 'returns an empty array' do
        expect(JSON.parse(api_response.body)).to eq('memberships' => [])
      end
    end

    describe 'GET #show' do

      subject :api_response do
        get :show, user_id: user.id, id: membership.id
        response
      end

      it_behaves_like 'a successful request'

      it 'returns the membership details' do
        expect(JSON.parse(api_response.body)).to eq('memberships' => [JSON.parse(membership.to_json)])
      end
    end

    describe 'PUT #update' do

      subject :api_response do
        put :update, user_id: user.id, id: membership.id, name: 'ciola'
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'DELETE #destroy' do

      subject :api_response do
        delete :destroy, user_id: user.id, id: membership.id
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'POST #create' do

      subject :api_response do
        post :create, user_id: user.id, group_id: group.id, role: Membership::ROLES[:admin]
        response
      end

      it_behaves_like 'a successful request'

      it 'returns membership details' do
        membership = JSON.parse(api_response.body)['memberships'].first

        expect(membership['group_id']).to eq group.id
        expect(membership['user_id']).to eq user.id
        expect(membership['role']).to eq Membership::ROLES[:admin]
      end

      it 'creates a new Membership' do
        api_response

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

      subject :api_response do
        get :index, user_id: member.id
        response
      end

      it_behaves_like 'a successful request'

      it 'returns an array of memberships of the user groups' do
        memberships = Membership.where(group_id: member.group_ids)

        expect(JSON.parse(api_response.body)).to eq('memberships' => JSON.parse(memberships.to_json))
      end
    end

    describe 'GET #show' do

      subject :api_response do
        get :show, user_id: member.id, id: membership.id
        response
      end

      it_behaves_like 'a successful request'

      it 'returns the membership details' do
        expect(JSON.parse(api_response.body)).to eq('memberships' => [JSON.parse(membership.to_json)])
      end
    end

    describe 'PUT #update' do

      subject :api_response do
        put :update, user_id: member.id, id: membership.id, role: Membership::ROLES[:admin]
        response
      end

      it_behaves_like 'a successful request'

      it 'returns the membership details with updated attributes' do
        membership = JSON.parse(api_response.body)['memberships'].first
        expect(membership['role']).to eq Membership::ROLES[:admin]
      end
    end

    describe 'DELETE #destroy' do

      subject :api_response do
        delete :destroy, user_id: member.id, id: membership.id
        response
      end

      it_behaves_like 'a successful request'

      it 'deletes the membership' do
        expect(api_response.body).to eq(membership.to_json)
      end
    end
  end
end
