class CommentsController < ApplicationController
  before_action :find_comment, only: [:like]
  before_action :reject_invalid_comments, only: [:create]

  def create
    @comment = @apartment.comments.create!(body: comment_params[:body], user_id: current_user.id)
    redirect_to @apartment
  end

  def delete
    comment = Comment.find(delete_comment_params).destroy!
    apartment = comment.apartment
    redirect_to apartment_path(apartment)
  end

  def like
    if current_user.already_liked_comment?(@comment)
      current_user.unlike @comment
    else
      current_user.like @comment
    end 
    redirect_to apartment_path(@comment.apartment)
  end

  private

  def reject_invalid_comments
    @apartment = Apartment.find(params[:apartment_id])
    redirect_to @apartment if comment_params[:body].blank?
  end

  def find_comment
    @comment = Comment.find(like_params[:like_id]) 
  end

  def like_params
    params.permit(:like_id)
  end

  def comment_params
    params.require(:comment).permit(:body,:apartment_id)
  end

  def delete_comment_params
    params.require(:id) 
  end
end
