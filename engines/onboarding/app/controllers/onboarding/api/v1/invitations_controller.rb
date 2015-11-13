module Onboarding
  module Api
    module V1
      class InvitationsController < ApplicationController

        before_action :authenticate
        before_action :load_group, only: [:create]
        before_action :load_invited_user, only: [:create]

        # Creates a new Invitation
        #
        def create
          invitation = Invitation.new({
            group:        @group,
            invited_by:   current_user,
            invited_user: @invited_user
          })

          authorize(invitation)

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

        private

        def invitation_params
          params.permit(:group_id, :email)
        end

        def load_group
          @group = current_user.groups.find_by_id(invitation_params[:group_id])

          head :not_found unless @group
        end

        def load_invited_user
          @invited_user = Onboarding::User.find_by_email(invitation_params[:email])
          @invited_user = Onboarding::User.create_from_email(invitation_params[:email]) unless @invited_user

          head :not_found unless @invited_user
        end
      end
    end
  end
end
