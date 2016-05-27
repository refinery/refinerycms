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

def switch_page_form_locale(locale)
  within "#switch_locale_picker" do
    find("a", text: locale.upcase).click
  end

  # make sure that the locale change has taken effect
  expect(page).to have_selector("#switch_locale_picker li.selected a##{locale.downcase}")
end

module Refinery
  module Admin
    describe "Pages", :type => :feature do
      refinery_login

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
          let!(:page_0) { Page.create! title: 'Page 0' }
          let!(:page_1) { Page.create! title: 'Page 1' }

          it "shows reorder pages link" do
            visit refinery.admin_pages_path

            within "#actions" do
              expect(page).to have_content("Reorder pages")
              expect(page).to have_selector("a[href='/#{Refinery::Core.backend_route}/pages']")
            end
          end

          context "when reordering pages" do
            let(:reorder_url) { "/#{Refinery::Core.backend_route}/pages/update_positions" }
            before do
              visit refinery.admin_pages_path
              page.driver.post(reorder_url, {
                'ul[0][0][id]' => "page_#{page_1.id}",
                'ul[0][1][id]' => "page_#{page_0.id}",
              })
            end

            it "shows pages in the new order" do
              visit refinery.admin_pages_path
              expect(page.body).to match(/Page 1.*Page 0/m)
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

            it "expands children", js: true do
              find("#page_#{company.id} .title.toggle").click

              expect(page).to have_content(team.title)
              expect(page).to have_content(locations.title)
            end

            it "expands children when nested multiple levels deep", js: true do
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
        it "Creates a page", js:true do
          visit refinery.admin_pages_path

          find('a', text: 'Add new page').trigger(:click)

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

        it "includes menu title field", js: true do
          visit refinery.new_admin_page_path

          fill_in "Title", :with => "My first page"

          find('#toggle_advanced_options').trigger(:click)

          fill_in "Menu title", :with => "The first page"

          # For some reason the first click doesn't always work?
          begin
            click_button "Save"
            sleep 0.1
            redo unless Refinery::Page.any?
          end

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
        let(:updateable_page_parent) { Page.create title: "Parent page" }
        let!(:updateable_page) {
          updateable_page_parent.children.create title: "Update me"
        }

        before do
          visit refinery.admin_pages_path
          expect(page).to have_content("Update me")
        end

        context 'when saving and returning to index' do
          it "updates page", js: true do
            find("a[href$='#{updateable_page.slug}/edit']").trigger(:click)

            fill_in "Title", :with => "Updated"
            find("#submit_button").click

            expect(page).to have_content("'Updated' was successfully updated.")
          end
        end

        context 'when saving and continuing to edit', js: true do
          before :each do
            expect(page).to have_selector("a[href$='#{updateable_page.slug}/edit']", visible: true)
            find("a[href$='#{updateable_page.slug}/edit']").click

            fill_in "Title", :with => "Updated you"
            find("#submit_continue_button").click
            find('#flash').visible?
          end

          it "updates page" do
            expect(page).to have_content("'Updated you' was successfully updated.")
          end

          # Regression test for https://github.com/refinery/refinerycms/issues/3179
          # We expect this to end with /updated-you rather than /updated%2Fyou
          it "doesn't have an encoded URL" do
            updateable_page.reload # the slug will be different now
            expect(page).not_to have_selector("form[action$='%2F#{updateable_page.slug}']")
            expect(page).to have_selector("form[action$='/#{updateable_page.slug}']")
          end

          # Regression test for https://github.com/refinery/refinerycms/issues/1892
          context 'when saving to exit (a second time)' do
            it 'updates page' do
              find("#submit_button").click
              expect(page).to have_content("'Updated you' was successfully updated.")
            end
          end
        end
      end

      describe 'Previewing', js: true do
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

          it 'will show pages with inherited templates', js:true do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in 'Title', :with => 'Searchable'
            find('#toggle_advanced_options').trigger(:click)
            select 'Searchable', :from => 'View template'
            Timeout::timeout(5) do
              click_button 'Preview'
              sleep 0.1 and redo unless windows.many?
              expect_window_with_content('Form application/search_form')
            end
          end
        end

        context 'a brand new page' do
          it "will not save when just previewing", js:true do
            visit refinery.admin_pages_path

            find('a', text: 'Add new page').trigger(:click)
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
        context "when page can be deleted", js:true do
          before { Page.create :title => "Delete me" }

          it "will show delete button" do
            visit refinery.admin_pages_path

            find('a[tooltip="Remove this page forever"]').trigger(:click)

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

        describe "add a page with title for default locale", js:true do
          before do
            visit refinery.admin_pages_path
            find('a', text: "Add new page").trigger(:click)
            fill_in "Title", :with => "News"
            click_button "Save"
          end

          it "creates a page" do
            expect(page).to have_content("'News' was successfully added.")
            expect(Refinery::Page.count).to eq(2)
          end

          it "shows locale flag for page" do
            p = ::Refinery::Page.by_slug('news').first
            within "#page_#{p.id} .locales" do
              expect(page).to have_css('.locale_marker')
              expect(page).to have_content('EN')
            end
          end

          it "shows title in the admin menu" do
            p = ::Refinery::Page.by_slug('news').first
            within "#page_#{p.id}" do
              expect(page).to have_content('News')
              expect(page.find('a[tooltip="Edit this page"]')[:href]).to include('news')
            end
          end

          it "shows in frontend menu for 'en' locale" do
            # page.driver.debug
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

        describe "a page with two locales" do
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

          it "can have a title for each locale" do
            news_page.destroy!
            visit refinery.admin_pages_path

            click_link "Add new page"
            switch_page_form_locale "RU"

            fill_in "Title", :with => ru_page_title
            click_button "Save"
            expect(page).to have_selector("#page_#{Page.last.id} .actions")

            within "#page_#{Page.last.id} .actions" do
              find("a[href^='/#{Refinery::Core.backend_route}/pages/#{ru_page_slug_encoded}/edit']").click
            end

            switch_page_form_locale "EN"
            fill_in "Title", :with => en_page_title
            find("#submit_button").click

            expect(page).to have_content("'#{en_page_title}' was successfully updated.")
            expect(Refinery::Page.count).to eq(2)
          end

          it "is shown with both locales in the index" do
            visit refinery.admin_pages_path

            within "#page_#{news_page.id} .locales" do
              expect(page).to have_css('.locale_marker', count: 2)
              expect(page).to have_content('EN')
              expect(page).to have_content('RU')
            end
          end

          it "shows title in current admin locale in the index" do
            visit refinery.admin_pages_path

            within "#page_#{news_page.id}" do
              expect(page).to have_content(en_page_title)
            end
          end

          it "uses the slug from the default locale in admin", js: true do
            visit refinery.admin_pages_path

            within "#page_#{news_page.id}" do
              expect(page.find('a[tooltip="Edit this page"]')[:href]).to include(en_page_slug)
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

        describe "add a page with title only for secondary locale", js:true do
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

          it "lets you add a Russian title without an English title" do
            ru_page.destroy!
            find('a', text: 'Add new page').trigger(:click)
            switch_page_form_locale "RU"

            fill_in "Title", :with => ru_page_title
            click_button "Save"

            expect(page).to have_content("'#{ru_page_title}' was successfully added.")
            expect(Refinery::Page.count).to eq(2)
          end

          it "shows locale indicator for page" do
            within "#page_#{ru_page_id}" do
              expect(page).to have_selector('.locale_marker', text: 'RU')
            end
          end

          it "doesn't show locale indicator for primary locale" do
            within "#page_#{ru_page_id}" do
              expect(page).to_not have_selector('.locale_marker', text: 'EN')
            end
          end

          it "shows title in the admin menu" do
            within "#page_#{ru_page_id}" do
              expect(page).to have_content(ru_page_title)
            end
          end

          it "uses slug in admin" do
            within "#page_#{ru_page_id}" do
              expect(page.find('a[tooltip="Edit this page"]')[:href]).to include(ru_page_slug_encoded)
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
                Page.create :title => ru_page_title, :parent_id => parent_page.id
              }
              expect(sub_page.parent).to eq(parent_page)
              visit refinery.admin_pages_path
              within "#page_#{sub_page.id}" do
                find("a.edit_icon").trigger(:click)
              end
              fill_in "Title", :with => ru_page_title
              click_button "Save"
              expect(page).to have_content("'#{ru_page_title}' was successfully updated")
            end
          end
        end
      end

      describe "new page part" do
        before do
          allow(Refinery::Pages).to receive(:new_page_parts).and_return(true)
        end

        it "adds new page part", js: true do
          visit refinery.new_admin_page_path
          find("#add_page_part").trigger(:click)

          within "#new_page_part_dialog" do
            fill_in "new_page_part_title", :with => "testy"
            click_button "Save"
          end

          within "#page_parts" do
            expect(page).to have_content("testy")
          end
        end
      end

      describe "delete existing page part" do
        let!(:some_page) { Page.create! :title => "Some Page" }

        before do
          some_page.parts.create! :title => "First Part",  :slug => "first_part",  :position => 1
          some_page.parts.create! :title => "Second Part", :slug => "second_part", :position => 2
          some_page.parts.create! :title => "Third Part",  :slug => "third_part",  :position => 3

          allow(Refinery::Pages).to receive(:new_page_parts).and_return(true)
        end

        it "deletes page parts", js: true do
          visit refinery.edit_admin_page_path(some_page.id)

          within "#page_parts" do
            expect(page).to have_content("First Part")
            expect(page).to have_content("Second Part")
            expect(page).to have_content("Third Part")
          end

          2.times do
            find("#delete_page_part").trigger(:click)
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

            specify 'sub page should inherit them', js: true do
              visit refinery.edit_admin_page_path(@page.id)

              find('#toggle_advanced_options').trigger(:click)

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
      describe "a page part with HTML" do
        before do
          page = Refinery::Page.create! :title => "test"
          Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
            page.parts.create(
              title: default_page_part[:title],
              slug: default_page_part[:slug],
              body: "<header class='regression'>test</header>",
              position: index
            )
          end
        end

        specify "should retain the html", js:true do
          visit refinery.admin_pages_path
          find('a[tooltip="Edit this page"]').trigger(:click)
          Capybara.ignore_hidden_elements = false
          expect(page).to have_content("header class='regression'")
          Capybara.ignore_hidden_elements = true
        end
      end
    end

    describe "TranslatePages", :type => :feature do
      before { Globalize.locale = :en }
      refinery_login

      describe "a page with a single locale" do
        before do
          allow(Refinery::I18n).to receive(:frontend_locales).and_return([:en, :lv])
          Page.create :title => 'First Page'
        end

        it "can have a second locale added to it" do
          visit refinery.admin_pages_path

          click_link "Add new page"
          switch_page_form_locale "LV"

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
            page.parts.create(:title => default_page_part[:title], :slug => default_page_part[:slug], :body => nil, :position => index)
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
