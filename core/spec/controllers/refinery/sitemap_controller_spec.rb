require 'spec_helper'

module Refinery
  describe SitemapController do
    before (:each) do
      @request.env['HTTP_ACCEPT'] = 'application/xml'
    end

    it "shows a valid xml response" do
      get :index

      response.should be_success
    end
  end
end
