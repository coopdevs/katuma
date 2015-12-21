module Group
  module Api
    module V1
      class MembershipsController < ApplicationController

        before_action :authenticate
        before_action :find_and_authorize_membership, only: [:show, :update, :destroy]

        # GET /api/v1/memberships
        #
        def index
          group_ids = ::Group::Membership.where(user_id: current_user.id).pluck(:group_id)
          memberships = ::Group::Membership.where(group_id: group_ids)

          render json: MembershipsSerializer.new(memberships)
        end

        # GET /api/v1/memberships/:id
        #
        def show
          render json: MembershipSerializer.new(@membership)
        end

        # POST /api/v1/memberships
        #
        def create
          membership = Membership.new(membership_params)
          if membership.save
            render json: MembershipSerializer.new(membership)
          else
            render(
              status: :bad_request,
              json: {
                model: membership.class.name,
                errors: membership.errors
              }
            )
          end
        end

        # PUT /api/v1/memberships/:id
        #
        def update
          if @membership.update_attributes(membership_params)
            render json: MembershipSerializer.new(@membership)
          else
            render(
              status: :bad_request,
              json: {
                model: @membership.class.name,
                errors: @membership.errors
              }
            )
          end
        end

        # DELETE /api/v1/memberships/:id
        #
        def destroy
          render json: @membership.destroy
        end

        private

        def membership_params
          params.permit(:group_id, :user_id, :role)
        end

        def find_and_authorize_membership
          @membership = Membership.find_by_id(params[:id])

          head :not_found unless @membership

          authorize @membership
        end
      end
    end
  end
end
