require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module BasicResources
  module Api
    module V1
      describe UsersController do
        routes { BasicResources::Engine.routes }

        let(:user) do
          user = FactoryGirl.create(:user)
          User.find(user.id)
        end

        context 'Not authenticaded user' do
          describe 'GET #index' do
            subject { get :index }

            it_behaves_like 'an unauthorized request'
          end
        end

        context 'Authenticated user' do
          before { authenticate_as user }

          describe 'GET #index' do
            subject { get :index, group_id: group.id }

            let(:group) { FactoryGirl.create(:group) }

            it_behaves_like 'a successful request'

            describe 'body' do
              before { get :index, group_id: group.id }

              let(:user_in_group) { FactoryGirl.create(:user) }

              before do
                Membership.create(
                  basic_resource_group_id: group.id,
                  user_id: user_in_group,
                  role: Membership::ROLES[:member]
                )
              end

              subject { JSON.parse(response.body) }

              it { is_expected.to contain_exactly(user_in_group) }
            end
          end
        end
      end
    end
  end
end
