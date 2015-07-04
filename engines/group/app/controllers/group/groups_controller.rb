module Group
  class GroupsController < ApplicationController

    before_action :authenticate
    before_action :load_group, only: [:show, :update, :destroy, :settings]

    # GET /dashboard
    #
    def index
      @groups = current_user.groups
    end

    # GET /groups/:id
    #
    def show
    end

    # GET /groups/new
    #
    def new
      @group = ::Group::Group.new
    end

    # PATCH/PUT /groups/:id
    #
    def update
      authorize @group

      if @group.update_attributes(group_params)
        redirect_to @group
      else
        render :settings
      end
    end

    # POST /groups
    #
    def create
      @group = ::Group::Group.new(group_params)

      if GroupCreation.new(@group, current_user).create
        redirect_to @group
      else
        render :new
      end
    end

    # DELETE /groups/:id
    #
    # SIDE EFFECTS:
    #  - all the Group::Membership entities related with the group will be deleted too
    def destroy
      authorize @group

      @group.destroy

      redirect_to :dashboard
    end

    # GET /groups/:id/settings
    #
    def settings
    end

    private

    def load_group
      @group = ::Group::Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :text)
    end
  end
end
