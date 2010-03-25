$: << File.dirname(__FILE__)
$: << File.dirname(__FILE__) + '/../lib/'

require 'rubygems'
require 'actionpack'
require 'activesupport'
require 'action_controller'
require 'action_controller/test_process'
require 'active_support/vendor'
require 'spec'

require 'routing_filter'
require 'routing_filter/locale'
require 'routing_filter/pagination'

class Site
end

class Section
  def id; 1 end
  alias :to_param :id
  def type; 'Section' end
  def path; 'section' end
end

class Article
  def to_param; 1 end
end

module RoutingFilterHelpers
  def draw_routes(&block)
    set = returning ActionController::Routing::RouteSet.new do |set|
      class << set; def clear!; end; end
      set.draw &block
      silence_warnings{ ActionController::Routing.const_set 'Routes', set }
    end
    set
  end

  def instantiate_controller(params)
    returning ActionController::Base.new do |controller|
      request = ActionController::TestRequest.new
      url = ActionController::UrlRewriter.new(request, params)
      controller.stub!(:request).and_return request
      controller.instance_variable_set :@url, url
      controller
    end
  end

  def should_recognize_path(path, params)
    @set.recognize_path(path, {}).should == params
  end

  def home_path(*args)
    @controller.send :home_path, *args
  end

  def home_url(*args)
    @controller.send :home_url, *args
  end

  def section_path(*args)
    @controller.send :section_path, *args
  end

  def section_article_path(*args)
    @controller.send :section_article_path, *args
  end

  def admin_articles_path(*args)
    @controller.send :admin_articles_path, *args
  end

  def url_for(*args)
    @controller.send :url_for, *args
  end

  def setup_environment(*filters)
    RoutingFilter::Locale.locales = [:en, 'en-US', :de, :fi, 'en-UK']
    RoutingFilter::Locale.include_default_locale = true
    I18n.default_locale = :en
    I18n.locale = :en

    @controller = instantiate_controller :locale => 'de', :id => 1
    @set = draw_routes do |map|
      yield map if block_given?
      filters.each { |filter| map.filter filter }
      map.section 'sections/:id.:format', :controller => 'sections', :action => "show"
      map.section_article 'sections/:section_id/articles/:id', :controller => 'articles', :action => "show"
      map.admin_articles 'admin/articles/:id', :controller => 'admin/articles', :action => "index"
      map.home '/', :controller => 'home', :action => 'index'
    end

    @section_params = {:controller => 'sections', :action => "show", :id => "1"}
    @article_params = {:controller => 'articles', :action => "show", :section_id => "1", :id => "1"}
    @locale_filter = @set.filters.first
    @pagination_filter = @set.filters.last
  end
  
  def with_deactivated_filters(*filters, &block)
    states = filters.inject({}) do |states, filter| 
      states[filter], filter.active = filter.active, false
      states
    end
    yield
    states.each { |filter, state| filter.active = state }
  end
end