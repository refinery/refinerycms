require File.dirname(__FILE__) + '/spec_helper.rb'

describe 'RoutingFilter' do
  include RoutingFilterHelpers

  before :each do
    setup_environment :locale, :pagination
  end

  def recognize_path(path = '/de/sections/1', options = {})
    @set.recognize_path(path, options)
  end

  it 'installs filters to the route set' do
    @locale_filter.should be_instance_of(RoutingFilter::Locale)
    @pagination_filter.should be_instance_of(RoutingFilter::Pagination)
  end

  it 'calls the first filter for route recognition' do
    @locale_filter.should_receive(:around_recognize).and_return :foo => :bar
    recognize_path.should == { :foo => :bar }
  end

  it 'calls the second filter for route recognition' do
    @pagination_filter.should_receive(:around_recognize).and_return :foo => :bar
    recognize_path.should == { :foo => :bar, :locale => 'de' }
  end

  it 'calls the first filter for url generation' do
    @locale_filter.should_receive(:around_generate).and_return '/en/sections/1?page=2'
    url_for(:controller => 'sections', :action => 'show', :section_id => 1)
  end

  it 'calls the second filter for url generation' do
    @pagination_filter.should_receive(:around_generate).and_return '/sections/1?page=2'
    url_for(:controller => 'sections', :action => 'show', :section_id => 1)
  end

  it 'calls the first filter for named route url_helper' do
    @locale_filter.should_receive(:around_generate).and_return '/en/sections/1'
    section_path(:section_id => 1)
  end

  it 'calls the filter for named route url_helper with "optimized" generation blocks' do
    # at_least(1) since the inline code comments in ActionController::Routing::RouteSet::NamedRouteCollection#define_url_helper also call us (as of http://github.com/rails/rails/commit/a2270ef2594b97891994848138614657363f2806)
    @locale_filter.should_receive(:around_generate).at_least(1).and_return '/en/sections/1'
    section_path(1)
  end

  it 'calls the filter for named route polymorphic_path' do
    # at_least(1) since the inline code comments in ActionController::Routing::RouteSet::NamedRouteCollection#define_url_helper also call us (as of http://github.com/rails/rails/commit/a2270ef2594b97891994848138614657363f2806)
    @locale_filter.should_receive(:around_generate).at_least(1).and_return '/en/sections/1'
    section_path(Section.new)
  end

  # When filters are set up in the order:
  #
  #   map.filter :locale
  #   map.filter :pagination
  #
  # Then #around_recognize should be first called on the locale filter and then
  # on the pagination filter. Whereas #around_generate should be first called
  # on the pagination filter and then on the locale filter. Right?

  it 'calls #around_recognize in the expected order' do
    params = { :id => "1", :page => 2, :controller => "sections", :action => "show" }
    @pagination_filter.stub!(:around_recognize).and_return({ :page => 2, :controller => "sections", :action => "show" })

    recognize_path('/de/sections/1/pages/2')[:locale].should == "de"
    recognize_path('/de/sections/1/pages/2')[:page].should == 2
  end

  it 'calls #around_generate in the expected order' do
    @locale_filter.stub!(:around_generate).and_return('de/sections/1')
    section_path(1, :page => 2).should == "de/sections/1/pages/2"
  end

  it 'does not call deactivated filters' do
    with_deactivated_filters(RoutingFilter::Locale) do
      @locale_filter.should_not_receive(:around_generate)
      section_path(Section.new)
    end
  end

  it 'still calls successors of deactivated filters' do
    with_deactivated_filters(RoutingFilter::Locale) do
      @pagination_filter.should_receive(:around_recognize).and_return :foo => :bar
      recognize_path('/sections/1').should == { :foo => :bar }
    end
  end

  # chain

  it 'adds filters in the order they are registered' do
    @set.filters[0].should == @locale_filter
    @set.filters[1].should == @pagination_filter
  end

  it 'returns the previous filter as a predecessor of a filter' do
    @set.filters.predecessor(@pagination_filter).should == @locale_filter
  end

  it 'returns the nil as a predecessor of the first filter' do
    @set.filters.successor(@pagination_filter).should be_nil
  end

  it 'returns the next filter as a successor of a filter' do
    @set.filters.successor(@locale_filter).should == @pagination_filter
  end

  it 'returns the nil as a successor of the last filter' do
    @set.filters.successor(@pagination_filter).should be_nil
  end
end