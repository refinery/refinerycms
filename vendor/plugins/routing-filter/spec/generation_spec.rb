require File.dirname(__FILE__) + '/spec_helper.rb'

describe 'RoutingFilter', 'url generation' do
  include RoutingFilterHelpers

  before :each do
    setup_environment :locale, :pagination

    @site = Site.new
    @section = Section.new
    @article = Article.new
  end

  describe "named route url_helpers" do
    describe "a not nested resource" do
      it 'does not change the section_path when given page option equals 1' do
        section_path(:id => 1, :page => 1).should == '/en/sections/1'
      end

      it 'appends the pages segments to section_path when given page option does not equal 1' do
        section_path(:id => 1, :page => 2).should == '/en/sections/1/pages/2'
      end

      it 'prepends the current locale to section_path' do
        I18n.locale = :de
        section_path(:id => 1).should == '/de/sections/1'
      end

      it 'prepends a given locale param to section_path' do
        I18n.locale = :de
        section_path(:id => 1, :locale => :fi).should == '/fi/sections/1'
      end

      it 'does not prepend a locale to section_path if given locale is false' do
        section_path(:id => 1, :locale => false).should == '/sections/1'
      end

      it 'works on section_path with both a locale and page option' do
        section_path(:id => 1, :locale => :fi, :page => 2).should == '/fi/sections/1/pages/2'
      end

      it 'should not prepend an invalid locale to section_path' do
        section_path(:id => 1, :locale => :aa).should == '/sections/1'
      end

      it 'should prepend a longer locale to section_path' do
        section_path(:id => 1, :locale => 'en-US').should == '/en-US/sections/1'
      end

      it 'should not prepend the default locale when configured not to' do
        RoutingFilter::Locale.include_default_locale = false
        section_path(:id => 1, :locale => :en).should == '/sections/1'
      end
    end

    describe "a nested resource" do
      it 'does not change the section_article_path when given page option equals 1' do
        section_article_path(:section_id => 1, :id => 1, :page => 1).should == '/en/sections/1/articles/1'
      end

      it 'appends the pages segments to section_article_path when given page option does not equal 1' do
        section_article_path(:section_id => 1, :id => 1, :page => 2).should == '/en/sections/1/articles/1/pages/2'
      end

      it 'prepends the current locale to section_article_path' do
        I18n.locale = :de
        section_article_path(:section_id => 1, :id => 1).should == '/de/sections/1/articles/1'
      end

      it 'prepends a given locale param to section_article_path' do
        I18n.locale = :de
        section_article_path(:section_id => 1, :id => 1, :locale => :fi).should == '/fi/sections/1/articles/1'
      end

      it 'does not prepend a locale to section_article_path if given locale is false' do
        section_article_path(:section_id => 1, :id => 1, :locale => false).should == '/sections/1/articles/1'
      end

      it 'works on section_article_path with both a locale and page option' do
        section_article_path(:section_id => 1, :id => 1, :locale => :fi, :page => 2).should == '/fi/sections/1/articles/1/pages/2'
      end

      it 'should not prepend an invalid locale to section_article_path' do
        section_article_path(:section_id => 1, :id => 1, :locale => :aa).should == '/sections/1/articles/1'
      end

      it 'should prepend a longer locale to section_article_path' do
        section_article_path(:section_id => 1, :id => 1, :locale => 'en-US').should == '/en-US/sections/1/articles/1'
      end

      it 'should not prepend the default locale when configured not to' do
        RoutingFilter::Locale.include_default_locale = false
        section_article_path(:section_id => 1, :id => 1, :locale => :en).should == '/sections/1/articles/1'
      end
    end
  end

  describe 'when used with named route url_helper with "optimized" generation blocks' do
    describe "a not nested resource" do
      it 'does not change the section_path when given page option equals 1' do
        section_path(1, :page => 1).should == '/en/sections/1'
      end

      it 'appends the pages segments to section_path when given page option does not equal 1' do
        section_path(1, :page => 2).should == '/en/sections/1/pages/2'
      end

      it 'prepends the current locale to section_path' do
        I18n.locale = :de
        section_path(1).should == '/de/sections/1'
      end

      it 'prepends a given locale param to section_path' do
        I18n.locale = :de
        section_path(1, :locale => :fi).should == '/fi/sections/1'
      end

      it 'does not prepend a locale to section_path if given locale is false' do
        section_path(1, :locale => false).should == '/sections/1'
      end

      it 'works for section_path with both a locale and page option' do
        section_path(1, :locale => :fi, :page => 2).should == '/fi/sections/1/pages/2'
      end

      it 'should not prepend an invalid locale to section_path' do
        section_path(1, :locale => :aa).should == '/sections/1'
      end

      it 'should prepend a longer locale to section_path' do
        section_path(1, :locale => 'en-US').should == '/en-US/sections/1'
      end

      it 'should not prepend the default locale when configured not to' do
        RoutingFilter::Locale.include_default_locale = false
        section_path(1, :locale => :en).should == '/sections/1'
      end
    end

    describe "a nested resource" do
      it 'does not change the section_article_path when given page option equals 1' do
        section_article_path(1, 1, :page => 1).should == '/en/sections/1/articles/1'
      end

      it 'appends the pages segments to section_article_path when given page option does not equal 1' do
        section_article_path(1, 1, :page => 2).should == '/en/sections/1/articles/1/pages/2'
      end

      it 'prepends the current locale to section_article_path' do
        I18n.locale = :de
        section_article_path(1, 1).should == '/de/sections/1/articles/1'
      end

      it 'prepends a given locale param to section_article_path' do
        I18n.locale = :de
        section_article_path(1, 1, :locale => :fi).should == '/fi/sections/1/articles/1'
      end

      it 'does not prepend a locale to section_article_path if given locale is false' do
        section_article_path(1, 1, :locale => false).should == '/sections/1/articles/1'
      end

      it 'works for section_article_path with both a locale and page option' do
        section_article_path(1, 1, :locale => :fi, :page => 2).should == '/fi/sections/1/articles/1/pages/2'
      end

      it 'should not prepend an invalid locale to section_article_path' do
        section_article_path(1, 1, :locale => :aa).should == '/sections/1/articles/1'
      end

      it 'should prepend a longer locale to section_article_path' do
        section_article_path(1, 1, :locale => 'en-US').should == '/en-US/sections/1/articles/1'
      end

      it 'should not prepend the default locale when configured not to' do
        RoutingFilter::Locale.include_default_locale = false
        section_article_path(1, 1, :locale => :en).should == '/sections/1/articles/1'
      end
    end
  end

  describe 'when used with a polymorphic_path' do
    describe "a not nested resource" do
      it 'does not change the section_path when given page option equals 1' do
        section_path(@section, :page => 1).should == '/en/sections/1'
      end

      it 'appends the pages segments to section_path when given page option does not equal 1' do
        section_path(@section, :page => 2).should == '/en/sections/1/pages/2'
      end

      it 'prepends the current locale to section_path' do
        I18n.locale = :de
        section_path(@section).should == '/de/sections/1'
      end

      it 'prepends a given locale param to section_path' do
        I18n.locale = :de
        section_path(@section, :locale => :fi).should == '/fi/sections/1'
      end

      it 'does not prepend a locale to section_path if given locale is false' do
        section_path(@section, :locale => false).should == '/sections/1'
      end

      it 'works for section_path with both a locale and page option' do
        section_path(@section, :locale => :fi, :page => 2).should == '/fi/sections/1/pages/2'
      end

      it 'should not prepend an invalid locale to section_path' do
        section_path(@section, :locale => :aa).should == '/sections/1'
      end

      it 'should prepend a longer locale to section_path' do
        section_path(@section, :locale => 'en-US').should == '/en-US/sections/1'
      end

      it 'should not prepend the default locale when configured not to' do
        RoutingFilter::Locale.include_default_locale = false
        section_path(@section, :locale => :en).should == '/sections/1'
      end
    end

    describe "a nested resource" do
      it 'does not change the section_article_path when given page option equals 1' do
        section_article_path(@section, @article, :page => 1).should == '/en/sections/1/articles/1'
      end

      it 'appends the pages segments to section_article_path when given page option does not equal 1' do
        section_article_path(@section, @article, :page => 2).should == '/en/sections/1/articles/1/pages/2'
      end

      it 'prepends the current locale to section_article_path' do
        I18n.locale = :de
        section_article_path(@section, @article).should == '/de/sections/1/articles/1'
      end

      it 'prepends a given locale param to section_article_path' do
        I18n.locale = :de
        section_article_path(@section, @article, :locale => :fi).should == '/fi/sections/1/articles/1'
      end

      it 'does not prepend a locale to section_article_path if given locale is false' do
        section_article_path(@section, @article, :locale => false).should == '/sections/1/articles/1'
      end

      it 'works for section_article_path with both a locale and page option' do
        section_article_path(@section, @article, :locale => :fi, :page => 2).should == '/fi/sections/1/articles/1/pages/2'
      end

      it 'should not prepend an invalid locale to section_article_path' do
        section_article_path(@section, @article, :locale => :aa).should == '/sections/1/articles/1'
      end

      it 'should prepend a longer locale to section_article_path' do
        section_article_path(@section, @article, :locale => 'en-US').should == '/en-US/sections/1/articles/1'
      end

      it 'should not prepend the default locale when configured not to' do
        RoutingFilter::Locale.include_default_locale = false
        section_article_path(@section, @article, :locale => :en).should == '/sections/1/articles/1'
      end
    end
  end

  describe 'when used with url_for and an ActivRecord instance' do
    describe "a not nested resource" do
      it 'does not change the url_for result when given page option equals 1' do
        params = @section_params.update :id => @section, :page => 1
        url_for(params).should == 'http://test.host/en/sections/1'
      end

      it 'appends the pages segments to url_for result when given page option does not equal 1' do
        params = @section_params.update :id => @section, :page => 2
        url_for(params).should == 'http://test.host/en/sections/1/pages/2'
      end

      it 'prepends the current locale to url_for result' do
        I18n.locale = :de
        params = @section_params.update :id => @section
        url_for(params).should == 'http://test.host/de/sections/1'
      end

      it 'prepends a given locale param url_for result' do
        I18n.locale = :de
        params = @section_params.update :id => @section, :locale => :fi
        url_for(params).should == 'http://test.host/fi/sections/1'
      end

      it 'does not prepend a locale to url_for result if given locale is false' do
        params = @section_params.update :id => @section, :locale => false
        url_for(params).should == 'http://test.host/sections/1'
      end

      it 'works for url_for result with both a locale and page option' do
        params = @section_params.update :id => @section, :locale => :fi, :page => 2
        url_for(params).should == 'http://test.host/fi/sections/1/pages/2'
      end

      it 'should not prepend an invalid locale to section_path' do
        params = @section_params.update :id => @section, :locale => :aa
        url_for(params).should == 'http://test.host/sections/1'
      end

      it 'should prepend a longer locale to section_path' do
        params = @section_params.update :id => @section, :locale => 'en-US'
        url_for(params).should == 'http://test.host/en-US/sections/1'
      end

      it 'should not prepend the default locale when configured not to' do
        RoutingFilter::Locale.include_default_locale = false
        params = @section_params.update :id => @section, :locale => :en
        url_for(params).should == 'http://test.host/sections/1'
      end
    end

    describe "a nested resource" do
      it 'does not change the url_for result when given page option equals 1' do
        params = @article_params.update :section_id => @section, :id => @article, :page => 1
        url_for(params).should == 'http://test.host/en/sections/1/articles/1'
      end

      it 'appends the pages segments to url_for result when given page option does not equal 1' do
        params = @article_params.update :section_id => @section, :id => @article, :page => 2
        url_for(params).should == 'http://test.host/en/sections/1/articles/1/pages/2'
      end

      it 'prepends the current locale to url_for result' do
        I18n.locale = :de
        params = @article_params.update :section_id => @section, :id => @article
        url_for(params).should == 'http://test.host/de/sections/1/articles/1'
      end

      it 'prepends a given locale param to url_for result' do
        I18n.locale = :de
        params = @article_params.update :section_id => @section, :id => @article, :locale => :fi
        url_for(params).should == 'http://test.host/fi/sections/1/articles/1'
      end

      it 'does not prepend a locale to url_for result if given locale is false' do
        params = @article_params.update :section_id => @section, :id => @article, :locale => false
        url_for(params).should == 'http://test.host/sections/1/articles/1'
      end

      it 'works for url_for result with both a locale and page option' do
        params = @article_params.update :section_id => @section, :id => @article, :locale => :fi, :page => 2
        url_for(params).should == 'http://test.host/fi/sections/1/articles/1/pages/2'
      end

      it 'should not prepend an invalid locale to url_for result' do
        params = @article_params.update :section_id => @section, :id => @article, :locale => :aa
        url_for(params).should == 'http://test.host/sections/1/articles/1'
      end

      it 'should prepend a longer locale to section_article_path' do
        params = @article_params.update :section_id => @section, :id => @article, :locale => 'en-US'
        url_for(params).should == 'http://test.host/en-US/sections/1/articles/1'
      end

      it 'should not prepend the default locale when configured not to' do
        RoutingFilter::Locale.include_default_locale = false
        params = @article_params.update :section_id => @section, :id => @article, :locale => :en
        url_for(params).should == 'http://test.host/sections/1/articles/1'
      end
    end
  end
end