module ::Refinery
  class FastController < ActionController::Base

    def wymiframe
      render :template => "/refinery/wymiframe", :layout => false
    end

  end
end
