class AdminController < ApplicationController

  skip_before_action :user_is_authorised?, only: :contact_team

  def index
    @apartments = Apartment.includes(:user).un_archived.order(approved: :ASC)
  end

  def owner
    @apartments = Apartment.where(user_id: params[:user_id]).order(approved: :DESC)
    render "index"
  end

  def approve
    @apartment = Apartment.find_by_id(approval_params[:id])
    @apartment.approve
    redirect_to admin_path
  end

  def revoke
    @apartment = Apartment.find_by_id(approval_params[:id])
    @apartment.revoke_approval
    redirect_to admin_path
  end

  def approval_params
    params.permit(:id)
  end

  def delete
    Apartment.find(params[:id]).destroy!
    redirect_to admin_path
    flash[:alert] = "PROPERTY WAS DELETED!"
  end

  def archive
    @apartment = Apartment.find_by_id(approval_params[:id])
    @apartment.archive
    redirect_to admin_path
    flash[:alert] = "PROPERTY WAS ARCHIVED!"
  end

  def unarchive
    @apartment = Apartment.find_by_id(approval_params[:id])
    @apartment.unarchive
    redirect_to archival_path
    flash[:alert] = "PROPERTY WAS UNARCHIVED!"
  end

  def archival
    @apartments = Apartment.archived
  end

  def contact_team
    notify_admin_team 'contact_form', contact_form_params.to_h.merge(location_info: request.location.data)
  end

  private

  def contact_form_params
    params.permit(:firstname,:phone,:email,:subject,:message_body)
  end

end
