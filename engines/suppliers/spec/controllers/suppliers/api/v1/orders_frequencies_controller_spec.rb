require 'rails_helper'
require_relative '../../../../../../../spec/support/shared_examples/controllers.rb'
require_relative '../../../../../../../spec/support/authentication.rb'

module Suppliers
  module Api
    module V1
      describe OrdersFrequenciesController do
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
            subject { put :update, id: 666 }

            it_behaves_like 'an unauthorized request'
          end
        end

        context 'Authenticated user' do
          let(:user) do
            u = FactoryGirl.create(:user)
            User.find(u.id)
          end
          let(:group) { FactoryGirl.create(:group) }
          let!(:group_membership) do
            FactoryGirl.create(
              :membership,
              basic_resource_group_id: group.id,
              user_id: user.id,
              role: ::BasicResources::Membership::ROLES[:admin]
            )
          end
          let(:schedule) do
            IceCube::Schedule.new do |f|
              f.add_recurrence_rule IceCube::Rule.weekly
            end
          end
          let(:confirmation_frequency) do
            FactoryGirl.create(
              :orders_frequency,
              group_id: group.id,
              ical: schedule.to_ical,
              frequency_type: Frequency::TYPES[:confirmation]
            )
          end
          let(:delivery_frequency) do
            FactoryGirl.create(
              :orders_frequency,
              group_id: group.id,
              ical: schedule.to_ical,
              frequency_type: Frequency::TYPES[:delivery]
            )
          end

          before { authenticate_as user }

          describe 'GET #index' do
            before { confirmation_frequency }
            before { delivery_frequency }

            subject { get :index, group_id: group_id }

            context 'passing a `group_id` that does not exist' do
              let(:group_id) { 666 }

              it_behaves_like 'a not found request'
            end

            context 'passing a `group_id` of a group not associated to the user' do
              let(:other_group) { FactoryGirl.create(:group) }
              let(:group_id) { other_group.id }

              it_behaves_like 'a forbidden request'
            end

            context 'passing a `group_id` of a group associated to the user' do
              let(:group_id) { group.id }

              it_behaves_like 'a successful request'

              describe 'its body' do
                before { get :index, group_id: group.id }

                subject { JSON.parse(response.body) }

                it do
                  is_expected.to contain_exactly(
                    match(
                      'id' => confirmation_frequency.id,
                      'group_id' => confirmation_frequency.group_id,
                      'to_ical' => confirmation_frequency.to_ical,
                      'frequency_type' => confirmation_frequency.frequency_type,
                      'created_at' => confirmation_frequency.created_at.as_json,
                      'updated_at' => confirmation_frequency.updated_at.as_json
                    ),
                    match(
                      'id' => delivery_frequency.id,
                      'group_id' => delivery_frequency.group_id,
                      'to_ical' => delivery_frequency.to_ical,
                      'frequency_type' => delivery_frequency.frequency_type,
                      'created_at' => delivery_frequency.created_at.as_json,
                      'updated_at' => delivery_frequency.updated_at.as_json
                    )
                  )
                end
              end
            end
          end

          describe 'GET #show' do
            before { confirmation_frequency }

            subject { get :show, id: orders_frequency_id }

            context 'requesting a non existent orders_frequency' do
              let(:orders_frequency_id) { 666 }

              it_behaves_like 'a not found request'
            end

            context 'requesting an existent orders_frequency' do
              context 'when the user is associated to the group' do
                let(:orders_frequency_id) { confirmation_frequency.id }

                it_behaves_like 'a successful request'

                describe 'its body' do
                  before { get :show, id: orders_frequency_id }

                  subject { JSON.parse(response.body) }

                  it do
                    is_expected.to match(
                      'id' => confirmation_frequency.id,
                      'group_id' => confirmation_frequency.group_id,
                      'to_ical' => confirmation_frequency.to_ical,
                      'frequency_type' => confirmation_frequency.frequency_type,
                      'created_at' => confirmation_frequency.created_at.as_json,
                      'updated_at' => confirmation_frequency.updated_at.as_json
                    )
                  end
                end
              end

              context 'when the user is not associated to the group' do
                let(:orders_frequency_id) { confirmation_frequency.id }

                before { group_membership.destroy! }

                it_behaves_like 'a forbidden request'
              end
            end
          end

          describe 'POST #create' do
            let(:params) do
              {
                group_id: group.id,
                ical: schedule.to_ical,
                frequency_type: 'delivery'
              }
            end

            subject { post :create, params }

            context 'when passing delivery frequency type' do
              before { post :create, params }

              describe 'its body' do
                subject { JSON.parse(response.body) }
                it { is_expected.to include('frequency_type' => 1) }
              end
            end

            context 'when passing confirmation frequency type' do
              before { post :create, params.merge(frequency_type: 'confirmation') }

              describe 'its body' do
                subject { JSON.parse(response.body) }
                it { is_expected.to include('frequency_type' => 0) }
              end
            end

            context 'when the user is associated to the group' do
              context 'as an `admin`' do
                it_behaves_like 'a successful request'

                describe 'its body' do
                  before { post :create, params }

                  subject { JSON.parse(response.body) }

                  it do
                    is_expected.to include(
                      'group_id' => params[:group_id],
                      'to_ical' => params[:ical],
                      'frequency_type' => 1
                    )
                  end
                end
              end

              context 'as a `member`' do
                before do
                  group_membership.role = ::BasicResources::Membership::ROLES[:member]
                  group_membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end

            context 'when the user is not associated to the group' do
              before { group_membership.destroy! }

              it_behaves_like 'a forbidden request'
            end

            context 'with wrong `group_id` parameter' do
              let(:params) do
                {
                  group_id: 666,
                  to_ical: schedule.to_ical
                }
              end

              it_behaves_like 'a not found request'
            end

            context 'with missing `to_ical` parameter' do
              let(:params) do
                {
                  group_id: group.id
                }
              end

              it_behaves_like 'a bad request'

              describe 'its body' do
                before { post :create, params }

                subject { JSON.parse(response.body) }

                it do
                  is_expected.to match(
                    'errors' => {
                      'frequency' => ["can't be blank"],
                      'frequency_type' => ["can't be blank", 'is not included in the list']
                    }
                  )
                end
              end
            end
          end

          describe 'PUT #update' do
            let(:new_schedule) do
              IceCube::Schedule.new do |f|
                f.add_recurrence_rule IceCube::Rule.weekly.day(:tuesday)
              end
            end
            let(:params) do
              {
                id: orders_frequency_id,
                ical: new_schedule.to_ical
              }
            end

            before { confirmation_frequency }

            subject { put :update, params }

            context 'updating a non existent orders_frequency' do
              let(:orders_frequency_id) { 666 }

              it_behaves_like 'a not found request'
            end

            context 'when the user is associated to the group' do
              let(:orders_frequency_id) { confirmation_frequency.id }

              context 'as an `admin`' do
                context 'with valid parameters' do
                  it_behaves_like 'a successful request'

                  describe 'its body' do
                    before { put :update, params }

                    subject { JSON.parse(response.body) }

                    it do
                      is_expected.to include(
                        'id' => confirmation_frequency.id,
                        'group_id' => confirmation_frequency.group_id,
                        'to_ical' => new_schedule.to_ical,
                        'frequency_type' => confirmation_frequency.frequency_type,
                        'created_at' => confirmation_frequency.created_at.as_json
                      )
                    end
                  end
                end

                context 'with invalid parameters' do
                  let(:params) do
                    {
                      id: orders_frequency_id,
                      ical: ''
                    }
                  end

                  it_behaves_like 'a bad request'

                  describe 'its body' do
                    let(:params) do
                      {
                        id: orders_frequency_id,
                        ical: ''
                      }
                    end
                    before { put :update, params }

                    subject { JSON.parse(response.body) }

                    it do
                      is_expected.to match(
                        'errors' => { 'frequency' => ['can\'t be blank'] }
                      )
                    end
                  end
                end
              end

              context 'as a `member`' do
                before do
                  group_membership.role = ::BasicResources::Membership::ROLES[:member]
                  group_membership.save!
                end

                it_behaves_like 'a forbidden request'
              end
            end

            context 'when the user is not associated to the group' do
              let(:orders_frequency_id) { confirmation_frequency.id }

              before { group_membership.destroy! }

              it_behaves_like 'a forbidden request'
            end
          end
        end
      end
    end
  end
end
