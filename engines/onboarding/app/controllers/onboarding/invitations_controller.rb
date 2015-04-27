module Onboarding
  class InvitationsController < ApplicationController

    before_action :redirect_if_not_signed_up
    before_action :redirect_if_not_logged_in

    def accept
      @group = Group.find_by_id(accept_params[:group_id])
      @invitation = Invitation.where(group: @group, id: accept_params[:id]).first

      Membership.create(group: @group, user: current_user, role: Group::Membership::ROLES[:member])
    end

    private

    def accept_params
      params.permit(:email, :group_id, :id)
    end

    def redirect_if_not_signed_up
      unless User.find_by_email(accept_params[:email])
        redirect_to "/complete_confirmed?confirmed_email=#{accept_params[:email]}"
      end
    end

    def redirect_if_not_logged_in
      unless current_user && current_user.email == accept_params[:email]
        @_current_user = session[:current_user_id] = nil

        redirect_to :login
      end
    end
  end
end
