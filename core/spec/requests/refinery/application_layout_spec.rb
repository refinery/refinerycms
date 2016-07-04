require 'spec_helper'

module Refinery
  describe 'layout' do
    login_refinery_user

    let(:home_page) do
      FactoryGirl.create :page, :title => 'Home', :link_url => '/'
    end

    describe 'body' do
      it "id is the page's canonical id" do
        visit home_page.url
        page.should have_css 'body#home-page'
      end
    end
  end
end
