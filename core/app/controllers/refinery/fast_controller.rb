module Refinery
  class FastController < ActionController::Base

    def wymiframe
      render :template => "/refinery/wymiframe", :layout => false
    end

    def message
      render '/refinery/message', :layout => false
    end

  end
end
