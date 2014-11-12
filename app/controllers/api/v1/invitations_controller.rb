module Api
  module V1
    class InvitationsController < ApplicationController

      before_action :authenticate
      before_action :load_group, only: [:index, :create]
      before_action :load_invitation, only: [:accept]
      before_action :load_collection, only: [:index]

      def index
        render json: InvitationsSerializer.new(@collection)
      end

      def create
        invitation = Invitation.new(
          group: @group,
          user:  current_user,
          email: invitation_params[:email]
        )

        authorize(invitation)

        invitation_creator = InvitationService.new(invitation)
        if invitation_creator.create
          render json: InvitationSerializer.new(invitation)
        else
          render status: :bad_request,
                 json: {
                   model: invitation.class.name,
                   errors: invitation.errors.full_messages
                 }
        end
      end

      def accept
        if @invitation.email != accept_params[:email]
          render status: :bad_request,
            json: {
              errors: 'The email address associated to the invitation does not match'
            }
        end

        if InvitationService.new(@invitation).accept!
          render nothing: true
        else
          render nothing: true, status: :bad_request
        end
      end

      private

      def collection_params
        params.permit(:group_id)
      end

      def invitation_params
        params.permit(:email, :group_id)
      end

      def accept_params
        params.permit(:email)
      end

      def load_group
        @group = current_user.groups.find_by_id(collection_params[:group_id])

        unless @group
          render status: :bad_request,
            json: {
              errors: 'Error related to Group'
            }
        end
      end

      def load_invitation
        @invitation = Invitation.find_by_id(params[:id])

        render nothing: true, status: :not_found unless @invitation
      end

      def load_collection
        if Membership.where(group: @group, user: current_user, role: Membership::ROLES[:admin]).any?
          @collection = Invitation.where(group_id: @group.id)
        else
          @collection = Invitation.none
        end
      end
    end
  end
end
