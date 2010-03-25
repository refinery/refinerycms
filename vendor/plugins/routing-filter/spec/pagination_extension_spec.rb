require File.dirname(__FILE__) + '/spec_helper.rb'

describe 'RoutingFilter::Pagination' do
  include RoutingFilterHelpers

  before :each do
    setup_environment(:pagination)
  end

  describe 'url generation' do
    it 'appends the segments /pages/:page to the generated path' do
      section_path(1, :page => 2).should == '/sections/1/pages/2'
    end

    it 'appends the segments /pages/:page to the generated path excluding http get params' do
      section_path(1, :page => 2, :foo => 'bar').should == '/sections/1/pages/2?foo=bar'
    end
  end
end
