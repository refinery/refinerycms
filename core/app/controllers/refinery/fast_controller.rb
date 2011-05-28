module ::Refinery
  class FastController < ActionController::Base

    def wymiframe
      render :template => "/wymiframe", :layout => false
    end

  end
end
