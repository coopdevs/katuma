require 'spec_helper'

shared_examples 'a successful request' do

  describe 'response is success' do

    it 'respond with a 200 status code' do
      expect(response.code).to eq('200')
    end
  end
end

shared_examples 'an unauthorized request' do

  describe 'response is unauthorized' do

    it { should respond_with 401 }
  end
end

describe Api::V1::UsersController do

  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  let(:membership) { FactoryGirl.create(:membership) }

  context 'Not authenticaded user' do

    describe 'GET #index' do

      before { get :index }

      it_behaves_like 'an unauthorized request'
    end

    describe 'GET #show' do

      before { get :show, id: 666 }

      it_behaves_like 'an unauthorized request'
    end

    describe 'POST #create' do

      let(:parameters) do
        {
          name: 'ciola',
          email: 'ciola@caola.com',
          password: 'secret',
          password_confirmation: 'secret'
        }
      end

      before { post :create, parameters }

      it_behaves_like 'a successful request'

      it 'creates a new user with the given parameters' do
        user = User.last

        expect(user.name).to eq 'ciola'
        expect(user.email).to eq 'ciola@caola.com'
      end
    end

    describe 'PUT #update' do

      before { put :update, id: 666, name: 'ciola' }

      it_behaves_like 'an unauthorized request'
    end

    describe 'DELETE #destroy' do

      before { delete :destroy, id: 666 }

      it_behaves_like 'an unauthorized request'
    end

    describe 'GET #account' do

      before { get :account }

      it_behaves_like 'an unauthorized request'
    end
  end

  context 'Authenticated user' do

    before { authenticate_as user }

    describe 'GET #index' do

      before do
        @user2 = FactoryGirl.create(:user)
        @user3 = FactoryGirl.create(:user)
        group1 = FactoryGirl.create(:group)
        group2 = FactoryGirl.create(:group)
        Membership.create(user: @user2, group: group1, role: Membership::ROLES[:admin])
        Membership.create(user: @user3, group: group2, role: Membership::ROLES[:admin])
        Membership.create(user: user, group: group1, role: Membership::ROLES[:admin])
        Membership.create(user: user, group: group2, role: Membership::ROLES[:admin])

        get :index
      end

      let(:user_network) { [user, @user2, @user3] }

      it_behaves_like 'a successful request'

      it 'returns a collection of users in the current_user network' do
        expect(response.body).to eq UsersSerializer.new(user_network).to_json
      end
    end

    describe 'GET #show' do

      context 'when the user is authorized' do

        before { get :show, id: user.id }

        it_behaves_like 'a successful request'

        it 'returns the user details' do
          expect(response.body).to eq UserSerializer.new(user).to_json
        end
      end

      context 'when the user is NOT authorized' do

        before do
          user2 = FactoryGirl.create(:user)
          get :show, id: user2.id
        end

        it_behaves_like 'an unauthorized request'
      end
    end

    describe 'PUT #update' do

      context 'when the user is authorized' do

        before do
          put :update, id: user.id, name: 'ciola'
          user.reload
        end

        it_behaves_like 'a successful request'

        it 'updates the attributes' do
          expect(user.name).to eq 'ciola'
        end

        it 'returns the user details' do
          expect(response.body).to eq UserSerializer.new(user).to_json
        end
      end

      context 'when the user is NOT authorized' do

        before do
          user2 = FactoryGirl.create(:user)
          put :update, id: user2.id, name: 'ciola'
        end

        it_behaves_like 'an unauthorized request'
      end
    end

    describe 'DELETE #destroy' do

      context 'when the user is authorized' do

        before { delete :destroy, id: user.id }

        it_behaves_like 'a successful request'

        it 'deletes the user' do
          expect(User.find_by_id(user.id)).to be nil
        end
      end

      context 'when the user is NOT authorized' do

        before do
          user2 = FactoryGirl.create(:user)
          delete :destroy, id: user2.id
        end

        it_behaves_like 'an unauthorized request'
      end
    end

    describe 'GET #account' do

      before { get :account }

      it_behaves_like 'a successful request'

      it 'returns the current user details' do
        expect(response.body).to eq UserSerializer.new(user).to_json
      end
    end
  end
end
