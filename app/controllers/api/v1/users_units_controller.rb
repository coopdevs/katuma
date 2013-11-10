module Api
  module V1
    class UsersUnitsController < ApplicationController

      before_action do
        @group = Group.find(params[:group_id])
      end

      def index
        render json: @group.users_units
      end

      def show
        render json: UsersUnit.find(params[:id])
      end

      def create
        users_unit = @group.users_units.build(users_units_params)
        p users_unit
        if users_unit.save
          render json: users_unit
        else
          render status: :bad_request,
                 json: {
                   model: users_unit.class.name,
                   errors: users_unit.errors.full_messages
                 }
        end
      end

      private

      def users_units_params
        params.require(:users_unit).permit(:name)
      end
    end
  end
end
