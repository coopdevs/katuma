module Onboarding
  module Api
    module V1
      class InvitationsController < ApplicationController
        before_action :authenticate, except: [:show, :accept]
        before_action :load_invitation, only: [:show, :accept]

        # GET /api/v1/invitations?group_id=:id
        #
        def index
          group = load_group(invitations_params[:group_id])
          authorize group, :show?

          invitations = Invitation.where(group_id: group.id)

          render json: InvitationsSerializer.new(invitations)
        end

        # POST /api/v1/invitations
        #
        def create
          group = load_group(invitation_params[:group_id])
          authorize group, :invite?

          valid_email = extract_emails(invitation_params[:email])

          if valid_email.any?
            invitation = InvitationService.new.create!(group, current_user, valid_email)

            render json: InvitationSerializer.new(invitation)
          else
            render(
              status: :bad_request,
              json: { errors: { emails: t('onboarding.invitation.bulk.errors.invalid') } }
            )
          end
        end

        # Creates invitations in bulk
        #
        # POST /api/v1/invitations/bulk
        #
        def bulk
          group = load_group(bulk_params[:group_id])
          authorize group, :invite?

          valid_emails = extract_emails(bulk_params[:emails])

          if valid_emails.any?
            InvitationService.new.bulk_invite!(group, current_user, valid_emails)

            head :accepted
          else
            render(
              status: :bad_request,
              json: { errors: { emails: t('onboarding.invitation.bulk.errors.invalid') } }
            )
          end
        end

        # GET /api/v1/invitations/:token
        #
        def show
          render status: :ok, json: { email: @invitation.email }
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

        def invitations_params
          params.require(:group_id)
          params.permit(:group_id)
        end

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

        # @param group_id [Integer]
        # @return [Group]
        def load_group(group_id)
          group = ::Onboarding::Group.find_by_id(group_id)

          head :not_found unless group

          group
        end

        def load_invitation
          @invitation = Invitation.find_by_token(accept_params[:token])

          head :not_found unless @invitation
        end

        # Filters only the valid emails, we just pick the first 100 valid emails
        # We don't want to allow infinite invitations.
        #
        # @param emails [String] comma separated email addresses
        # @return [Array<String>]
        def extract_emails(emails)
          return [] if emails.blank?

          emails.
            split(',').
            select { |email| ::EmailValidator.valid?(email) }.
            first(100)
        end
      end
    end
  end
end
