class TasksController < ApplicationController

  layout 'user_layout'
  
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_project
  before_action :authenticate
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @comments = Comment.all
    @comment = Comment.new
    @task = Task.find(params[:id])
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.project_id = @project.id
    if @task.save
      redirect_to project_tasks_path(@project), notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    if @task.update(task_params)
      redirect_to project_tasks_path(@project), notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
      redirect_to project_tasks_path(@project), notice: 'Task was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:description, :due_date, :completed)
    end

    def authenticate
      unless current_user
        session[:return_to] = request.fullpath
        redirect_to '/sign-in'
      end
    end

end
