module BasicResources
  module Api
    module V1
      class UsersController < ApplicationController
        before_action :authenticate

        def index
          users = UsersCollection.new
          render json: UsersSerializer.new(users)
        end

        private

        def group
          Group.find_by_id(params[:group_id])
        end
      end
    end
  end
end
