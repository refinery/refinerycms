require 'spec_helper'

describe 'page frontend' do

  before(:all) do
    # Create a refinery user unless we have one.
    Factory.create :refinery_user if ::Refinery::Role[:refinery].users.empty?

    # Delete all pages and their slugs.
    ::Refinery::Page.all.each(&:destroy!)

    # Create some pages for these specs
    ::Refinery::Page.create(:title => 'Home', :link_url => '/')
    ::Refinery::Page.create(:title => 'About')
    ::Refinery::Page.create(:title => 'Draft', :draft => true)
  end

  describe 'when marketable urls are' do
    describe 'enabled' do
      before(:all) do
        ::Refinery::Pages.use_marketable_urls = true
      end

      it 'shows the homepage' do
        pending "this requires a server restart to enable the setting."
        visit '/'
      end

      it 'shows a show page' do
        pending "this requires a server restart to enable the setting."
        visit url_for(::Refinery::Page.find('About').url)
      end
    end

    describe 'disabled' do
      before(:all) do
        ::Refinery::Pages.use_marketable_urls = false
      end

      it 'shows the homepage' do
        visit '/'
      end

      it 'does not route to /about for About page' do
        url_for(::Refinery::Page.find('About').url).should =~ %r{/pages/about$}
      end
    end
  end

end
