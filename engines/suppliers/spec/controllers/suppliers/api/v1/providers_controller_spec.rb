require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module Suppliers
  module Api
    module V1
      describe ProvidersController do
        routes { Engine.routes }

        context 'Not authenticaded user' do
          describe 'GET #index' do
            subject { get :index }

            it_behaves_like 'an unauthorized request'
          end
        end

        context 'Authenticated user' do
          let(:user) do
            FactoryGirl.create(:user)
          end
          let(:group_user) { ::Group::User.find(user.id) }
          let(:suppliers_user) { User.find(user.id) }
          let(:group_membership) do
            FactoryGirl.create(
              :membership,
              user: group_user,
              role: ::Group::Membership::ROLES[:admin]
            )
          end
          let(:group) do
            ::Suppliers::Group.find(group_membership.group.id)
          end
          let(:producer_for_group) do
            FactoryGirl.build(:producer, name: 'Related to group')
          end
          let(:producer_for_user) do
            FactoryGirl.build(:producer, name: 'Related to user')
          end
          let(:producer) do
            ::Producers::ProducerCreator.new(
              producer: producer_for_group,
              creator: suppliers_user,
              group: ::Producers::Group.find(group.id)
            ).create

            Producer.last
          end

          before { authenticate_as suppliers_user }

          describe 'GET #index' do
            let!(:supplier) do
              FactoryGirl.create(
                :supplier,
                group: group,
                producer: producer
              )
            end

            subject { get :index, group_id: group.id }

            it_behaves_like 'a successful request'

            describe 'its body' do
              before { get :index, group_id: group.id }

              subject { JSON.parse(response.body) }

              its(:size) { is_expected.to eq(1) }
              it { is_expected.to include(JSON.parse(producer.to_json)) }
            end
          end
        end
      end
    end
  end
end
