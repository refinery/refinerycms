require 'spec_helper'

module Refinery
  describe 'layout', :type => :system do
    refinery_login

    let(:home_page) do
      FactoryBot.create :page, :title => 'Home', :link_url => '/'
    end

    describe 'body' do
      it "has an id that includes the page's canonical name" do
        visit home_page.url
        expect(page.find("body")[:id]).to eq "home-page"
      end
    end
  end
end
