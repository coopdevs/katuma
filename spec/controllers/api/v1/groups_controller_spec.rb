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

describe Api::V1::GroupsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }

  context 'Not authenticaded user' do

    describe 'GET #index' do

      subject :api_response do
        get :index
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'GET #show' do

      subject :api_response do
        get :show, id: group.id
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'POST #create' do

      subject :api_response do
        post :create, name: 'ciola'
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'PUT #update' do

      subject :api_response do
        put :update, { id: group.id, name: 'ciola' }
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'DELETE #destroy' do

      subject :api_response do
        delete :destroy, id: group.id
        response
      end

      it_behaves_like 'an unauthorized request'
    end
  end

  context 'Authenticated user' do

    before { authenticate_as user }

    describe 'GET #index' do

      subject :api_response do
        get :index
        response
      end

      it_behaves_like 'a successful request'

      it 'returns an empty array' do
        expect(JSON.parse(api_response.body)).to eq []
      end
    end

    describe 'GET #show' do

      subject :api_response do
        get :show, id: group.id
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'PUT #update' do

      subject :api_response do
        put :update, { id: group.id, name: 'ciola' }
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'DELETE #destroy' do

      subject :api_response do
        delete :destroy, id: group.id
        response
      end

      it_behaves_like 'an unauthorized request'
    end

    describe 'POST #create' do

      subject :api_response do
        post :create, name: 'coope'
        response
      end

      it_behaves_like 'a successful request'

      it 'returns group details' do
        group = JSON.parse(api_response.body)

        expect(group['name']).to eq('coope')
      end

      it 'creates a new Group' do
        api_response
        expect(Group.first.name).to eq('coope')
      end

      it 'adds user as group admin' do
        api_response
        expect(Group.first.admins).to include user
      end
    end
  end

  context 'Group admin user' do

    before do
      group.memberships.create(user: user, role: Membership::ROLES[:admin])
      authenticate_as user
    end

    describe 'GET #index' do

      subject :api_response do
        get :index
        response
      end

      it_behaves_like 'a successful request'

      it 'returns an array of groups which user pertains' do
        expect(JSON.parse(api_response.body)).to eq [JSON.parse(group.to_json)]
      end
    end

    describe 'GET #show' do

      subject :api_response do
        get :show, id: group.id
        response
      end

      it_behaves_like 'a successful request'

      it 'returns the group details' do
        expect(JSON.parse(api_response.body)).to eq JSON.parse(group.to_json)
      end
    end

    describe 'PUT #update' do

      subject :api_response do
        put :update, id: group.id, name: 'Pummarola'
        response
      end

      it_behaves_like 'a successful request'

      it 'returns the group details with updated attributes' do
        group = JSON.parse(api_response.body)

        expect(group['name']).to eq('Pummarola')
      end
    end

    describe 'DELETE #destroy' do

      subject :api_response do
        delete :destroy, id: group.id
        response
      end

      it_behaves_like 'a successful request'

      it 'deletes the group' do
        expect(api_response.body).to eq(group.to_json)
      end
    end
  end
end
