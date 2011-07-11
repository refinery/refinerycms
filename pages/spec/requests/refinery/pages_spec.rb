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

  describe 'with marketable urls' do
    it 'shows the homepage' do
      visit '/'
    end

    it 'shows the show page' do
      visit url_for(::Refinery::Page.find('About').url)
    end
  end

end
