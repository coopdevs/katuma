module Account
  module Api
    module V1
      class MeController < ApplicationController
        before_action :authenticate

        def show
          render json: UserSerializer.new(current_user)
        end
      end
    end
  end
end
