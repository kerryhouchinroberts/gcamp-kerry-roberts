class MembershipsController < ApplicationController

  layout 'user_layout'

  before_action :authenticate
  before_action :check_membership
  before_action :check_ownership_on_update, only: [:update]
  before_action :check_ownership_on_delete, only:[:destroy]


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
    if ((@project.memberships.where(role: 1).count == 1) && (@membership.role == "owner"))
      redirect_to project_memberships_path(@project)
      flash[:membership_alert] = "Projects must have at least one owner"
    elsif @membership.update(membership_params)
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was successfully updated."
    elsif
      flash.now[:alert] = @membership.errors.full_messages
      render :index
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @membership = Membership.find(params[:id])
    @membership.destroy
    if @membership.user_id == current_user.id
      redirect_to projects_path, notice: "#{@membership.user.full_name} was successfully removed."
    else
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was successfully removed."
    end
  end

  private
  def membership_params
    params.require(:membership).permit(:role, :project_id, :user_id)
  end

  def check_membership
    @project = Project.find(params[:project_id])
    unless
      ((@project.users.include?(User.find_by_id(current_user.id))) || (current_user.admin?))
      flash[:membership_alert] = "You do not have access to that project"
      redirect_to projects_path
    end
  end

  def authenticate
    unless current_user
      session[:return_to] = request.fullpath
      redirect_to '/sign-in'
    end
  end

  def check_ownership_on_delete
    @project = Project.find(params[:project_id])
    @membership = Membership.find(params[:id])
    unless
      (current_user.memberships.where(project_id: @project.id, role: 1).count == 1) || (current_user.admin?) || (@membership.user_id = current_user.id)
      flash[:membership_alert] = "You do not have access"
      redirect_to projects_path
    end
  end

  def check_ownership_on_update
    @project = Project.find(params[:project_id])
    unless
      (current_user.memberships.where(project_id: @project.id, role: 1).count == 1) || (current_user.admin?)
      flash[:membership_alert] = "You do not have access"
      redirect_to projects_path
    end
  end

end
