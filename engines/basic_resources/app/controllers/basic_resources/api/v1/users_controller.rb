module BasicResources
  module Api
    module V1
      class UsersController < ApplicationController
        before_action :authenticate

        def index
          authorize(group)
          users = UsersCollection.new(group).build
          render json: UsersSerializer.new(users)
        rescue ActiveRecord::RecordNotFound
          head :not_found
        end

        private

        def group
          Group.find(params[:group_id])
        end
      end
    end
  end
end
