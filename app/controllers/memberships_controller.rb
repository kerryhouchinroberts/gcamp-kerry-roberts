class MembershipsController < ApplicationController

  def index
    @memberships = Membership.all
    @project = Project.find(params[:project_id])
    @membership = @project.memberships.build
  end

  def create
    @membership = Membership.new(membership_params)
    @project = Project.find(params[:project_id])
    @membership.project_id = @project.id
    if @membership.save
      redirect_to project_path(@project), notice: "#{@membership.user.full_name}was successfully added."
    else
      render :index, notice: "Membership was not saved successfully."
    end
  end

  private
  def membership_params
    params.require(:membership).permit(:role, :project_id, :user_id)
  end

end
