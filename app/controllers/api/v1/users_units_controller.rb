module Api
  module V1
    class UsersUnitsController < ApplicationController

      def index
        render json: UsersUnit.all
      end

      def show
        render json: UsersUnit.find(params[:id])
      end

      def create
        users_unit = UsersUnit.new(users_units_params)
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

      def update
        users_unit = UsersUnit.find(params[:id])
        if users_unit.update_attributes(users_units_params)
          render json: users_unit
        else
          render status: :bad_request,
                 json: {
                   model: users_unit.class.name,
                   errors: users_unit.errors.full_messages
                 }
        end
      end

      def destroy
        render json: UsersUnit.destroy(params[:id])
      end

      private

      def users_units_params
        params.require(:users_unit).permit(:name,
                                           users_attributes: [:name, :email])
      end

    end
  end
end
