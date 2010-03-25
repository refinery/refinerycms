require File.dirname(__FILE__) + '/spec_helper.rb'

describe 'RoutingFilter::ForceExtension' do
  include RoutingFilterHelpers

  before :each do
    setup_environment(:force_extension)
  end

  describe 'url recognition' do
    it 'recognizes the path /sections/1.html' do
      should_recognize_path '/sections/1.html', @section_params
    end

    it 'recognizes the path /sections/1/articles/1.html' do
      should_recognize_path '/sections/1/articles/1.html', @article_params
    end

    it 'does not recognize the path /sections/1/articles/1.foobar' do
      lambda { @set.recognize_path('/sections/1/articles/1.foobar', {}) }.should raise_error(ActionController::RoutingError)
    end
  end

  describe 'url generation' do
    it 'appends the .html extension to generated paths (section_path)' do
      section_path(:id => 1).should == '/sections/1.html'
    end

    it 'appends the .html extension to generated paths (section_article_path)' do
      section_article_path(:section_id => 1, :id => 1).should == '/sections/1/articles/1.html'
    end

    it 'appends the .html extension to generated paths (admin_articles_path)' do
      admin_articles_path.should == '/admin/articles.html'
    end

    it 'does not replace or add on an existing extension' do
      section_path(:id => 1, :format => 'xml').should == '/sections/1.xml'
    end

    it 'works with url query params' do
      section_path(:id => 1, :foo => 'bar').should == '/sections/1.html?foo=bar'
    end
    
    it 'excludes / by default' do
      home_path.should == '/'
    end
    
    it 'excludes http://test.host/ by default' do
      home_url.should == 'http://test.host/'
    end
    
    it 'excludes with custom regexp' do
      setup_environment { |map| map.filter :force_extension, :exclude => %r(^/(admin|$)) }
      home_path.should == '/'
      admin_articles_path.should == '/admin/articles'
      section_path(:id => 1).should == '/sections/1.html'
    end

    it 'does not exclude / when :exclude => false was passed' do
      setup_environment { |map| map.filter :force_extension, :exclude => false }
      home_path.should == '/.html'
    end
  end
end
