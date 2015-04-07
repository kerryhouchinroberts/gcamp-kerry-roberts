class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @task = Task.find(params[:task_id])
    @user = User.find_by_id(current_user.id)
    @comment.task_id = @task.id
    @comment.user_id = @user.id
    if @comment.save
      redirect_to :back
    else
      redirect_to :back
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:comment_body, :user_id, :task_id)
  end
end
