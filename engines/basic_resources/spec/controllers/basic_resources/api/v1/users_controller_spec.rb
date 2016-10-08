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

            context 'when the user belongs to the provided group' do
              before do
                Membership.create!(
                  basic_resource_group_id: group.id,
                  user_id: user.id,
                  role: Membership::ROLES[:member]
                )
              end

              it_behaves_like 'a successful request'

              describe 'body' do
                before { get :index, group_id: group.id }

                subject { JSON.parse(response.body) }

                it do
                  is_expected.to contain_exactly(
                    JSON.parse(UserSerializer.new(user).to_json)
                  )
                end
              end
            end

            context 'when the user does not belong to the provided group' do
              it_behaves_like 'a forbidden request'
            end
          end
        end
      end
    end
  end
end
