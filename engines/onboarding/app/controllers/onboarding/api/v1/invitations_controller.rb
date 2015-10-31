module Onboarding
  module Api
    module V1
      class InvitationsController < ApplicationController
        before_action :authenticate
        before_action :load_group, only: [:create, :bulk]
        before_action :load_invitation, only: [:accept]

        # Creates invitations in bulk
        #
        # POST /api/v1/invitations/bulk
        #
        def bulk
          authorize @group

          emails = bulk_params[:emails].split(',')
          valids = valid_emails(emails)

          if valids.any?
            InvitationService.new.bulk_invite!(@group, current_user, valids)

            render nothing: true, status: :accepted
          else
            render nothing: true, status: :bad_request
          end
        end

        # POST /api/v1/invitations/accept/:token
        #
        def accept
          user = InvitationService.new.accept!(@invitation, accept_params)

          if user.valid? && user.persisted?
            render json: UserSerializer.new(user)
          else
            render(
              status: :bad_request,
              json: user.errors.to_json
            )
          end
        end

        private

        def invitation_params
          params.require(:group_id)
          params.require(:email)
          params.permit(:group_id, :email)
        end

        # :emails is a String containing a comma separated list of email addresses
        #
        def bulk_params
          params.require(:group_id)
          params.require(:emails)
          params.permit(:group_id, :emails)
        end

        def accept_params
          params.require(:token)
          params.permit(:token, :username, :first_name, :last_name, :password, :password_confirmation)
        end

        def load_group
          @group = ::Onboarding::Group.find_by_id(bulk_params[:group_id])

          head :not_found unless @group
        end

        def load_invitation
          @invitation = Invitation.find_by_token(accept_params[:token])

          head :not_found unless @invited_user
        end

        # Filter only the valid emails
        #
        # @param emails [Array<String>]
        # @return [Array<String>]
        def valid_emails(emails)
          emails.select { |email| ::EmailValidator.valid?(email) }
        end
      end
    end
  end
end
