require "spec_helper"

module Refinery
  module Admin
    describe PagesController, :focus => true do
      login_refinery_superuser

      describe "#update_positions" do
        it "calls .rebuild! on Refinery::Page" do
          Refinery::Page.should_receive(:rebuild!).once
        
          post :update_positions, :ul => []
        end
      end
    end
  end
end
