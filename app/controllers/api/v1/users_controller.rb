module Api
  module V1
    class UsersController < ApplicationController

      before_action :authenticate, except: :create
      before_action :load_memberable, only: :index

      def index
        render json: UserSerializer.new(@memberable.users)
      end

      def show
        user = User.find(params[:id])
        render json: UserSerializer.new(user)
      end

      def create
        user = User.new(users_params)
        if user.save
          render json: UserSerializer.new(user)
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
          render json: UserSerializer.new(user)
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
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def load_memberable
        resource, id = request.path.split('/')[3,4]
        @memberable = resource.singularize.classify.constantize.find(id)
      end

    end
  end
end
