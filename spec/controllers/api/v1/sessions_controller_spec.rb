require 'rails_helper'
require_relative '../../../support/shared_examples/controllers.rb'

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

      subject { post :create, email: user.email, password: 'pwd' }

      it 'associates the session with the user' do
        subject

        expect(session[:current_user_id]).to be user.id
      end

      it_behaves_like 'a successful request (201)'
      it_behaves_like 'response with empty body'
    end

    context 'when the user exists but the password is wrong' do

      subject { post :create, email: user.email, password: 'wrongpwd' }

      it_behaves_like 'an unauthorized request'
      it_behaves_like 'response with empty body'
    end

    context 'when the user does not exist' do

      subject { post :create, email: 'user@doesntexis.ts', password: 'pwd' }

      it_behaves_like 'an unauthorized request'
      it_behaves_like 'response with empty body'
    end
  end

  describe '#destroy' do

    before { session[:current_user_id] = user.id }

    subject { delete :destroy }

    it 'Removes the association between the session and the user' do
      subject

      expect(session[:current_user_id]).to be nil
    end

    it_behaves_like 'a successful request'
    it_behaves_like 'response with empty body'
  end
end
