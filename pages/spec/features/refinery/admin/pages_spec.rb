# encoding: utf-8
require "spec_helper"

def new_window_should_have_content(content)
  new_window = page.driver.browser.window_handles.last
  page.within_window new_window do
    page.should have_content(content)
  end
end

def new_window_should_not_have_content(content)
  new_window = page.driver.browser.window_handles.last
  page.within_window new_window do
    page.should_not have_content(content)
  end
end

module Refinery
  module Admin
    describe "Pages" do
      refinery_login_with :refinery_user

      context "when no pages" do
        it "invites to create one" do
          visit refinery.admin_pages_path
          page.should have_content(%q{There are no pages yet. Click "Add new page" to add your first page.})
        end
      end

      describe "action links" do
        it "shows add new page link" do
          visit refinery.admin_pages_path

          within "#actions" do
            page.should have_content("Add new page")
            page.should have_selector("a[href='/refinery/pages/new']")
          end
        end

        context "when no pages" do
          it "doesn't show reorder pages link" do
            visit refinery.admin_pages_path

            within "#actions" do
              page.should have_no_content("Reorder pages")
              page.should have_no_selector("a[href='/refinery/pages']")
            end
          end
        end

        context "when some pages exist" do
          before { 2.times { |i| Page.create :title => "Page #{i}" } }

          it "shows reorder pages link" do
            visit refinery.admin_pages_path

            within "#actions" do
              page.should have_content("Reorder pages")
              page.should have_selector("a[href='/refinery/pages']")
            end
          end
        end

        context "when sub pages exist" do
          let!(:company) { Page.create :title => 'Our Company' }
          let!(:team) { company.children.create :title => 'Our Team' }
          let!(:locations) { company.children.create :title => 'Our Locations' }
          let!(:location) { locations.children.create :title => 'New York' }

          context "with auto expand option turned off" do
            before do
              Refinery::Pages.stub(:auto_expand_admin_tree).and_return(false)

              visit refinery.admin_pages_path
            end

            it "show parent page" do

              page.should have_content(company.title)
            end

            it "doesn't show children" do
              page.should_not have_content(team.title)
              page.should_not have_content(locations.title)
            end

            it "expands children", :js do
              find("#page_#{company.id} .title.toggle").click

              page.should have_content(team.title)
              page.should have_content(locations.title)
            end

            it "expands children when nested mutliple levels deep", :js do
              find("#page_#{company.id} .title.toggle").click
              find("#page_#{locations.id} .title.toggle").click

              page.should have_content("New York")
            end
          end

          context "with auto expand option turned on" do
            before do
              Refinery::Pages.stub(:auto_expand_admin_tree).and_return(true)

              visit refinery.admin_pages_path
            end

            it "shows children" do
              page.should have_content(team.title)
              page.should have_content(locations.title)
            end
          end
        end
      end

      describe "new/create" do
        it "allows to create page" do
          visit refinery.admin_pages_path

          click_link "Add new page"

          fill_in "Title", :with => "My first page"
          click_button "Save"

          page.should have_content("'My first page' was successfully added.")

          page.body.should =~ /Remove this page forever/
          page.body.should =~ /Edit this page/
          page.body.should =~ %r{/refinery/pages/my-first-page/edit}
          page.body.should =~ /Add a new child page/
          page.body.should =~ %r{/refinery/pages/new\?parent_id=}
          page.body.should =~ /View this page live/
          page.body.should =~ %r{href="/my-first-page"}

          Refinery::Page.count.should == 1
        end

        it "includes menu title field", :js => true do
          visit refinery.new_admin_page_path

          fill_in "Title", :with => "My first page"

          click_link "toggle_advanced_options"

          fill_in "Menu title", :with => "The first page"

          click_button "Save"

          page.should have_content("'My first page' was successfully added.")
          page.body.should =~ %r{/pages/the-first-page}
        end
      end

      describe "edit/update" do
        before do
          Page.create :title => "Update me"

          visit refinery.admin_pages_path
          page.should have_content("Update me")
        end

        context 'when saving and returning to index' do
          it "updates page" do
            click_link "Edit this page"

            fill_in "Title", :with => "Updated"
            find("#submit_button").click

            page.should have_content("'Updated' was successfully updated.")
          end
        end

        context 'when saving and continuing to edit' do
          before :each do
            find('a[tooltip^=Edit]').visible?
            find('a[tooltip^=Edit]').click

            fill_in "Title", :with => "Updated"
            find("#submit_continue_button").click
            find('#flash').visible?
          end

          it "updates page", :js do
            page.should have_content("'Updated' was successfully updated.")
          end

          # Regression test for https://github.com/refinery/refinerycms/issues/1892
          context 'when saving to exit (a second time)' do
            it 'updates page', :js do
              find("#submit_button").click
              page.should have_content("'Updated' was successfully updated.")
            end
          end
        end
      end

      describe 'Previewing' do
        context "an existing page" do
          before { Page.create :title => 'Preview me' }

          it 'will show the preview changes in a new window', :js do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in "Title", :with => "Some changes I'm unsure what they will look like"
            click_button "Preview"

            new_window_should_have_content("Some changes I'm unsure what they will look like")
          end

          it 'will not show the site bar', :js do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in "Title", :with => "Some changes I'm unsure what they will look like"
            click_button "Preview"

            new_window_should_not_have_content(
              ::I18n.t('switch_to_website', :scope => 'refinery.site_bar')
            )
            new_window_should_not_have_content(
              ::I18n.t('switch_to_website_editor', :scope => 'refinery.site_bar')
            )
          end

          it 'will not save the preview changes', :js do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in "Title", :with => "Some changes I'm unsure what they will look like"
            click_button "Preview"

            new_window_should_have_content("Some changes I'm unsure what they will look like")

            Page.by_title("Some changes I'm unsure what they will look like").should be_empty
          end

          # Regression test for previewing after save-and_continue
          it 'will show the preview in a new window after save-and-continue', :js do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in "Title", :with => "Save this"
            click_button "Save & continue editing"
            page.should have_content("'Save this' was successfully updated")

            click_button "Preview"

            new_window_should_have_content("Save this")
            new_window_should_not_have_content(
              ::I18n.t('switch_to_website', :scope => 'refinery.site_bar')
            )
          end
        end

        context 'a brand new page' do
          it "will not save when just previewing", :js do
            visit refinery.admin_pages_path

            click_link "Add new page"
            fill_in "Title", :with => "My first page"
            click_button "Preview"

            new_window_should_have_content("My first page")

            Page.count.should == 0
          end
        end

        context 'a nested page' do
          let!(:parent_page) { Page.create :title => "Our Parent Page" }
          let!(:nested_page) { parent_page.children.create :title => 'Preview Me' }

          it "works like an un-nested page", :js do
            visit refinery.admin_pages_path

            within "#page_#{nested_page.id}" do
              find('a[tooltip^=Edit]').click
            end

            fill_in "Title", :with => "Some changes I'm unsure what they will look like"
            click_button "Preview"

            new_window_should_have_content("Some changes I'm unsure what they will look like")
          end
        end
      end

      describe "destroy" do
        context "when page can be deleted" do
          before { Page.create :title => "Delete me" }

          it "will show delete button" do
            visit refinery.admin_pages_path

            click_link "Remove this page forever"

            page.should have_content("'Delete me' was successfully removed.")

            Refinery::Page.count.should == 0
          end
        end

        context "when page can't be deleted" do
          before { Page.create :title => "Indestructible", :deletable => false }

          it "wont show delete button" do
            visit refinery.admin_pages_path

            page.should have_no_content("Remove this page forever")
            page.should have_no_selector("a[href='/refinery/pages/indestructible']")
          end
        end
      end

      context "duplicate page titles" do
        before { Page.create :title => "I was here first" }

        it "will append nr to url path" do
          visit refinery.new_admin_page_path

          fill_in "Title", :with => "I was here first"
          click_button "Save"

          Refinery::Page.last.url[:path].should == ["i-was-here-first--2"]
        end
      end

      context "with translations" do
        before do
          Refinery::I18n.stub(:frontend_locales).and_return([:en, :ru])

          # Create a home page in both locales (needed to test menus)
          home_page = Globalize.with_locale(:en) do
            Page.create :title => 'Home',
                        :link_url => '/',
                        :menu_match => "^/$"
          end

          Globalize.with_locale(:ru) do
            home_page.title = 'Домашняя страница'
            home_page.save
          end
        end

        describe "add a page with title for default locale" do
          before do
            visit refinery.admin_pages_path
            click_link "Add new page"
            fill_in "Title", :with => "News"
            click_button "Save"
          end

          it "succeeds" do
            page.should have_content("'News' was successfully added.")
            Refinery::Page.count.should == 2
          end

          it "shows locale flag for page" do
            p = ::Refinery::Page.by_slug('news').first
            within "#page_#{p.id}" do
              page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
            end
          end

          it "shows title in the admin menu" do
            p = ::Refinery::Page.by_slug('news').first
            within "#page_#{p.id}" do
              page.should have_content('News')
              page.find_link('Edit this page')[:href].should include('news')
            end
          end

          it "shows in frontend menu for 'en' locale" do
            visit "/"

            within "#menu" do
              page.should have_content('News')
              page.should have_selector("a[href='/news']")
            end
          end

          it "doesn't show in frontend menu for 'ru' locale" do
            visit "/ru"

            within "#menu" do
              # we should only have the home page in the menu
              page.should have_css('li', :count => 1)
            end
          end
        end

        describe "add a page with title for both locales" do
          let(:en_page_title) { 'News' }
          let(:en_page_slug) { 'news' }
          let(:ru_page_title) { 'Новости' }
          let(:ru_page_slug_encoded) { '%D0%BD%D0%BE%D0%B2%D0%BE%D1%81%D1%82%D0%B8' }
          let!(:news_page) do
            Refinery::I18n.stub(:frontend_locales).and_return([:en, :ru])

            _page = Globalize.with_locale(:en) {
              Page.create :title => en_page_title
            }
            Globalize.with_locale(:ru) do
              _page.title = ru_page_title
              _page.save
            end

            _page
          end

          it "succeeds" do
            news_page.destroy!
            visit refinery.admin_pages_path

            click_link "Add new page"
            within "#switch_locale_picker" do
              click_link "Ru"
            end
            fill_in "Title", :with => ru_page_title
            click_button "Save"

            within "#page_#{Page.last.id}" do
              click_link "Application_edit"
            end
            within "#switch_locale_picker" do
              click_link "En"
            end
            fill_in "Title", :with => en_page_title
            find("#submit_button").click

            page.should have_content("'#{en_page_title}' was successfully updated.")
            Refinery::Page.count.should == 2
          end

          it "shows both locale flags for page" do
            visit refinery.admin_pages_path

            within "#page_#{news_page.id}" do
              page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
              page.should have_css("img[src='/assets/refinery/icons/flags/ru.png']")
            end
          end

          it "shows title in admin menu in current admin locale" do
            visit refinery.admin_pages_path

            within "#page_#{news_page.id}" do
              page.should have_content(en_page_title)
            end
          end

          it "uses the slug from the default locale in admin" do
            visit refinery.admin_pages_path

            within "#page_#{news_page.id}" do
              page.find_link('Edit this page')[:href].should include(en_page_slug)
            end
          end

          it "shows correct language and slugs for default locale" do
            visit "/"

            within "#menu" do
              page.find_link(news_page.title)[:href].should include(en_page_slug)
            end
          end

          it "shows correct language and slugs for second locale" do
            visit "/ru"

            within "#menu" do
              page.find_link(ru_page_title)[:href].should include(ru_page_slug_encoded)
            end
          end
        end

        describe "add a page with title only for secondary locale" do
          let(:ru_page) {
            Globalize.with_locale(:ru) {
              Page.create :title => ru_page_title
            }
          }
          let(:ru_page_id) { ru_page.id }
          let(:ru_page_title) { 'Новости' }
          let(:ru_page_slug_encoded) { '%D0%BD%D0%BE%D0%B2%D0%BE%D1%81%D1%82%D0%B8' }

          before do
            ru_page
            visit refinery.admin_pages_path
          end

          it "succeeds" do
            ru_page.destroy!
            click_link "Add new page"
            within "#switch_locale_picker" do
              click_link "Ru"
            end
            fill_in "Title", :with => ru_page_title
            click_button "Save"

            page.should have_content("'#{ru_page_title}' was successfully added.")
            Refinery::Page.count.should == 2
          end

          it "shows locale flag for page" do
            within "#page_#{ru_page_id}" do
              page.should have_css("img[src='/assets/refinery/icons/flags/ru.png']")
            end
          end

          it "doesn't show locale flag for primary locale" do
            within "#page_#{ru_page_id}" do
              page.should_not have_css("img[src='/assets/refinery/icons/flags/en.png']")
            end
          end

          it "shows title in the admin menu" do
            within "#page_#{ru_page_id}" do
              page.should have_content(ru_page_title)
            end
          end

          it "uses id instead of slug in admin" do
            within "#page_#{ru_page_id}" do
              page.find_link('Edit this page')[:href].should include(ru_page_id.to_s)
            end
          end

          it "shows in frontend menu for 'ru' locale" do
            visit "/ru"

            within "#menu" do
              page.should have_content(ru_page_title)
              page.should have_selector("a[href*='/#{ru_page_slug_encoded}']")
            end
          end

          it "won't show in frontend menu for 'en' locale" do
            visit "/"

            within "#menu" do
              # we should only have the home page in the menu
              page.should have_css('li', :count => 1)
            end
          end

          context "when page is a child page" do
            it 'succeeds' do
              ru_page.destroy!
              parent_page = Page.create(:title => "Parent page")
              sub_page = Globalize.with_locale(:ru) {
                Page.create :title => ru_page_title
                Page.create :title => ru_page_title, :parent_id => parent_page.id
              }
              sub_page.parent.should == parent_page
              visit refinery.admin_pages_path
              within "#page_#{sub_page.id}" do
                click_link "Application_edit"
              end
              fill_in "Title", :with => ru_page_title
              click_button "Save"
              page.should have_content("'#{ru_page_title}' was successfully updated")
            end
          end
        end
      end

      describe "new page part", :js do
        before do
          Refinery::Pages.stub(:new_page_parts).and_return(true)
        end

        it "adds new page part" do
          visit refinery.new_admin_page_path
          click_link "add_page_part"

          within "#new_page_part_dialog" do
            fill_in "new_page_part_title", :with => "testy"
            click_button "Save"
          end

          within "#page_parts" do
            page.should have_content("testy")
          end
        end
      end

      describe "delete existing page part", :js do
        let!(:some_page) { Page.create! :title => "Some Page" }

        before do
          some_page.parts.create! :title => "First Part", :position => 1
          some_page.parts.create! :title => "Second Part", :position => 2
          some_page.parts.create! :title => "Third Part", :position => 3

          Refinery::Pages.stub(:new_page_parts).and_return(true)
        end

        it "deletes page parts" do
          visit refinery.edit_admin_page_path(some_page.id)

          within "#page_parts" do
            page.should have_content("First Part")
            page.should have_content("Second Part")
            page.should have_content("Third Part")
          end

          2.times do
            click_link "delete_page_part"
            page.driver.browser.switch_to.alert.accept
          end

          within "#page_parts" do
            page.should have_no_content("First Part")
            page.should have_no_content("Second Part")
            page.should have_content("Third Part")
          end

          click_button "submit_button"

          visit refinery.edit_admin_page_path(some_page.id)

          within "#page_parts" do
            page.should have_no_content("First Part")
            page.should have_no_content("Second Part")
            page.should have_content("Third Part")
          end
        end
      end

      describe 'advanced options' do
        describe 'view and layout templates' do
          context 'when parent page has templates set' do
            before do
              Refinery::Pages.stub(:use_layout_templates).and_return(true)
              Refinery::Pages.stub(:layout_template_whitelist).and_return(['abc', 'refinery'])
              Refinery::Pages.stub(:valid_templates).and_return(['abc', 'refinery'])
              parent_page = Page.create :title => 'Parent Page',
                                        :view_template => 'refinery',
                                        :layout_template => 'refinery'
              @page = parent_page.children.create :title => 'Child Page'
            end

            specify 'sub page should inherit them', :js => true do
              visit refinery.edit_admin_page_path(@page.id)

              click_link 'toggle_advanced_options'

              within '#page_layout_template' do
                page.find('option[value=refinery]').should be_selected
              end

              within '#page_view_template' do
                page.find('option[value=refinery]').should be_selected
              end
            end
          end
        end
      end

      # regression spec for https://github.com/refinery/refinerycms/issues/1891
      describe "page part body" do
        before do
          page = Refinery::Page.create! :title => "test"
          Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
            page.parts.create(:title => default_page_part,
                              :body => "<header class='regression'>test</header>",
                              :position => index)
          end
        end

        specify "html shouldn't be stripped" do
          visit refinery.admin_pages_path
          click_link "Edit this page"
          page.should have_content("header class='regression'")
        end
      end
    end

    describe "TranslatePages" do
      refinery_login_with :refinery_translator

      describe "add page to main locale" do
        it "doesn't succeed" do
          visit refinery.admin_pages_path

          click_link "Add new page"

          fill_in "Title", :with => "Huh?"
          click_button "Save"

          page.should have_content("You do not have the required permission to modify pages in this language")
        end
      end

      describe "add page to second locale" do
        before do
          Refinery::I18n.stub(:frontend_locales).and_return([:en, :lv])
          Page.create :title => 'First Page'
        end

        it "succeeds" do
          visit refinery.admin_pages_path

          click_link "Add new page"

          within "#switch_locale_picker" do
            click_link "Lv"
          end
          fill_in "Title", :with => "Brīva vieta reklāmai"
          click_button "Save"

          page.should have_content("'Brīva vieta reklāmai' was successfully added.")
          Refinery::Page.count.should == 2
        end
      end

      describe "delete page from main locale" do
        before { Page.create :title => 'Default Page' }

        it "doesn't succeed" do
          visit refinery.admin_pages_path

          click_link "Remove this page forever"

          page.should have_content("You do not have the required permission to modify pages in this language.")
          Refinery::Page.count.should == 1
        end
      end

      describe "Pages Link-to Dialog" do
        before do
          Refinery::I18n.stub(:frontend_locales).and_return [:en, :ru]

          # Create a page in both locales
          about_page = Globalize.with_locale(:en) do
            Page.create :title => 'About'
          end

          Globalize.with_locale(:ru) do
            about_page.title = 'About Ru'
            about_page.save
          end
        end

        let(:about_page) do
          page = Refinery::Page.last
          # we need page parts so that there's wymeditor
          Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
            page.parts.create(:title => default_page_part, :body => nil, :position => index)
          end
          page
        end

        describe "adding page link" do
          describe "with relative urls" do
            before { Refinery::Pages.absolute_page_links = false }

            it "shows Russian pages if we're editing the Russian locale" do
              visit refinery.link_to_admin_pages_dialogs_path(:wymeditor => true, :switch_locale => :ru)

              page.should have_content("About Ru")
              page.should have_selector("a[href='/ru/about-ru']")
            end

            it "shows default to the default locale if no query string is added" do
              visit refinery.link_to_admin_pages_dialogs_path(:wymeditor => true)

              page.should have_content("About")
              page.should have_selector("a[href='/about']")
            end
          end

          describe "with absolute urls" do
            before { Refinery::Pages.absolute_page_links = true }

            it "shows Russian pages if we're editing the Russian locale" do
              visit refinery.link_to_admin_pages_dialogs_path(:wymeditor => true, :switch_locale => :ru)

              page.should have_content("About Ru")
              page.should have_selector("a[href='http://www.example.com/ru/about-ru']")
            end

            it "shows default to the default locale if no query string is added" do
              visit refinery.link_to_admin_pages_dialogs_path(:wymeditor => true)

              page.should have_content("About")
              page.should have_selector("a[href='http://www.example.com/about']")
            end
          end

          # see https://github.com/refinery/refinerycms/pull/1583
          context "when switching locales" do
            specify "dialog has correct links", :js do
              visit refinery.edit_admin_page_path(about_page)


              find("#page_part_body .wym_tools_link a").click

              page.should have_selector("iframe#dialog_frame")

              page.within_frame("dialog_frame") do
                page.should have_content("About")
                page.should have_css("a[href$='/about']")

                click_link "cancel_button"
              end

              within "#switch_locale_picker" do
                click_link "Ru"
              end

              find("#page_part_body .wym_tools_link a").click

              page.should have_selector("iframe#dialog_frame")

              page.within_frame("dialog_frame") do
                page.should have_content("About Ru")
                page.should have_css("a[href$='/ru/about-ru']")
              end
            end
          end
        end
      end
    end
  end
end
