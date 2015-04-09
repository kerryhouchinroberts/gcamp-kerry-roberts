class MembershipsController < ApplicationController

  layout 'user_layout'

  before_action :authenticate

  def index
    @memberships = Membership.all
    @project = Project.find(params[:project_id])
    @membership = Membership.new
  end

  def create
    @membership = Membership.new(membership_params)
    @project = Project.find(params[:project_id])
    @membership.project_id = @project.id
    if @membership.save
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was successfully added."
    else
      flash.now[:alert] = @membership.errors.full_messages
      render :index
    end
  end

  def update
    @project = Project.find(params[:project_id])
    @membership = Membership.find(params[:id])
    if @membership.update(membership_params)
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was successfully updated."
    else
      flash.now[:alert] = @membership.errors.full_messages
      render :index
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @membership = Membership.find(params[:id])
    @membership.destroy
    redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was successfully removed."
  end

  private
  def membership_params
    params.require(:membership).permit(:role, :project_id, :user_id)
  end

  def authenticate
    unless current_user
      session[:return_to] = request.fullpath
      redirect_to '/sign-in'
    end
  end

end
