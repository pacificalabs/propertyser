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
        flash[:error] = "Failed to update categories for property id: #{apartment.id}"
      end
    end

    # Handle case where some apartments are not found
    if apartments.size < params[:apartments].keys.size
      flash[:alert] = 'One or more properties could not be found.'
    end

    redirect_to apartments_path, notice: 'Categories were successfully updated.'
  end


  def new
    @tag = if params[:parent]
      Tag.find(params[:parent])
    else
      Tags.new
    end
  end

  def show
    @tag = Tag.friendly.find(params[:id]) # assuming you use friendly_id for slug
    @child_tags = @tag.child_tags
    @apartments_by_child_tag = @child_tags.each_with_object({}) do |child_tag, hash|
      hash[child_tag.name] = child_tag.apartments
    end
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to  edit_admin_tag_path(@tag), notice: 'Category was successfully created.'
    else
      logger.error @tag.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to admin_tag_path(@tag), notice: 'Category was successfully updated.'
    else
      logger.error @tag.errors.full_messages
      render :edit
    end
  end

  def destroy
    @tag.destroy
    redirect_to admin_tags_url, notice: 'Category was successfully destroyed.'
  end

  private

  def set_tag
    @tag = Tag.friendly.find(params[:id])
  rescue StandardError => e
    redirect_to admin_tags_path
  end

  def tag_params
    params.require(:tag).permit(:name, parent_tag_ids: [])
  end
end
