module Admin::BaseHelper
  
  def searching?
    !params[:search].blank?
  end
  
end