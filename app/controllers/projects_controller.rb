class ProjectsController < ApplicationController

  layout 'user_layout'

  before_action :authenticate
  before_action :check_membership, only: [:show, :edit, :update, :destroy]
  before_action :check_ownership, only: [:edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      Membership.create(role: 1, user_id: current_user.id, project_id: @project.id)
      redirect_to project_tasks_path(@project), notice: 'Project was successfully created.'
    else
      flash.now[:alert] = @project.errors.full_messages
      render :new
    end
  end

  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(project_params)
      redirect_to project_path(@project), notice: 'Project was successfully updated.'
    else
      flash.now[:alert] = @project.errors.full_messages
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.destroy
      redirect_to projects_path, notice: 'Project was successfully destroyed.'
    end
  end

  private
  def project_params
    params.require(:project).permit(:name)
  end

  def check_membership
    @project = Project.find(params[:id])
    unless
      ((@project.users.include?(User.find_by_id(current_user.id))) || (current_user.admin?))
      flash[:membership_alert] = "You do not have access to that project"
      redirect_to projects_path
    end
  end

  def check_ownership
    @project = Project.find(params[:id])
    unless
      current_user.memberships.where(project_id: @project.id, role: 1).count == 1 || current_user.admin?
      flash[:membership_alert] = "You do not have access"
      redirect_to projects_path
    end
  end

  def authenticate
    unless current_user
      session[:return_to] = request.fullpath
      redirect_to '/sign-in'
    end
  end

end
