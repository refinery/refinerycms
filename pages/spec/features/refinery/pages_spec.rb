# encoding: utf-8
require 'spec_helper'

module Refinery
  describe 'page frontend', :type => :feature do
    let(:home_page) { Page.create :title => 'Home', :link_url => '/' }
    let(:about_page) { Page.create :title => 'About' }
    let(:draft_page) { Page.create :title => 'Draft', :draft => true }
    before do
      # Stub the menu pages we're expecting
      ::I18n.default_locale = Mobility.locale = :en
      allow(Page).to receive(:fast_menu).and_return([home_page, about_page])
    end

    def standard_page_menu_items_exist?
      within('.menu') do
        expect(page).to have_content(home_page.title)
        expect(page).to have_content(about_page.title)
        expect(page).not_to have_content(draft_page.title)
      end
    end

    describe 'when marketable urls are' do
      describe 'enabled' do
        before { allow(Pages).to receive(:marketable_urls).and_return(true) }

        it 'shows the homepage' do
          allow_any_instance_of(PagesController).to receive(:find_page).and_return(:home_page)
          visit '/'

          standard_page_menu_items_exist?
        end

        it 'shows a show page' do
          allow_any_instance_of(PagesController).to receive(:find_page).and_return(:about_page)
          visit refinery.page_path(about_page)

          standard_page_menu_items_exist?
        end
      end

      describe 'disabled' do
        before { allow(Pages).to receive(:marketable_urls).and_return(false) }

        it 'shows the homepage' do
          allow_any_instance_of(PagesController).to receive(:find_page).and_return(:home_page)
          visit '/'

          standard_page_menu_items_exist?
        end

        it 'does not route to /about for About page' do
          expect(refinery.page_path(about_page)).to match(%r{/pages/about$})
        end

        it 'shows the about page' do
          allow_any_instance_of(PagesController).to receive(:find_page).and_return(:about_page)
          visit refinery.page_path(about_page)

          standard_page_menu_items_exist?
        end
      end
    end

    describe 'title set (without menu title or browser title)' do
      before { visit '/about' }

      it "shows title at the top of the page" do
        expect(find("#body_content_title").text).to eq(about_page.title)
      end

      it "should hide title when config is set" do
        allow(Pages).to receive(:show_title_in_body).and_return(false)
        visit '/about'
        expect(page).not_to have_selector("#body_content_title")
      end

      it "uses title in the menu" do
        expect(find(".selected").text.strip).to eq(about_page.title)
      end

      it "uses title in browser title" do
        page.has_title?(about_page.title)
      end
    end

    describe 'when menu_title is' do
      let(:page_mt) { Page.create :title => 'Company News' }

      before do
        allow(Page).to receive(:fast_menu).and_return([page_mt])
      end

      describe 'set' do
        before do
          page_mt.menu_title = "News"
          page_mt.save
        end

        it 'shows the menu_title in the menu' do
          visit refinery.url_for(page_mt.url)

          within ".selected" do
            expect(page).to have_content(page_mt.menu_title)
          end
        end

        it "does not affect browser title and page title" do
          visit refinery.url_for(page_mt.url)

          expect(page).to have_title(page_mt.title)
          expect(find("#body_content_title").text).to eq(page_mt.title)
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

          expect(current_path).to eq('/company-news')
          expect(find(".selected").text.strip).to eq(page_mt.title)
        end
      end
    end

    describe 'when browser_title is set' do
      let(:page_bt) {
        Page.create :title => 'About Us', :browser_title => 'About Our Company'
      }
      before do
        allow(Page).to receive(:fast_menu).and_return([page_bt])
      end
      it 'should have the browser_title in the title tag' do
        visit '/about-us'

        page.has_title?(page_bt.title)
      end

      it 'should not effect page title and menu title' do
        visit '/about-us'

        expect(find("#body_content_title").text).to eq(page_bt.title)
        expect(find(".selected").text.strip).to eq(page_bt.title)
      end
    end

    describe 'custom_slug' do
      let(:page_cs) { Page.create :title => 'About Us' }
      before do
        allow(Page).to receive(:fast_menu).and_return([page_cs])
      end

      describe 'canonical url' do
        it 'should have a canonical url' do
          visit '/about-us'

          expect(page).to have_selector('head link[rel="canonical"][href^="http://www.example.com/about-us"]', visible: false)
        end
      end

      describe 'not set' do
        it 'makes friendly_id from title' do
          visit '/about-us'

          expect(current_path).to eq('/about-us')
        end
      end

      describe 'set' do
        before do
          page_cs.custom_slug = "about-custom"
          page_cs.save
        end

        it 'should make and use a new friendly_id' do
          visit '/about-custom'

          expect(current_path).to eq('/about-custom')
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
          allow(Pages).to receive(:scope_slug_by_parent).and_return(false)
          page_cs.custom_slug = "products/my product/cool one!"
          page_cs.save
        end

        after do
          allow(Pages).to receive(:scope_slug_by_parent).and_return(true)
        end

        it 'should make and use a new friendly_id' do
          visit '/products/my-product/cool-one'
          expect(current_path).to eq('/products/my-product/cool-one')
        end
      end
    end

    describe "home page" do
      it "succeeds" do
        visit refinery.root_path

        within ".selected" do
          expect(page).to have_content(home_page.title)
          expect(page).not_to have_content(about_page.title)
        end
        expect(page).to have_content(about_page.title)
      end
    end

    describe "content page" do
      it "succeeds" do
        visit refinery.marketable_page_url(about_page.url)

        expect(page).to have_content(home_page.title)
        within ".selected > a" do
          expect(page).not_to have_content(home_page.title)
          expect(page).to have_content(about_page.title)
        end
      end
    end

    describe "submenu page" do
      let(:submenu_page) { about_page.children.create :title => 'Sample Submenu' }

      before do
        allow(Page).to receive(:fast_menu).and_return(
          [home_page, submenu_page, about_page.reload].sort_by(&:lft)
        )
      end

      it "succeeds" do
        visit refinery.url_for(submenu_page.url)
        expect(page).to have_content(home_page.title)
        expect(page).to have_content(about_page.title)
        within ".active * > .selected a" do
          expect(page).to have_content(submenu_page.title)
        end
      end
    end

    describe "special characters title" do
      let(:special_page) { Page.create :title => 'ä ö ü spéciål chåråctÉrs' }
      before do
        allow(Page).to receive(:fast_menu).and_return(
          [home_page, about_page, special_page]
        )
      end

      it "succeeds" do
        visit refinery.url_for(special_page.url)

        expect(page).to have_content(home_page.title)
        expect(page).to have_content(about_page.title)
        within ".selected > a" do
          expect(page).to have_content(special_page.title)
        end
      end
    end

    describe "special characters title as submenu page" do
      let(:special_page) {
        about_page.children.create :title => 'ä ö ü spéciål chåråctÉrs'
      }

      before do
        allow(Page).to receive(:fast_menu).and_return(
          [home_page, special_page, about_page.reload].sort_by &:lft
        )
      end

      it "succeeds" do
        visit refinery.url_for(special_page.url)

        expect(page).to have_content(home_page.title)
        expect(page).to have_content(about_page.title)
        within ".active * > .selected a" do
          expect(page).to have_content(special_page.title)
        end
      end
    end

    describe "hidden page" do
      let(:hidden_page) { Page.create :title => "Hidden", :show_in_menu => false }

      before do
        allow(Page).to receive(:fast_menu).and_return([home_page, about_page])
      end

      it "succeeds" do
        visit refinery.page_path(hidden_page)

        expect(page).to have_content(home_page.title)
        expect(page).to have_content(about_page.title)
        expect(page).to have_content(hidden_page.title)
        within "nav" do
          expect(page).to have_no_content(hidden_page.title)
        end
      end
    end

    describe "skip to first child" do
      let!(:child_page) { about_page.children.create :title => "Child Page" }
      before do
        about = about_page.reload
        about.skip_to_first_child = true
        about.save!

        allow(Page).to receive(:fast_menu).and_return([home_page, about, child_page].sort_by(&:lft))
      end

      it "succeeds" do
        visit "/about"

        within ".active * > .selected a" do
          expect(page).to have_content(child_page.title)
          expect(page).to_not have_content(::I18n.t('skip_to_first_child', scope: 'refinery.skip_to_first_child_page_message'))
        end
      end
    end

    describe 'when draft is set to true' do
      before { allow_any_instance_of(PagesController).to receive(:find_page).and_return(:draft_page) }

      describe 'for vistor' do
        it 'redirect to the 404 error page' do
          allow_any_instance_of(PagesController).to receive(:current_refinery_user_can_access?).and_return(false)
          
          visit refinery.page_path(draft_page)

          expect(page).to have_http_status(404)
        end
      end

      describe 'for admin' do
        it 'displays draft page message not live' do
          allow_any_instance_of(PagesController).to receive(:current_refinery_user_can_access?).and_return(true)

          visit refinery.page_path(draft_page)

          expect(page).to have_content(::I18n.t('refinery.draft_page_message.not_live'))
        end
      end
    end
  end

  context "with multiple locales" do

    describe "redirects" do
      let(:en_page_title) { 'News' }
      let(:en_page_slug) { 'news' }
      let(:ru_page_title) { 'Новости' }
      let(:ru_page_slug_encoded) { '%D0%BD%D0%BE%D0%B2%D0%BE%D1%81%D1%82%D0%B8' }
      let!(:news_page) do
        @page = Mobility.with_locale(:en) { Page.create title: en_page_title }
        Mobility.with_locale(:ru) do
          @page.title = ru_page_title
          @page.save
        end

        @page
      end

      before {
        allow(Refinery::I18n).to receive(:frontend_locales).and_return([:en, :ru])
        allow(Page).to receive(:fast_menu).and_return([@page])
      }

      after { allow(Refinery::I18n).to receive(:frontend_locales).and_call_original }

      it "should recognise when default locale is in the path" do
        visit "/en/#{en_page_slug}"

        expect(current_path).to eq("/en/#{en_page_slug}")
      end

      it "should display the default locale when locale is not in the path" do
        visit "/#{en_page_slug}"

        expect(current_path).to eq("/#{en_page_slug}")
      end

      it "should redirect to default locale slug" do
        visit "/#{ru_page_slug_encoded}"

        expect(current_path).to eq("/#{en_page_slug}")
      end

      it "should redirect to second locale slug" do
        visit "/ru/#{en_page_slug}"

        expect(current_path).to eq("/ru/#{ru_page_slug_encoded}")

        visit "/en/#{en_page_slug}"
      end

      it "should not have the locale in the menu href link" do
        visit "/en/#{en_page_slug}"

        within('.menu') do
          expect(page).to have_selector(:css, "a[href='/#{en_page_slug}']")
        end
      end

      describe "nested page" do
        let(:nested_page_title) { 'nested_page' }
        let(:nested_page_slug) { 'nested_page' }

        let!(:nested_page) do
          ::I18n.fallbacks[:ru]
          _page = Mobility.with_locale(:en) {
            news_page.children.create :title => nested_page_title
          }

          Mobility.with_locale(:ru) do
            _page.title = nested_page_title
            _page.save
          end
          _page
        end

        it "should redirect to localized url" do
          visit "/ru/#{en_page_slug}/#{nested_page_slug}"

          expect(current_path).to eq("/ru/#{ru_page_slug_encoded}/#{nested_page_slug}")

          visit "/en/#{en_page_slug}/#{nested_page_slug}"
        end
      end
    end
  end
end