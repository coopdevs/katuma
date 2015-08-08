module Landing
  class LandingController < ApplicationController
    before_action :redirect_if_logged_in

    def main
    end
  end
end
