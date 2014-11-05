module Api
  module V1
    class InvitationsController < ApplicationController

      before_action :authenticate
      #before_action :find_and_authorize_invitation

      def index
        @invitations = Invitation.where(group_id: params[:group_id])

        render json: InvitationsSerializer.new(@invitations)
      end

      def show
        render json: InvitationSerializer.new(@invitation)
      end

      private

      def invitation_params
        params.permit(:email, :group_id, :user_id)
      end

      def find_and_authorize_invitation
        @invitation = Group.find(params[:group_id])
        authorize @group
      end
    end
  end
end
