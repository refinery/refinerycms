require 'spec_helper'

module Refinery
  describe 'layout', :type => :feature do
    refinery_login

    let(:home_page) do
      FactoryGirl.create :page, :title => 'Home', :link_url => '/'
    end

    describe 'body' do
      it "id is the page's canonical id" do
        skip "GLASS: TODO - I think we probably want to put this back in"
        visit home_page.url

        expect(page).to have_css 'body#home-page'
      end
    end
  end
end
