# encoding: utf-8
require "spec_helper"

def expect_window_with_content(content, window: windows.last)
  page.within_window window do
    expect(page).to have_content(content)
  end
end

def expect_window_without_content(content, window: windows.last)
  page.within_window window do
    expect(page).not_to have_content(content)
  end
end

module Refinery
  module Admin
    describe "Pages", :type => :feature do
      refinery_login_with :refinery_user

      context "when no pages" do
        it "invites to create one" do
          visit refinery.admin_pages_path
          expect(page).to have_content(%q{There are no pages yet. Click "Add new page" to add your first page.})
        end
      end

      describe "action links" do
        it "shows add new page link" do
          visit refinery.admin_pages_path

          within "#actions" do
            expect(page).to have_content("Add new page")
            expect(page).to have_selector("a[href='/#{Refinery::Core.backend_route}/pages/new']")
          end
        end

        context "when no pages" do
          it "doesn't show reorder pages link" do
            visit refinery.admin_pages_path

            within "#actions" do
              expect(page).to have_no_content("Reorder pages")
              expect(page).to have_no_selector("a[href='/#{Refinery::Core.backend_route}/pages']")
            end
          end
        end

        context "when some pages exist" do
          before { 2.times { |i| Page.create :title => "Page #{i}" } }

          it "shows reorder pages link" do
            visit refinery.admin_pages_path

            within "#actions" do
              expect(page).to have_content("Reorder pages")
              expect(page).to have_selector("a[href='/#{Refinery::Core.backend_route}/pages']")
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
              allow(Refinery::Pages).to receive(:auto_expand_admin_tree).and_return(false)

              visit refinery.admin_pages_path
            end

            it "show parent page" do

              expect(page).to have_content(company.title)
            end

            it "doesn't show children" do
              expect(page).not_to have_content(team.title)
              expect(page).not_to have_content(locations.title)
            end

            it "expands children", :js do
              find("#page_#{company.id} .title.toggle").click

              expect(page).to have_content(team.title)
              expect(page).to have_content(locations.title)
            end

            it "expands children when nested multiple levels deep", :js do
              find("#page_#{company.id} .title.toggle").click
              find("#page_#{locations.id} .title.toggle").click

              expect(page).to have_content("New York")
            end
          end

          context "with auto expand option turned on" do
            before do
              allow(Refinery::Pages).to receive(:auto_expand_admin_tree).and_return(true)

              visit refinery.admin_pages_path
            end

            it "shows children" do
              expect(page).to have_content(team.title)
              expect(page).to have_content(locations.title)
            end
          end
        end
      end

      describe "new/create" do
        it "allows to create page" do
          visit refinery.admin_pages_path

          click_link "Add new page"

          fill_in "Title", :with => "My first page"
          expect { click_button "Save" }.to change(Refinery::Page, :count).from(0).to(1)

          expect(page).to have_content("'My first page' was successfully added.")

          expect(page.body).to match(/Remove this page forever/)
          expect(page.body).to match(/Edit this page/)
          expect(page.body).to match(%r{/#{Refinery::Core.backend_route}/pages/my-first-page/edit})
          expect(page.body).to match(/Add a new child page/)
          expect(page.body).to match(%r{/#{Refinery::Core.backend_route}/pages/new\?parent_id=})
          expect(page.body).to match(/View this page live/)
          expect(page.body).to match(%r{href="/my-first-page"})
        end

        it "includes menu title field", :js => true do
          visit refinery.new_admin_page_path

          fill_in "Title", :with => "My first page"

          click_link "toggle_advanced_options"

          fill_in "Menu title", :with => "The first page"

          expect { click_button "Save" }.to change(Refinery::Page, :count).from(0).to(1)

          expect(page).to have_content("'My first page' was successfully added.")
          expect(page.body).to match(%r{/pages/the-first-page})
        end

        it "allows to easily create nested page" do
          parent_page = Page.create! :title => "Rails 4"

          visit refinery.admin_pages_path

          find("a[href='#{refinery.new_admin_page_path(:parent_id => parent_page.id)}']").click

          fill_in "Title", :with => "Parent page"
          click_button "Save"

          expect(page).to have_content("'Parent page' was successfully added.")
        end
      end

      describe "edit/update" do
        before do
          Page.create :title => "Update me"

          visit refinery.admin_pages_path
          expect(page).to have_content("Update me")
        end

        context 'when saving and returning to index' do
          it "updates page" do
            click_link "Edit this page"

            fill_in "Title", :with => "Updated"
            find("#submit_button").click

            expect(page).to have_content("'Updated' was successfully updated.")
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
            expect(page).to have_content("'Updated' was successfully updated.")
          end

          # Regression test for https://github.com/refinery/refinerycms/issues/1892
          context 'when saving to exit (a second time)' do
            it 'updates page', :js do
              find("#submit_button").click
              expect(page).to have_content("'Updated' was successfully updated.")
            end
          end
        end
      end

      describe 'Previewing', :js do
        let(:preview_content) { "Some changes I'm unsure what they will look like".freeze }
        context "an existing page" do
          before { Page.create :title => 'Preview me' }

          it 'will show the preview changes in a new window' do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in "Title", with: preview_content
            window = window_opened_by do
              click_button "Preview"
            end

            expect_window_with_content(preview_content, window: window)

            window.close
          end

          it 'will not show the site bar' do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in "Title", with: preview_content
            window = window_opened_by do
              click_button "Preview"
            end

            expect_window_without_content(
              ::I18n.t('switch_to_website', scope: 'refinery.site_bar'),
              window: window
            )
            expect_window_without_content(
              ::I18n.t('switch_to_website_editor', scope: 'refinery.site_bar'),
              window: window
            )

            window.close
          end

          it 'will not save the preview changes' do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in "Title", with: preview_content
            window = window_opened_by do
              click_button "Preview"
            end

            expect_window_with_content(
              preview_content,
              window: window
            )

            window.close

            expect(Page.by_title(preview_content)).to be_empty
          end

          # Regression test for previewing after save-and_continue
          it 'will show the preview in a new window after save-and-continue' do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in "Title", :with => "Save this"
            click_button "Save & continue editing"
            expect(page).to have_content("'Save this' was successfully updated")

            window = window_opened_by do
              click_button "Preview"
            end

            expect_window_with_content("Save this", window: window)
            expect_window_without_content(
              ::I18n.t('switch_to_website', :scope => 'refinery.site_bar'),
              window: window
            )

            window.close
          end

          it 'will show pages with inherited templates' do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in 'Title', :with => 'Searchable'
            click_link 'Advanced options'
            select 'Searchable', :from => 'View template'
            click_button 'Preview'

            expect_window_with_content('Form application/search_form')
          end
        end

        context 'a brand new page' do
          it "will not save when just previewing" do
            visit refinery.admin_pages_path

            click_link "Add new page"
            fill_in "Title", :with => "My first page"
            window = window_opened_by do
              click_button "Preview"
            end

            expect_window_with_content("My first page", window: window)

            expect(Page.count).to eq(0)
            window.close
          end
        end

        context 'a nested page' do
          let!(:parent_page) { Page.create :title => "Our Parent Page" }
          let!(:nested_page) { parent_page.children.create :title => 'Preview Me' }

          it "works like an un-nested page" do
            visit refinery.admin_pages_path

            within "#page_#{nested_page.id}" do
              find('a[tooltip^=Edit]').click
            end

            fill_in "Title", with: preview_content
            window = window_opened_by do
              click_button "Preview"
            end

            expect_window_with_content(preview_content)
          end
        end
      end

      describe "destroy" do
        context "when page can be deleted" do
          before { Page.create :title => "Delete me" }

          it "will show delete button" do
            visit refinery.admin_pages_path

            click_link "Remove this page forever"

            expect(page).to have_content("'Delete me' was successfully removed.")

            expect(Refinery::Page.count).to eq(0)
          end
        end

        context "when page can't be deleted" do
          before { Page.create :title => "Indestructible", :deletable => false }

          it "wont show delete button" do
            visit refinery.admin_pages_path

            expect(page).to have_no_content("Remove this page forever")
            expect(page).to have_no_selector("a[href='/#{Refinery::Core.backend_route}/pages/indestructible']")
          end
        end
      end

      context "duplicate page titles" do
        before { Page.create :title => "I was here first" }

        it "will append nr to url path" do
          visit refinery.new_admin_page_path

          fill_in "Title", :with => "I was here first"
          click_button "Save"

          expect(Refinery::Page.last.url[:path].first).to match(%r{\Ai-was-here-first-.+?})
        end
      end

      context "with translations" do
        before do
          allow(Refinery::I18n).to receive(:frontend_locales).and_return([:en, :ru])

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
            expect(page).to have_content("'News' was successfully added.")
            expect(Refinery::Page.count).to eq(2)
          end

          it "shows locale flag for page" do
            p = ::Refinery::Page.by_slug('news').first
            within "#page_#{p.id}" do
              expect(page).to have_css(".locale_icon.en")
            end
          end

          it "shows title in the admin menu" do
            p = ::Refinery::Page.by_slug('news').first
            within "#page_#{p.id}" do
              expect(page).to have_content('News')
              expect(page.find_link('Edit this page')[:href]).to include('news')
            end
          end

          it "shows in frontend menu for 'en' locale" do
            visit "/"

            within "#menu" do
              expect(page).to have_content('News')
              expect(page).to have_selector("a[href='/news']")
            end
          end

          it "doesn't show in frontend menu for 'ru' locale" do
            visit "/ru"

            within "#menu" do
              # we should only have the home page in the menu
              expect(page).to have_css('li', :count => 1)
            end
          end
        end

        describe "add a page with title for both locales" do
          let(:en_page_title) { 'News' }
          let(:en_page_slug) { 'news' }
          let(:ru_page_title) { 'Новости' }
          let(:ru_page_slug_encoded) { '%D0%BD%D0%BE%D0%B2%D0%BE%D1%81%D1%82%D0%B8' }
          let!(:news_page) do
            allow(Refinery::I18n).to receive(:frontend_locales).and_return([:en, :ru])

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
              click_link "ru"
            end
            fill_in "Title", :with => ru_page_title
            click_button "Save"

            within "#page_#{Page.last.id} .actions" do
              find("a[href^='/#{Refinery::Core.backend_route}/pages/#{ru_page_slug_encoded}/edit']").click
            end
            within "#switch_locale_picker" do
              click_link "en"
            end
            fill_in "Title", :with => en_page_title
            find("#submit_button").click

            expect(page).to have_content("'#{en_page_title}' was successfully updated.")
            expect(Refinery::Page.count).to eq(2)
          end

          it "shows both locale flags for page" do
            visit refinery.admin_pages_path

            within "#page_#{news_page.id}" do
              expect(page).to have_css(".locale_icon.en")
              expect(page).to have_css(".locale_icon.ru")
            end
          end

          it "shows title in admin menu in current admin locale" do
            visit refinery.admin_pages_path

            within "#page_#{news_page.id}" do
              expect(page).to have_content(en_page_title)
            end
          end

          it "uses the slug from the default locale in admin" do
            visit refinery.admin_pages_path

            within "#page_#{news_page.id}" do
              expect(page.find_link('Edit this page')[:href]).to include(en_page_slug)
            end
          end

          it "shows correct language and slugs for default locale" do
            visit "/"

            within "#menu" do
              expect(page.find_link(news_page.title)[:href]).to include(en_page_slug)
            end
          end

          it "shows correct language and slugs for second locale" do
            visit "/ru"

            within "#menu" do
              expect(page.find_link(ru_page_title)[:href]).to include(ru_page_slug_encoded)
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
              click_link "ru"
            end
            fill_in "Title", :with => ru_page_title
            click_button "Save"

            expect(page).to have_content("'#{ru_page_title}' was successfully added.")
            expect(Refinery::Page.count).to eq(2)
          end

          it "shows locale flag for page" do
            within "#page_#{ru_page_id}" do
              expect(page).to have_css(".locale_icon.ru")
            end
          end

          it "doesn't show locale flag for primary locale" do
            within "#page_#{ru_page_id}" do
              expect(page).not_to have_css("img[src='/assets/refinery/icons/flags/en.png']")
            end
          end

          it "shows title in the admin menu" do
            within "#page_#{ru_page_id}" do
              expect(page).to have_content(ru_page_title)
            end
          end

          it "uses slug in admin" do
            within "#page_#{ru_page_id}" do
              expect(page.find_link('Edit this page')[:href]).to include(ru_page_slug_encoded)
            end
          end

          it "shows in frontend menu for 'ru' locale" do
            visit "/ru"

            within "#menu" do
              expect(page).to have_content(ru_page_title)
              expect(page).to have_selector("a[href*='/#{ru_page_slug_encoded}']")
            end
          end

          it "won't show in frontend menu for 'en' locale" do
            visit "/"

            within "#menu" do
              # we should only have the home page in the menu
              expect(page).to have_css('li', :count => 1)
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
              expect(sub_page.parent).to eq(parent_page)
              visit refinery.admin_pages_path
              within "#page_#{sub_page.id}" do
                click_link "Application edit"
              end
              fill_in "Title", :with => ru_page_title
              click_button "Save"
              expect(page).to have_content("'#{ru_page_title}' was successfully updated")
            end
          end
        end
      end

      describe "new page part", :js do
        before do
          allow(Refinery::Pages).to receive(:new_page_parts).and_return(true)
        end

        it "adds new page part" do
          visit refinery.new_admin_page_path
          click_link "add_page_part"

          within "#new_page_part_dialog" do
            fill_in "new_page_part_title", :with => "testy"
            click_button "Save"
          end

          within "#page_parts" do
            expect(page).to have_content("testy")
          end
        end
      end

      describe "delete existing page part", :js do
        let!(:some_page) { Page.create! :title => "Some Page" }

        before do
          some_page.parts.create! :title => "First Part", :position => 1
          some_page.parts.create! :title => "Second Part", :position => 2
          some_page.parts.create! :title => "Third Part", :position => 3

          allow(Refinery::Pages).to receive(:new_page_parts).and_return(true)
        end

        it "deletes page parts" do
          visit refinery.edit_admin_page_path(some_page.id)

          within "#page_parts" do
            expect(page).to have_content("First Part")
            expect(page).to have_content("Second Part")
            expect(page).to have_content("Third Part")
          end

          2.times do
            click_link "delete_page_part"
            # Poltergeist automatically accepts dialogues.
            if Capybara.javascript_driver != :poltergeist
              page.driver.browser.switch_to.alert.accept
            end
          end

          within "#page_parts" do
            expect(page).to have_no_content("First Part")
            expect(page).to have_no_content("Second Part")
            expect(page).to have_content("Third Part")
          end

          click_button "submit_button"

          visit refinery.edit_admin_page_path(some_page.id)

          within "#page_parts" do
            expect(page).to have_no_content("First Part")
            expect(page).to have_no_content("Second Part")
            expect(page).to have_content("Third Part")
          end
        end
      end

      describe 'advanced options' do
        describe 'view and layout templates' do
          context 'when parent page has templates set' do
            before do
              allow(Refinery::Pages).to receive(:use_layout_templates).and_return(true)
              allow(Refinery::Pages).to receive(:layout_template_whitelist).and_return(['abc', 'refinery'])
              allow(Refinery::Pages).to receive(:valid_templates).and_return(['abc', 'refinery'])
              parent_page = Page.create :title => 'Parent Page',
                                        :view_template => 'refinery',
                                        :layout_template => 'refinery'
              @page = parent_page.children.create :title => 'Child Page'
            end

            specify 'sub page should inherit them', :js => true do
              visit refinery.edit_admin_page_path(@page.id)

              click_link 'toggle_advanced_options'

              within '#page_layout_template' do
                expect(page.find('option[value=refinery]')).to be_selected
              end

              within '#page_view_template' do
                expect(page.find('option[value=refinery]')).to be_selected
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
          expect(page).to have_content("header class='regression'")
        end
      end
    end

    describe "TranslatePages", :type => :feature do
      before { Globalize.locale = :en }
      refinery_login_with :refinery_user

      describe "add page to second locale" do
        before do
          allow(Refinery::I18n).to receive(:frontend_locales).and_return([:en, :lv])
          Page.create :title => 'First Page'
        end

        it "succeeds" do
          visit refinery.admin_pages_path

          click_link "Add new page"

          within "#switch_locale_picker" do
            click_link "lv"
          end
          fill_in "Title", :with => "Brīva vieta reklāmai"
          click_button "Save"

          expect(page).to have_content("'Brīva vieta reklāmai' was successfully added.")
          expect(Refinery::Page.count).to eq(2)
        end
      end

      describe "Pages Link-to Dialog" do
        before do
          allow(Refinery::I18n).to receive(:frontend_locales).and_return [:en, :ru]

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
          # we need page parts so that there's a visual editor
          Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
            page.parts.create(:title => default_page_part, :body => nil, :position => index)
          end
          page
        end

        describe "adding page link" do
          describe "with relative urls" do
            before { Refinery::Pages.absolute_page_links = false }

            it "shows Russian pages if we're editing the Russian locale" do
              visit refinery.link_to_admin_pages_dialogs_path(:visual_editor => true, :switch_locale => :ru)

              expect(page).to have_content("About Ru")
              expect(page).to have_selector("a[href='/ru/about-ru']")
            end

            it "shows default to the default locale if no query string is added" do
              visit refinery.link_to_admin_pages_dialogs_path(:visual_editor => true)

              expect(page).to have_content("About")
              expect(page).to have_selector("a[href='/about']")
            end
          end

          describe "with absolute urls" do
            before { Refinery::Pages.absolute_page_links = true }

            it "shows Russian pages if we're editing the Russian locale" do
              visit refinery.link_to_admin_pages_dialogs_path(:visual_editor => true, :switch_locale => :ru)

              expect(page).to have_content("About Ru")
              expect(page).to have_selector("a[href='http://www.example.com/ru/about-ru']")
            end

            it "shows default to the default locale if no query string is added" do
              visit refinery.link_to_admin_pages_dialogs_path(:visual_editor => true)

              expect(page).to have_content("About")
              expect(page).to have_selector("a[href='http://www.example.com/about']")
            end
          end
        end
      end
    end
  end
end
