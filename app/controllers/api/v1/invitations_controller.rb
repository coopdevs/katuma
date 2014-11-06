module Api
  module V1
    class InvitationsController < ApplicationController

      before_action :authenticate
      before_action :retrieve_collection, only: [:index]

      def index
        render json: InvitationsSerializer.new(@collection)
      end

      def create
        invitation = Invitation.new(invitation_params)
        invitation_creator = InvitationCreator.new(invitation, current_user)
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

      private

      def collection_params
        params.permit(:group_id)
      end

      def invitation_params
        params.permit(:email, :group_id)
      end

      def retrieve_collection
        group = current_user.groups.find_by_id(collection_params[:group_id])

        if group && Membership.where(group: group, user: current_user, role: Membership::ROLES[:admin]).any?
          @collection = Invitation.where(group_id: group.id)
        else
          @collection = Invitation.none
        end
      end
    end
  end
end
