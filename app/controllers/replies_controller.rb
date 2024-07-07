class RepliesController < ApplicationController
  before_action :load_models

  def create
    @comment.replies << Comment.create!(reply_params.merge(user_id: current_user.id))
    redirect_to @apartment
  end


  private

  def comment_params
    params.permit(:comment_id)
  end

  def reply_params
    params.require(:reply).permit(:body)
  end

  def load_models
    @comment = Comment.find(comment_params[:comment_id])
    @apartment = @comment.apartment
  end

end