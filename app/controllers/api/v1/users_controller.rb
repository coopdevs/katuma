module Api
  module V1
    class UsersController < ApplicationController

      before_action :load_memberable, only: :index

      # ToDo: remove this and put bootstrap data
      # in dashboard index HTML
      def bootstrap
        render json: current_user.serializable_hash(methods: [:waiting_group_ids, :group_ids])
      end

      def index
        render json: @memberable.users
      end

      def show
        render json: User.find(params[:id])
      end

      def create
        user = User.new(users_params)
        if user.save
          render json: user
        else
          render status: :bad_request,
                 json: {
                   model: user.class.name,
                   errors: user.errors.full_messages
                 }
        end
      end

      def update
        user = User.find(params[:id])
        if user.update_attributes(users_params)
          render json: user
        else
          render status: :bad_request,
                 json: {
                   model: user.class.name,
                   errors: user.errors.full_messages
                 }
        end
      end

      def destroy
        render json: User.destroy(params[:id])
      end

      private

      def users_params
        params.require(:user).permit(:name, :email)
      end

      def load_memberable
        resource, id = request.path.split('/')[3,4]
        @memberable = resource.singularize.classify.constantize.find(id)
      end

    end
  end
end
