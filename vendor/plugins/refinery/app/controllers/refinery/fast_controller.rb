class Refinery::FastController < ActionController::Base

  def wymiframe
    render :template => "/wymiframe", :layout => false
  end

end
