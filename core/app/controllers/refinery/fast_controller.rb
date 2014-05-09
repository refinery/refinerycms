module Refinery
  class FastController < ActionController::Base

    def message
      render :partial => '/refinery/message', :layout => false
    end

  end
end
