class UsersController < ApplicationController

  before_action :authenticate

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      flash.now[:alert] = @user.errors.full_messages
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to users_path, notice: 'User was successfully edited.'
    else
      flash.now[:alert] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
   if  @user.destroy
    @user.comments.map do |comment|
      comment.user_id = nil
      comment.save
    end
    redirect_to users_path, notice: 'User was successfully destroyed.'
   end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def authenticate
    unless current_user
      session[:return_to] = request.fullpath
      redirect_to '/sign-in'
    end
  end

end
