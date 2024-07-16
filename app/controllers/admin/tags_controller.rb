# app/controllers/admin/tags_controller.rb
class Admin::TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def new
    @tag = current_user.tags.new
  end

  def show
  end

  def create
    @tag = current_user.tags.new(tag_params)
    if @tag.save
      redirect_to admin_tag_path(@tag), notice: 'Tag was successfully created.'
    else
      logger.error @tag.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to admin_tag_path(@tag), notice: 'Tag was successfully updated.'
    else
      logger.error @tag.errors.full_messages
      render :edit
    end
  end

  def destroy
    @tag.destroy
    redirect_to admin_tags_url, notice: 'Tag was successfully destroyed.'
  end

  private

  def set_tag
    @tag = current_user.tags.friendly.find(params[:id])
  rescue StandardError => e
    redirect_to admin_tags_path
  end

  def tag_params
    params.require(:tag).permit(:name, parent_tag_ids: [])
  end
end
