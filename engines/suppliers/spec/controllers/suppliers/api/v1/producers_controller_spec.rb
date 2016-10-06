require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module Suppliers
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
        end

        context 'Authenticated user' do
          let(:group_admin) do
            user = FactoryGirl.create(:user)
            ::BasicResources::User.find(user.id)
          end
          let(:group) { FactoryGirl.create(:group) }
          let!(:group_membership) do
            FactoryGirl.create(
              :membership,
              basic_resource_group_id: group.id,
              user: group_admin,
              role: Membership::ROLES[:admin]
            )
          end
          let!(:producer_for_group) do
            producer = FactoryGirl.build(:producer, name: 'Related to group')
            ::BasicResources::ProducerCreator.new(
              producer: producer,
              creator: group_admin,
              group: group
            ).create!
          end
          let!(:test_producer_for_group) do
            producer = FactoryGirl.build(:producer, name: 'Related to group but test')
            ::BasicResources::ProducerCreator.new(
              producer: producer,
              creator: group_admin,
              group: group
            ).create!
          end
          let(:producer_admin) do
            user = FactoryGirl.create(:user)
            ::BasicResources::User.find(user.id)
          end
          let!(:producer_for_user) do
            producer = FactoryGirl.build(:producer, name: 'Related to user')
            ::BasicResources::ProducerCreator.new(
              producer: producer,
              creator: producer_admin
            ).create!
          end

          before { authenticate_as suppliers_user }

          describe 'GET #index' do
            before do
              FactoryGirl.create(
                :supplier,
                group_id: group.id,
                producer_id: producer_for_group.id
              )
              FactoryGirl.create(
                :supplier,
                group_id: group.id,
                producer_id: producer_for_user.id
              )
            end

            context 'without passing a `group_id` parameter`' do
              subject { get :index }

              context 'when the user pertains to some producer' do
                let(:suppliers_user) { User.find(producer_admin.id) }

                it_behaves_like 'a successful request'

                its(:body) { is_expected.to eq(ProducersSerializer.new([producer_for_user]).to_json) }
              end

              context 'when the user does not pertain to any producer' do
                let(:suppliers_user) { User.find(group_admin.id) }

                it_behaves_like 'a successful request'
                its(:body) { is_expected.to eq('[]') }
              end
            end

            context 'passing a `group_id` parameter`' do
              subject { get :index, group_id: group.id }

              context 'when the user pertains to the group' do
                let(:suppliers_user) { User.find(group_admin.id) }
                let(:expected_producers) do
                  [
                    producer_for_user,
                    producer_for_group,
                    test_producer_for_group
                  ]
                end

                it_behaves_like 'a successful request'

                describe 'its body' do
                  before { get :index, group_id: group.id }

                  subject { JSON.parse(response.body) }

                  it do
                    is_expected.to contain_exactly(
                      *expected_producers.map do |p|
                        JSON.parse(ProducerSerializer.new(p).to_json)
                      end
                    )
                  end
                end
              end

              context 'when the user does not pertain to the group' do
                let(:suppliers_user) { User.find(producer_admin.id) }

                it_behaves_like 'a forbidden request'
              end
            end
          end

          describe 'GET #show' do
            context 'requesting a non existent producer' do
              let(:producer) { instance_double(Producer, id: 666) }
              let(:suppliers_user) { User.find(producer_admin.id) }

              subject { get :show, id: producer.id }

              it_behaves_like 'a not found request'
            end

            context 'when the user is member of the producer directly' do
              let(:suppliers_user) { User.find(producer_admin.id) }

              subject { get :show, id: producer_for_user.id }

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { get :show, id: producer_for_user.id }

                subject { JSON.parse(response.body) }

                it { is_expected.to eq(JSON.parse(ProducerSerializer.new(producer_for_user).to_json)) }
              end
            end

            context 'when the user is member of the producer through a group' do
              let(:suppliers_user) { User.find(group_admin.id) }

              subject { get :show, id: producer_for_group.id }

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { get :show, id: producer_for_group.id }

                subject { JSON.parse(response.body) }

                it { is_expected.to eq(JSON.parse(ProducerSerializer.new(producer_for_group).to_json)) }
              end
            end

            context 'when the user is member of a group which the producer is provider' do
              let(:suppliers_user) { User.find(group_admin.id) }
              let(:other_group) { FactoryGirl.create(:group) }
              before do
                FactoryGirl.create(
                  :membership,
                  basic_resource_group_id: other_group.id,
                  user: group_admin,
                  role: Membership::ROLES[:admin]
                )
                FactoryGirl.create(
                  :supplier,
                  group_id: other_group.id,
                  producer_id: producer_for_user.id
                )
              end

              subject { get :show, id: producer_for_user.id }

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { get :show, id: producer_for_user.id }

                subject { JSON.parse(response.body) }

                it { is_expected.to eq(JSON.parse(ProducerSerializer.new(producer_for_user).to_json)) }
              end
            end

            context 'when the user is not related to the producer' do
              let(:suppliers_user) do
                user = FactoryGirl.create(:user)
                User.find(user.id)
              end

              subject { get :show, id: producer_for_group.id }

              it_behaves_like 'a forbidden request'
            end
          end
        end
      end
    end
  end
end
