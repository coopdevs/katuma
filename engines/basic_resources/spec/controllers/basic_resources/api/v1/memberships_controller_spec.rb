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
          let(:group) { FactoryGirl.create(:group) }
          let(:membership) do
            Membership.create!(
              basic_resource_group_id: group.id,
              user_id: user.id,
              role: MemberRole.new(:admin)
            )
          end

          before { authenticate_as user }

          describe 'GET #index' do
            before { membership }

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

            context 'when basic_resource_group_id is passed' do
              subject { get :index, basic_resource_group_id: group_id }

              context 'but the group does not exists' do
                let(:group_id) { 666 }

                it_behaves_like 'a not found request'
              end

              context 'and the user does not pertain to the group' do
                let(:other_group) { FactoryGirl.create(:group) }
                let(:group_id) { other_group.id }

                it_behaves_like 'a forbidden request'
              end

              context 'and the user pertains to the group' do
                let(:group_id) { group.id }
                let(:other_user) { FactoryGirl.create(:user) }
                let!(:membership_other_user) do
                  Membership.create!(
                    basic_resource_group_id: group.id,
                    user_id: other_user.id,
                    role: MemberRole.new(:member)
                  )
                end

                it_behaves_like 'a successful request'

                describe 'body' do
                  subject { JSON.parse(response.body) }

                  before { get :index, basic_resource_group_id: group_id }

                  it do
                    is_expected.to contain_exactly(
                      JSON.parse(MembershipSerializer.new(membership).to_json),
                      JSON.parse(MembershipSerializer.new(membership_other_user).to_json)
                    )
                  end
                end
              end
            end
          end

          describe 'GET #show' do
            subject { get :show, id: membership.id }

            context 'when the membership does not exist' do
              let(:membership) { instance_double(Membership, id:666) }

              it_behaves_like 'a not found request'
            end

            context 'when the membership is not associated to the user' do
              let(:membership) do
                Membership.create!(
                  basic_resource_group_id: group.id,
                  user_id: FactoryGirl.create(:user).id,
                  role: MemberRole.new(:member)
                )
              end

              it_behaves_like 'a forbidden request'
            end

            context 'when the membership is associated to the user' do
              it_behaves_like 'a successful request'

              it 'returns the membership details' do
                expect(JSON.parse(subject.body)).to eq JSON.parse(membership.to_json)
              end
            end
          end

          describe 'PUT #update' do
            subject { put :update, id: membership.id }

            context 'when the membership does not exist' do
              let(:membership) { instance_double(Membership, id:666) }

              it_behaves_like 'a not found request'
            end

            context 'when the membership is not associated to the user' do
              let(:membership) do
                Membership.create!(
                  basic_resource_group_id: group.id,
                  user_id: FactoryGirl.create(:user).id,
                  role: MemberRole.new(:member)
                )
              end

              it_behaves_like 'a forbidden request'
            end

            context 'when the membership is associated to the user' do
              context 'and the user is admin' do
                it_behaves_like 'a successful request'
              end

              context 'and the user is not an admin' do
                let(:membership) do
                  Membership.create!(
                    basic_resource_group_id: group.id,
                    user_id: user.id,
                    role: MemberRole.new(:member)
                  )
                end

                it_behaves_like 'a forbidden request'
              end
            end
          end

          describe 'DELETE #destroy' do
            subject { delete :destroy, id: membership.id }

            context 'when the membership does not exist' do
              let(:membership) { instance_double(Membership, id:666) }

              it_behaves_like 'a not found request'
            end

            context 'when the membership is not associated to the user' do
              let(:membership) do
                Membership.create!(
                  basic_resource_group_id: group.id,
                  user_id: FactoryGirl.create(:user).id,
                  role: MemberRole.new(:member)
                )
              end

              it_behaves_like 'a forbidden request'
            end

            context 'when the membership is associated to the user' do
              context 'and the user is admin' do
                it_behaves_like 'a successful request'
              end

              context 'and the user is not an admin' do
                let(:membership) do
                  Membership.create!(
                    basic_resource_group_id: group.id,
                    user_id: user.id,
                    role: MemberRole.new(:member)
                  )
                end

                it_behaves_like 'a forbidden request'
              end
            end
          end

          describe 'POST #create' do
            subject { post :create, params }

            context 'associating a user to a group' do
              let(:merce) { FactoryGirl.create(:user) }
              let(:params) do
                {
                  user_id: merce.id,
                  basic_resource_group_id: group.id,
                  role: MemberRole.new(:admin).to_i
                }
              end

              context 'when the user does not pertain to the group' do
                it_behaves_like 'a forbidden request'
              end

              context 'when the user pertain to the group' do
                context 'as a not admin' do
                  it_behaves_like 'a forbidden request'
                end

                context 'as an admin' do
                  before { membership }

                  context 'with valid params' do
                    it_behaves_like 'a successful request'

                    describe 'body' do
                      before { post :create, params }

                      subject { JSON.parse(response.body) }

                      it do
                        is_expected.to include(
                          'user_id' => merce.id,
                          'basic_resource_group_id' => group.id,
                          'basic_resource_producer_id' => nil,
                          'group_id' => nil,
                          'role' => MemberRole.new(:admin).to_i
                        )
                      end
                    end
                  end

                  context 'with not valid params' do
                    let(:params) { { basic_resource_group_id: group.id } }

                    it_behaves_like 'a bad request'
                  end
                end
              end
            end
          end

          xcontext 'associating a user to a producer' do
          end

          xcontext 'associating a group to a producer' do
          end
        end
      end
    end
  end
end
