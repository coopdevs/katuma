require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module BasicResources
  module Api
    module V1
      describe MembershipsController do
        routes { Engine.routes }

        let(:user) do
          user = FactoryGirl.create(:user)
          User.find(user.id)
        end
        let(:group) { FactoryGirl.create(:group) }
        let!(:membership) do
          Membership.create!(
            basic_resource_group_id: group.id,
            user_id: user.id,
            role: MemberRole.new(:member)
          )
        end

        context 'Not authenticaded user' do
          describe 'GET #index' do
            subject { get :index }

            it_behaves_like 'an unauthorized request'
          end

          describe 'GET #show' do
            subject { get :show, id: 666 }

            it_behaves_like 'an unauthorized request'
          end

          describe 'POST #create' do
            subject { post :create }

            it_behaves_like 'an unauthorized request'
          end

          describe 'PUT #update' do
            subject { put :update, id: 666 }

            it_behaves_like 'an unauthorized request'
          end

          describe 'DELETE #destroy' do
            subject { delete :destroy, id: 666 }

            it_behaves_like 'an unauthorized request'
          end
        end

        context 'Authenticated user' do
          before { authenticate_as user }

          describe 'GET #index' do
            context 'when no params are passed' do
              subject { get :index }

              it_behaves_like 'a successful request'

              describe 'body' do
                subject { JSON.parse(response.body) }

                before { get :index }

                it do
                  is_expected.to contain_exactly(
                    JSON.parse(MembershipSerializer.new(membership).to_json)
                  )
                end
              end
            end

            context 'when group_id is passed' do
              subject { get :index, group_id: group.id }

              let!(:other_group_membership) do
                Membership.create!(
                  basic_resource_group_id: FactoryGirl.create(:group).id,
                  user_id: user.id,
                  role: MemberRole.new(:member)
                )
              end

              it_behaves_like 'a successful request'

              describe 'body' do
                subject { JSON.parse(response.body) }

                before { get :index, group_id: group.id }

                it do
                  is_expected.to contain_exactly(
                    JSON.parse(MembershipSerializer.new(membership).to_json)
                  )
                end
              end
            end
          end

          describe 'GET #show' do
            subject { get :show, id: membership.id }

            it_behaves_like 'a successful request'

            it 'returns the membership details' do
              expect(JSON.parse(subject.body)).to eq JSON.parse(membership.to_json)
            end
          end

          describe 'PUT #update' do
            subject { put :update, id: membership.id }

            context 'when the user is not the owner of the membership' do
              before do
                membership.update_attribute(:user_id, FactoryGirl.create(:user).id)
              end

              it_behaves_like 'a forbidden request'
            end
          end

          describe 'DELETE #destroy' do
            subject { delete :destroy, id: membership.id }

            context 'when the user is not the owner of the membership' do
              before do
                membership.update_attribute(:user_id, FactoryGirl.create(:user).id)
              end

              it_behaves_like 'a forbidden request'
            end
          end

          describe 'POST #create' do
            subject { post :create, params }

            let(:other_group) { FactoryGirl.create(:group) }
            let(:params) do
              {
                user_id: user.id,
                basic_resource_group_id: other_group.id,
                role: MemberRole.new(:admin).to_i
              }
            end

            it_behaves_like 'a successful request'

            describe 'body' do
              before { post :create, params }

              subject { JSON.parse(response.body) }

              it do
                is_expected.to include(
                  'user_id' => user.id,
                  'basic_resource_group_id' => other_group.id,
                  'group_id' => nil,
                  'role' => MemberRole.new(:admin).to_i
                )
              end
            end
          end
        end

        context 'Group admin user' do
          let(:member) do
            user = FactoryGirl.create(:user)
            User.find(user.id)
          end
          let!(:membership) do
            group.memberships.create(user: member, role: MemberRole.new(:member))
          end

          before do
            group.memberships.create(user: user, role: MemberRole.new(:admin))
            authenticate_as user
          end

          describe 'GET #index' do
            subject { get :index }

            it_behaves_like 'a successful request'

            describe 'body' do
              before { get :index }

              subject { JSON.parse(response.body) }

              let(:memberships_of_his_groups) do
                Membership.where(basic_resource_group_id: user.group_ids)
              end

              it do
                is_expected.to eq(JSON.parse(memberships_of_his_groups.to_json))
              end
            end
          end

          xdescribe 'GET #show' do
            subject { get :show, user_id: member.id, id: membership.id }

            it_behaves_like 'a successful request'
            it 'returns the membership details' do
              expect(JSON.parse(subject.body)).to eq JSON.parse(membership.to_json)
            end
          end

          xdescribe 'PUT #update' do
            let(:params) do
              {
                id: membership.id,
                user_id: member.id,
                role: Membership::ROLES[:admin]
              }
            end

            subject { put :update, params }

            it_behaves_like 'a successful request'

            it 'returns the membership details with updated attributes' do
              membership = JSON.parse(subject.body)

              expect(membership['role']).to eq Membership::ROLES[:admin]
            end
          end

          xdescribe 'DELETE #destroy' do
            subject { delete :destroy, user_id: member.id, id: membership.id }

            it_behaves_like 'a successful request'
            it 'deletes the membership' do
              expect { subject }.to change { Membership.count }.from(2).to(1)
            end
          end
        end
      end
    end
  end
end
