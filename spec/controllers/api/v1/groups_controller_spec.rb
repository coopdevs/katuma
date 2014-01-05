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
  describe 'Not authenticaded user' do
    let(:group) { FactoryGirl.create(:group) }

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

  describe 'Authenticated user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group) }

    before :each do
      authenticate_as user
    end

    describe 'GET #index' do
      subject :api_response do
        get :index
        response
      end

      it_behaves_like 'a successful request'
      it 'returns an empty array' do
        expect(JSON.parse(api_response.body)).to eq([])
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
        post :create, {
          group: {
            name: 'coope',
            users_units_attributes: [
              {
                name: 'my unit'
              }
            ]
          }
        }
        response
      end

      it_behaves_like 'a successful request'

      it 'returns group details' do
        expect(JSON.parse(api_response.body)['name']).to eq('coope')
      end

      it 'creates a new Group' do
        api_response
        expect(Group.first.name).to eq('coope')
      end

      it 'creates a new UsersUnit' do
        api_response
        expect(Group.first.users_units.first.name).to eq('my unit')
      end

      it 'add user as group admin' do
        api_response
        expect(user.has_role? :admin, Group.first).to be_true
      end
    end

    describe 'Group admin user' do
      let(:group) { FactoryGirl.create(:group) }

      before :each do
        user.add_role :admin, group
      end

      describe 'GET #index' do
        subject :api_response do
          get :index
          response
        end

        it_behaves_like 'a successful request'
        it 'returns an array of groups where user is admin' do
          expect(JSON.parse(api_response.body)).to eq([group.as_json])
        end
      end

      describe 'GET #show' do
        subject :api_response do
          get :show, id: group.id
          response
        end

        it_behaves_like 'a successful request'
        it 'returns the group details' do
          expect(JSON.parse(api_response.body)).to eq(group.as_json)
        end
      end

      describe 'PUT #update' do
        subject :api_response do
          put :update, id: group.id, group: { name: 'Pummarola' }
          response
        end

        it_behaves_like 'a successful request'
        it 'returns the group details with updated attributes' do
          expect(JSON.parse(api_response.body)['name']).to eq('Pummarola')
        end
      end

      describe 'DELETE #destroy' do
        subject :api_response do
          delete :destroy, id: group.id
          response
        end

        it_behaves_like 'a successful request'
        it 'deletes the group' do
          expect(JSON.parse(api_response.body)).to eq(group.as_json)
        end
      end
    end
  end
end
