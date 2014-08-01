require 'spec_helper'

describe Api::V1::SessionsController do

  let(:user) {
    FactoryGirl.create(
      :user,
      password: 'pwd',
      password_confirmation: 'pwd'
    )
  }

  describe '#create' do

    context 'when the user exists and the password is correct' do

      it 'associates the session to the user' do
        post :create, { email: user.email, password: 'pwd' }

        expect(session[:current_user_id]).to be user.id
      end

      it 'renders an empty response' do
        post :create, { email: user.email, password: 'pwd' }

        expect(response.body).to be {}
      end

      it 'renders a response with status 201' do
        post :create, { email: user.email, password: 'pwd' }

        expect(response.status).to be 201
      end
    end

    context 'when the user exists but the password is wrong' do

      it 'renders an empty response' do
        post :create, { email: user.email, password: 'wrongpwd' }

        expect(response.body).to be {}
      end

      it 'renders a response with status 401' do
        post :create, { email: user.email, password: 'wrongpwd' }

        expect(response.status).to be 401
      end
    end

    context 'when the user does not exist' do

      it 'renders an empty response' do
        post :create, { email: 'user@doesntexis.ts', password: 'pwd' }

        expect(response.body).to be {}
      end

      it 'renders a response with status 401' do
        post :create, { email: 'user@doesntexis.ts', password: 'pwd' }

        expect(response.status).to be 401
      end
    end
  end

  describe '#destroy' do

    before { session[:current_user_id] = user.id }

    it 'Removes the association between the session and the user' do
      delete :destroy

      expect(session[:current_user_id]).to be nil
    end

    it 'renders an empty response' do
      delete :destroy

      expect(response.body).to be {}
    end

    it 'renders a response with status 200' do
      delete :destroy

      expect(response.status).to be 200
    end
  end
end
