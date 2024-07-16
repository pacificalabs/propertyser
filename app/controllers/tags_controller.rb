# app/controllers/tags_controller.rb
class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :related_show]

  def index
    @tags = current_user.tags
  end

  def show
    @apartments = @tag.apartments
    @child_tags = @tag.child_tags
  end

  def related_show
    @related_tag = Tag.friendly.find(params[:slug])
    @parent_tag = @related_tag.parent_tags.find_by(slug: params[:tag_id])
    # Add logic to handle what you want to show for the related tag
  end

  private

  def set_tag
    @tag = Tag.friendly.find(params[:slug] || params[:id])
  end

  def slug_candidates
    [:name]
  end

  def generate_slug
    self.slug = name.parameterize if name.present?
  end

  def format_name
    self.name = name.titleize if name.present?
  end
end
