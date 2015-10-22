module Onboarding
  module Api
    module V1
      class InvitationsController < ApplicationController
        before_action :authenticate
        before_action :load_group, only: [:create]
        before_action :load_invited_user, only: [:create]

        # Creates a new Invitation
        #
        # POST /api/v1/invitations
        #
        def create
          authorize(:invite, @group)

          invitation = Invitation.new(
            group:        @group,
            invited_by:   current_user,
            email: invitation_params[:email]
          )

          invitation_service = InvitationService.new(invitation)
          if invitation_service.create
            render json: InvitationSerializer.new(invitation)
          else
            render status: :bad_request,
              json: {
                model: invitation.class.name,
                errors: invitation.errors.full_messages
              }
          end
        end

        # GET /api/v1/invitations/:token
        #
        def show
          @invitation = ::Onboarding::Invitation.find_by_token(params[:token])

          if @invitation
            render json: InvitationSerializer.new(invitation)
          else
            render nothing: true, status: :not_found
          end
        end

        # POST /api/v1/invitations/accept:token
        #
        def accept
        end

        private

        def invitation_params
          params.permit(:group_id, :email)
        end

        def load_group
          @group = ::Onboarding::Group.find_by_id(invitation_params[:group_id])

          return if @group

          render status: :not_found, json: { errors: "Group not found" }
        end

        def load_invited_user
          @invited_user = Onboarding::User.find_by_email(invitation_params[:email])
          # @invited_user = Onboarding::User.create_from_email(invitation_params[:email]) unless @invited_user
        end
      end
    end
  end
end
