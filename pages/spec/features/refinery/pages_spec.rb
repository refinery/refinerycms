# encoding: utf-8
require 'spec_helper'

module Refinery
  describe 'page frontend' do
    let(:home_page) { Page.create :title => 'Home', :link_url => '/' }
    let(:about_page) { Page.create :title => 'About' }
    let(:draft_page) { Page.create :title => 'Draft', :draft => true }
    before do
      # Stub the menu pages we're expecting
      Page.stub(:fast_menu).and_return([home_page, about_page])
    end

    def standard_page_menu_items_exist?
      within('.menu') do
        page.should have_content(home_page.title)
        page.should have_content(about_page.title)
        page.should_not have_content(draft_page.title)
      end
    end

    describe 'when marketable urls are' do
      describe 'enabled' do
        before { Pages.stub(:marketable_urls).and_return(true) }

        it 'shows the homepage' do
          PagesController.any_instance.stub(:find_page).and_return(:home_page)
          visit '/'

          standard_page_menu_items_exist?
        end

        it 'shows a show page' do
          PagesController.any_instance.stub(:find_page).and_return(:about_page)
          visit refinery.page_path(about_page)

          standard_page_menu_items_exist?
        end
      end

      describe 'disabled' do
        before { Pages.stub(:marketable_urls).and_return(false) }

        it 'shows the homepage' do
          PagesController.any_instance.stub(:find_page).and_return(:home_page)
          visit '/'

          standard_page_menu_items_exist?
        end

        it 'does not route to /about for About page' do
          refinery.page_path(about_page).should =~ %r{/pages/about$}
        end

        it 'shows the about page' do
          PagesController.any_instance.stub(:find_page).and_return(:about_page)
          visit refinery.page_path(about_page)

          standard_page_menu_items_exist?
        end
      end
    end

    describe 'title set (without menu title or browser title)' do
      before { visit '/about' }

      it "shows title at the top of the page" do
        find("#body_content_title").text.should == about_page.title
      end

      it "should hide title when config is set" do
        Pages.stub(:show_title_in_body).and_return(false)
        visit '/about'
        page.should_not have_selector("#body_content_title")
      end

      it "uses title in the menu" do
        find(".selected").text.strip.should == about_page.title
      end

      it "uses title in browser title" do
        page.has_title?(about_page.title)
      end
    end

    describe 'when menu_title is' do
      let(:page_mt) { Page.create :title => 'Company News' }

      before do
        Page.stub(:fast_menu).and_return([page_mt])
      end

      describe 'set' do
        before do
          page_mt.menu_title = "News"
          page_mt.save
        end

        it 'shows the menu_title in the menu' do
          visit '/news'

          find(".selected").text.strip.should == page_mt.menu_title
        end

        it "does not effect browser title and page title" do
          visit "/news"

          page.has_title?(page_mt.title)
          find("#body_content_title").text.should == page_mt.title
        end
      end

      describe 'set and then unset' do
        before do
          page_mt.menu_title = "News"
          page_mt.save
          page_mt.menu_title = ""
          page_mt.save
        end

        it 'the friendly_id and menu are reverted to match the title' do
          visit '/company-news'

          current_path.should == '/company-news'
          find(".selected").text.strip.should == page_mt.title
        end
      end
    end

    describe 'when browser_title is set' do
      let(:page_bt) {
        Page.create :title => 'About Us', :browser_title => 'About Our Company'
      }
      before do
        Page.stub(:fast_menu).and_return([page_bt])
      end
      it 'should have the browser_title in the title tag' do
        visit '/about-us'

        page.has_title?(page_bt.title)
      end

      it 'should not effect page title and menu title' do
        visit '/about-us'

        find("#body_content_title").text.should == page_bt.title
        find(".selected").text.strip.should == page_bt.title
      end
    end

    describe 'custom_slug' do
      let(:page_cs) { Page.create :title => 'About Us' }
      before do
        Page.stub(:fast_menu).and_return([page_cs])
      end

      describe 'not set' do
        it 'makes friendly_id from title' do
          visit '/about-us'

          current_path.should == '/about-us'
        end
      end

      describe 'set' do
        before do
          page_cs.custom_slug = "about-custom"
          page_cs.save
        end

        it 'should make and use a new friendly_id' do
          visit '/about-custom'

          current_path.should == '/about-custom'
        end
      end

      describe 'set and unset' do
        before do
          page_cs.custom_slug = "about-custom"
          page_cs.save
          page_cs.custom_slug = ""
          page_cs.save
          page_cs.reload
        end
      end

      describe 'set with slashes' do
        before do
          Pages.stub(:scope_slug_by_parent).and_return(false)
          page_cs.custom_slug = "products/my product/cool one!"
          page_cs.save
        end

        after do
          Pages.stub(:scope_slug_by_parent).and_return(true)
        end

        it 'should make and use a new friendly_id' do
          visit '/products/my-product/cool-one'
          current_path.should == '/products/my-product/cool-one'
        end
      end
    end

    # Following specs are converted from one of the cucumber features.
    # Maybe we should clean up this spec file a bit...
    describe "home page" do
      it "succeeds" do
        visit "/"

        within ".selected" do
          page.should have_content(home_page.title)
        end
        page.should have_content(about_page.title)
      end
    end

    describe "content page" do
      it "succeeds" do
        visit "/about"

        page.should have_content(home_page.title)
        within ".selected > a" do
          page.should have_content(about_page.title)
        end
      end
    end

    describe "submenu page" do
      let(:submenu_page) { about_page.children.create :title => 'Sample Submenu' }

      before do
        Page.stub(:fast_menu).and_return(
          [home_page, submenu_page, about_page.reload].sort_by(&:lft)
        )
      end

      it "succeeds" do
        visit refinery.url_for(submenu_page.url)
        page.should have_content(home_page.title)
        page.should have_content(about_page.title)
        within ".selected * > .selected a" do
          page.should have_content(submenu_page.title)
        end
      end
    end

    describe "special characters title" do
      let(:special_page) { Page.create :title => 'ä ö ü spéciål chåråctÉrs' }
      before do
        Page.stub(:fast_menu).and_return(
          [home_page, about_page, special_page]
        )
      end

      it "succeeds" do
        visit refinery.url_for(special_page.url)

        page.should have_content(home_page.title)
        page.should have_content(about_page.title)
        within ".selected > a" do
          page.should have_content(special_page.title)
        end
      end
    end

    describe "special characters title as submenu page" do
      let(:special_page) {
        about_page.children.create :title => 'ä ö ü spéciål chåråctÉrs'
      }

      before do
        Page.stub(:fast_menu).and_return(
          [home_page, special_page, about_page.reload].sort_by &:lft
        )
      end

      it "succeeds" do
        visit refinery.url_for(special_page.url)

        page.should have_content(home_page.title)
        page.should have_content(about_page.title)
        within ".selected * > .selected a" do
          page.should have_content(special_page.title)
        end
      end
    end

    describe "hidden page" do
      let(:hidden_page) { Page.create :title => "Hidden", :show_in_menu => false }

      before do
        Page.stub(:fast_menu).and_return([home_page, about_page])
      end

      it "succeeds" do
        visit refinery.page_path(hidden_page)

        page.should have_content(home_page.title)
        page.should have_content(about_page.title)
        page.should have_content(hidden_page.title)
        within "nav" do
          page.should have_no_content(hidden_page.title)
        end
      end
    end

    describe "skip to first child" do
      let!(:child_page) { about_page.children.create :title => "Child Page" }
      before do
       about = about_page.reload
       about.skip_to_first_child = true
       about.save!

       Page.stub(:fast_menu).and_return([home_page, about, child_page].sort_by(&:lft))
      end

      it "succeeds" do
        visit "/about"

        within ".selected * > .selected a" do
          page.should have_content(child_page.title)
        end
      end
    end

    context "with multiple locales" do

      describe "redirects" do
        before { Refinery::I18n.stub(:frontend_locales).and_return([:en, :ru]) }
        after { Refinery::I18n.unstub(:frontend_locales) }
        let(:en_page_title) { 'News' }
        let(:en_page_slug) { 'news' }
        let(:ru_page_title) { 'Новости' }
        let(:ru_page_slug_encoded) { '%D0%BD%D0%BE%D0%B2%D0%BE%D1%81%D1%82%D0%B8' }
        let!(:news_page) do
          _page = Globalize.with_locale(:en) {
            Page.create :title => en_page_title
          }
          Globalize.with_locale(:ru) do
            _page.title = ru_page_title
            _page.save
          end

          _page
        end

        it "should recognise when default locale is in the path" do
          visit "/en/#{en_page_slug}"

          current_path.should == "/en/#{en_page_slug}"
        end

        it "should redirect to default locale slug" do
          visit "/#{ru_page_slug_encoded}"

          current_path.should == "/#{en_page_slug}"
        end

        it "should redirect to second locale slug" do
          visit "/ru/#{en_page_slug}"

          current_path.should == "/ru/#{ru_page_slug_encoded}"

          visit "/en/#{en_page_slug}"
        end

        describe "nested page" do
          let(:nested_page_title) { '2012' }
          let(:nested_page_slug) { '2012' }

          let!(:nested_page) do
            _page = Globalize.with_locale(:en) {
              news_page.children.create :title => nested_page_title
            }

            Globalize.with_locale(:ru) do
              _page.title = nested_page_title
              _page.save
            end

            _page
          end

          it "should redirect to localized url" do
            visit "/ru/#{en_page_slug}/#{nested_page_slug}"

            current_path.should == "/ru/#{ru_page_slug_encoded}/#{nested_page_slug}"

            visit "/en/#{en_page_slug}/#{nested_page_slug}"
          end
        end
      end
    end

  end
end
