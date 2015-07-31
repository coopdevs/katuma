module Landing
  class LandingController < ApplicationController
    before_action :redirect_if_logged_in
    layout 'shared/layouts/base', only: :main

    def main
    end
  end
end
