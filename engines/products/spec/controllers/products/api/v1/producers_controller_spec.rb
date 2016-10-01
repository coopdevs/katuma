require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module Products
  module Api
    module V1
      describe ProducersController do
        routes { Engine.routes }

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
            subject { post :create, name: 'ciola' }

            it_behaves_like 'an unauthorized request'
          end

          describe 'PUT #update' do
            subject { put :update, id: 666, name: 'ciola' }

            it_behaves_like 'an unauthorized request'
          end

          describe 'DELETE #destroy' do
            subject { delete :destroy, id: 666 }

            it_behaves_like 'an unauthorized request'
          end
        end

        context 'Authenticated user' do
          let(:user) do
            FactoryGirl.create(:user)
          end
          let(:group_user) { ::Group::User.find(user.id) }
          let(:producers_user) { User.find(user.id) }
          let(:group_membership) do
            FactoryGirl.create(
              :membership,
              user: group_user,
              role: ::Group::Membership::ROLES[:admin]
            )
          end
          let(:group) do
            ::Products::Group.find(group_membership.group.id)
          end
          let(:producer_for_group) do
            FactoryGirl.build(:producer, name: 'Related to group')
          end
          let(:producer_for_user) do
            FactoryGirl.build(:producer, name: 'Related to user')
          end

          before { authenticate_as producers_user }

          describe 'GET #index' do
            before do
              ProducerCreator.new(
                producer: producer_for_group,
                creator: producers_user,
                group: group
              ).create
              ProducerCreator.new(
                producer: producer_for_user,
                creator: producers_user
              ).create
            end

            subject { get :index }

            it_behaves_like 'a successful request'

            describe 'its body' do
              before { get :index }

              subject { JSON.parse(response.body) }

              its(:size) { is_expected.to eq(2) }
              it { is_expected.to include(JSON.parse(producer_for_user.to_json)) }
              it { is_expected.to include(JSON.parse(producer_for_group.to_json)) }
            end
          end

          describe 'GET #show' do
            context 'requesting a non existent producer' do
              subject { get :show, id: 666 }

              it_behaves_like 'a not found request'
            end

            context 'requesting a producer directly associated to the user' do
              let(:producer) do
                ProducerCreator.new(
                  producer: producer_for_user,
                  creator: producers_user
                ).create

                Producer.last
              end

              subject { get :show, id: producer.id }

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { get :show, id: producer.id }

                subject { JSON.parse(response.body) }

                it { is_expected.to include(JSON.parse(producer_for_user.to_json)) }
              end
            end

            context 'requesting a producer associated to the user through a group' do
              let(:producer) do
                ProducerCreator.new(
                  creator: user,
                  group: group,
                  producer: producer_for_group
                ).create

                Producer.last
              end

              subject { get :show, id: producer.id }

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { get :show, id: producer.id }

                subject { JSON.parse(response.body) }

                it { is_expected.to include(JSON.parse(producer_for_group.to_json)) }
              end
            end

            context 'requesting a producer not associated to the current user' do
              let(:another_user) do
                user = FactoryGirl.create(:user)
                User.find(user.id)
              end
              let(:producer) do
                ProducerCreator.new(
                  producer: producer_for_user,
                  creator: another_user
                ).create

                Producer.last
              end

              subject { get :show, id: producer.id }

              it_behaves_like 'a forbidden request'
            end
          end

          describe 'POST #create' do
            let(:correct_params) do
              {
                name: 'Tomatekken 3',
                email: 'tomatekken3@katuma.org',
                address: 'c/ dels tomatekkens, 3'
              }
            end
            let(:params) { correct_params }

            subject { post :create, params }

            it_behaves_like 'a successful request'

            describe 'its body' do
              before { post :create, params }

              subject { JSON.parse(response.body) }

              its(['name']) { is_expected.to eq(params[:name]) }
              its(['email']) { is_expected.to eq(params[:email]) }
              its(['address']) { is_expected.to eq(params[:address]) }
            end

            describe 'side effects' do
              let(:created_membership) { Membership.last }

              before { post :create, params }

              describe 'response Link header' do
                let(:http_resource_links) do
                  ::Shared::HttpResourceLinks.build([created_membership], 'created')
                end
                subject { response['Link'] }

                it { is_expected.to eq(http_resource_links) }
              end

              describe 'membership created' do
                subject { created_membership }

                its(:user_id) { is_expected.to eq(user.id) }
                its(:group_id) { is_expected.to eq(nil) }
                its(:role) { is_expected.to eq(Membership::ROLES[:admin]) }

                context 'passing a `group_id` parameter' do
                  let(:params_with_group_id) { correct_params.merge(group_id: group.id) }
                  let(:params) { params_with_group_id }

                  its(:user_id) { is_expected.to eq(nil) }
                  its(:group_id) { is_expected.to eq(group.id) }
                  its(:role) { is_expected.to eq(Membership::ROLES[:admin]) }
                end
              end
            end

            context 'with wrong parameters' do
              let(:wrong_params) do
                {
                  name: 'Tomatekken 3'
                }
              end

              subject { post :create, wrong_params }

              it_behaves_like 'a bad request'

              describe 'its body' do
                before { post :create, wrong_params }

                subject { JSON.parse(response.body) }

                its(:size) { is_expected.to eq(2) }
                it { is_expected.to include('email' => ["can't be blank"]) }
                it { is_expected.to include('address' => ["can't be blank"]) }
              end
            end

            context 'creating a producer for a group' do
              subject { post :create, correct_params.merge(group_id: group.id) }

              context 'when the user is an admin of the group' do
                it_behaves_like 'a successful request'
              end

              context 'when the user is not an admin of the group' do
                before do
                  group_membership.role = ::Group::Membership::ROLES[:member]
                  group_membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end
          end

          describe 'PUT #update' do
            let(:params) do
              {
                id: producer.id,
                name: 'New name'
              }
            end

            context 'updating a non existent producer' do
              let(:producer) { instance_double(Producer, id: 666) }

              subject { put :update, params }

              it_behaves_like 'a not found request'
            end

            context 'updating a producer directly associated to the user' do
              let(:producer) do
                ProducerCreator.new(
                  producer: producer_for_user,
                  creator: producers_user
                ).create

                Producer.last
              end

              subject { put :update, params }

              context 'when the user is a producer admin' do
                it_behaves_like 'a successful request'

                describe 'its body' do
                  before { put :update, params }

                  subject { JSON.parse(response.body) }

                  it { is_expected.to include(JSON.parse(params.to_json)) }
                end
              end

              context 'when the user is not a producer admin' do
                let(:member) do
                  user = FactoryGirl.create(:user, username: 'member')
                  User.find(user.id)
                end
                before do
                  Membership.create(
                    producer: producer,
                    user: member,
                    role: Membership::ROLES[:member]
                  )
                end

                before { authenticate_as member }

                it_behaves_like 'a forbidden request'
              end
            end

            context 'updating a producer associated to the user through a group' do
              let(:producer) do
                ProducerCreator.new(
                  creator: user,
                  group: group,
                  producer: producer_for_group
                ).create

                Producer.last
              end

              subject { put :update, params }

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { put :update, params }

                subject { JSON.parse(response.body) }

                it { is_expected.to include(JSON.parse(params.to_json)) }
              end

              context 'when the user is not a group admin' do
                let(:member) do
                  user = FactoryGirl.create(:user, username: 'member')
                  ::Group::User.find(user.id)
                end
                before do
                  ::Group::Membership.create(
                    group: group_membership.group,
                    user: member,
                    role: Membership::ROLES[:member]
                  )
                end

                before { authenticate_as member }

                it_behaves_like 'a forbidden request'
              end
            end

            context 'updating a producer not associated to the current user' do
              let(:another_user) do
                user = FactoryGirl.create(:user)
                User.find(user.id)
              end
              let(:producer) do
                ProducerCreator.new(
                  producer: producer_for_user,
                  creator: another_user
                ).create

                Producer.last
              end

              subject { put :update, params }

              it_behaves_like 'a forbidden request'
            end
          end

          describe 'DELETE #destroy' do
            let(:id) { producer.id }

            subject { delete :destroy, id: id }

            context 'destroying a non existent producer' do
              let(:producer) { instance_double(Producer, id: 666) }

              it_behaves_like 'a not found request'
            end

            context 'destroying a producer directly associated to the user' do
              let(:producer) do
                ProducerCreator.new(
                  producer: producer_for_user,
                  creator: producers_user
                ).create

                Producer.last
              end

              context 'when the user is a producer admin' do
                it_behaves_like 'a successful request (204)'
              end

              context 'when the user is not a producer admin' do
                let(:member) do
                  user = FactoryGirl.create(:user, username: 'member')
                  User.find(user.id)
                end
                before do
                  Membership.create(
                    producer: producer,
                    user: member,
                    role: Membership::ROLES[:member]
                  )
                end

                before { authenticate_as member }

                it_behaves_like 'a forbidden request'
              end
            end

            context 'destroying a producer associated to the user through a group' do
              let(:producer) do
                ProducerCreator.new(
                  creator: user,
                  group: group,
                  producer: producer_for_group
                ).create

                Producer.last
              end

              it_behaves_like 'a successful request (204)'

              context 'when the user is not a group admin' do
                let(:member) do
                  user = FactoryGirl.create(:user, username: 'member')
                  ::Group::User.find(user.id)
                end
                before do
                  ::Group::Membership.create(
                    group: group_membership.group,
                    user: member,
                    role: Membership::ROLES[:member]
                  )
                end

                before { authenticate_as member }

                it_behaves_like 'a forbidden request'
              end
            end

            context 'updating a producer not associated to the current user' do
              let(:another_user) do
                user = FactoryGirl.create(:user)
                User.find(user.id)
              end
              let(:producer) do
                ProducerCreator.new(
                  producer: producer_for_user,
                  creator: another_user
                ).create

                Producer.last
              end

              it_behaves_like 'a forbidden request'
            end
          end
        end
      end
    end
  end
end
