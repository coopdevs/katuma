module Onboarding
  module Api
    module V1
      class InvitationsController < ApplicationController
        before_action :authenticate, only: [:bulk]
        before_action :load_group, only: [:bulk]
        before_action :load_invitation, only: [:show, :accept]

        # Creates invitations in bulk
        #
        # POST /api/v1/invitations/bulk
        #
        def bulk
          authorize @group

          emails = bulk_params[:emails] || ''

          if emails.empty?
            return render(
              status: :bad_request,
              json: {errors: {emails: t('onboarding.invitation.bulk.errors.empty') }}
            )
          end

          emails = emails.split(',')
          valids = valid_emails(emails)

          if valids.any?
            # We pick first 100 valid emails
            # We don't want to allow infinite invitations.
            valid_emails = valids.first(100)
            InvitationService.new.bulk_invite!(@group, current_user, valid_emails)

            render nothing: true, status: :accepted
          else
            render(
              status: :bad_request,
              json: {errors: {emails: t('onboarding.invitation.bulk.errors.invalid') }}
            )
          end
        end

        #
        # GET /invitations/:token
        #
        def show
          if current_user
            render status: :not_found, nothing: true
          else
            render status: :ok, json: { email: @invitation.email }
          end
        end

        # POST /api/v1/invitations/accept/:token
        #
        def accept
          user = InvitationService.new.accept!(@invitation, accept_params)

          if user.valid? && user.persisted?
            render json: ::Account::UserSerializer.new(user)
          else
            render(
              status: :bad_request,
              json: user.errors.to_json
            )
          end
        end

        private

        # :emails is a String containing a comma separated list of email addresses
        #
        def bulk_params
          params.require(:group_id)
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
