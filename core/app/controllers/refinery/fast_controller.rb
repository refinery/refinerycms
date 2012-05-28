module Refinery
  class FastController < ActionController::Base

    def wymiframe
      render :template => "/refinery/wymiframe", :layout => false
    end

    def message
      render :partial => '/refinery/message', :layout => false
    end

  end
end
