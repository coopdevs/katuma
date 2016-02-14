require 'rails_helper'
require_relative '../support/matchers/pundit_matchers.rb'

describe Account::UserPolicy do

  let(:user) { FactoryGirl.create :user }

  context 'When the user is the same as current user' do

    subject { UserPolicy.new(user, user) }

    it { should permit_to :show }
    it { should permit_to :update }
    it { should permit_to :destroy }
  end

  context 'When the user is NOT the same as current user' do

    let(:user2) { FactoryGirl.create :user }

    subject { UserPolicy.new(user, user2) }

    it { should_not permit_to :show }
    it { should_not permit_to :update }
    it { should_not permit_to :destroy }
  end
end
