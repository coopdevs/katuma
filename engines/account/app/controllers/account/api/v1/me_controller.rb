module Account
  module Api
    module V1
      class MeController < ApplicationController

        def show
          if current_user
            render json: UserSerializer.new(current_user)
          else
            render status: :unauthorized, json: {}
          end
        end

      end

    end
  end
end
