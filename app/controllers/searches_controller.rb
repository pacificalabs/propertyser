class SearchesController < ApplicationController

  def delete
    Search.find(delete_params[:id]).destroy!
    redirect_to search_path
  end

  private
  def delete_params
    params.permit(:id)
  end
end
