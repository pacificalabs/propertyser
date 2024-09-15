# app/controllers/admin/tags_controller.rb
class Admin::TagsController < ApplicationController
  before_action :set_tag, only: [:edit, :update, :destroy]

  def assign_tags
    # Use `find` with an array of IDs to handle ActiveRecord::RecordNotFound gracefully
    apartments = Apartment.where(id: params[:apartments].keys)

    # Process each apartment
    apartments.each do |apartment|
      # Get submitted tag_ids for this apartment
      tag_ids = params[:apartments][apartment.id.to_s][:tag_ids].reject(&:blank?)

      # Update the tags
      apartment.tag_ids = tag_ids

      # Save changes and handle errors
      unless apartment.save
        flash[:error] = "Failed to update tags for apartment #{apartment.id}"
      end
    end

    # Handle case where some apartments are not found
    if apartments.size < params[:apartments].keys.size
      flash[:alert] = 'One or more apartments could not be found.'
    end

    redirect_to apartments_path, notice: 'Tags were successfully updated.'
  end


  def new
    @tag = if params[:parent]
      Tag.find(params[:parent])
    else
      current_user.tags.new
    end
  end

  def show
  end

  def create
    @tag = current_user.tags.new(tag_params)
    if @tag.save
      redirect_to  edit_admin_tag_path(@tag), notice: 'Tag was successfully created.'
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
