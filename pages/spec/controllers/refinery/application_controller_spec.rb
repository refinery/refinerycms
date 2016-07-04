require "spec_helper"

module Refinery
  describe ApplicationController do
    describe "#load_site" do
      controller do
        def index
          render :nothing => true
        end
      end

      it "sets @site based on request hostname" do
        site1 = create(:site, :hostname => 'site1.com')

        request.host = 'site1.com'

        get :index
        expect(assigns(:site)).to eq site1
      end
    end
  end
end
