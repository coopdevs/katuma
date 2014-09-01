module Api
  module V1
    class MembershipsController < ApplicationController

      before_action :authenticate
      before_action :load_user,
        only: :index
      before_action :find_and_authorize_membership,
        only: [:show, :update, :destroy]

      def index
        render json: MembershipsSerializer.new(@user.memberships)
      end

      def show
        render json: MembershipSerializer.new(@membership)
      end

      def create
        membership = Membership.new(membership_params)
        if membership.save
          render json: MembershipSerializer.new(membership)
        else
          render status: :bad_request,
                 json: {
                   model: membership.class.name,
                   errors: membership.errors.full_messages
                 }
        end
      end

      def update
        if @membership.update_attributes(membership_params)
          render json: MembershipSerializer.new(@membership)
        else
          render status: :bad_request,
                 json: {
                   model: @membership.class.name,
                   errors: @membership.errors.full_messages
                 }
        end
      end

      def destroy
        render json: @membership.destroy
      end

      private

      def membership_params
        params.permit(:group_id, :user_id, :role)
      end

      def load_user
        @user = User.find(params[:user_id])
      end

      def find_and_authorize_membership
        @membership = Membership.find(params[:id])

        authorize @membership
      end
    end
  end
end
