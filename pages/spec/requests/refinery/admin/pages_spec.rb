# encoding: utf-8
require "spec_helper"

module Refinery
  module Admin
    describe "Pages" do
      login_refinery_user

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
          before(:each) { 2.times { FactoryGirl.create(:page) } }

          it "shows reorder pages link" do
            visit refinery.admin_pages_path

            within "#actions" do
              page.should have_content("Reorder pages")
              page.should have_selector("a[href='/refinery/pages']")
            end
          end
        end

        context "when sub pages exist" do
          let(:company) { FactoryGirl.create(:page, :title => "Our Company") }
          let(:team) { FactoryGirl.create(:page, :parent => company, :title => 'Our Team') }
          let(:locations) { FactoryGirl.create(:page, :parent => company, :title => 'Our Locations')}
          let(:location) { FactoryGirl.create(:page, :parent => locations, :title => 'New York') }

          context "with auto expand option turned off" do
            before do
              Refinery::Pages.auto_expand_admin_tree = false

              # Pre load pages
              location
              team

              visit refinery.admin_pages_path
            end

            it "show parent page" do

              page.should have_content(company.title)
            end

            it "doesn't show children" do
              page.should_not have_content(team.title)
              page.should_not have_content(locations.title)
            end

            it "expands children", :js => true do
              find(".toggle").click

              page.should have_content(team.title)
              page.should have_content(locations.title)
            end

            it "expands children when nested mutliple levels deep", :js => true do
              find("#page_#{company.id} .toggle").click
              find("#page_#{locations.id} .toggle").click

              page.should have_content("New York")
            end
          end

          context "with auto expand option turned on" do
            before do
              Refinery::Pages.auto_expand_admin_tree = true

              # Pre load pages
              location
              team

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
          # TODO: figure out why these matchers fail?
          # page.should have_content("Remove this page forever")
          # page.should have_selector("a[href='/refinery/pages/my-first-page']")
          # page.should have_content("Edit this page")
          # page.should have_selector("a[href='/refinery/pages/my-first-page/edit']")
          # page.should have_content("Add a new child page")
          # page.should have_selector("a[href*='/refinery/pages/new?parent_id=']")
          # page.should have_content("View this page live")
          # page.should have_selector("a[href='/pages/my-first-page']")
          page.body.should =~ /Remove this page forever/
          page.body.should =~ /Edit this page/
          page.body.should =~ /\/refinery\/pages\/my-first-page\/edit/
          page.body.should =~ /Add a new child page/
          page.body.should =~ /\/refinery\/pages\/new\?parent_id=/
          page.body.should =~ /View this page live/
          page.body.should =~ /\/pages\/my-first-page/

          Refinery::Page.count.should == 1
        end
      end

      describe "edit/update" do
        before(:each) { FactoryGirl.create(:page, :title => "Update me") }

        it "updates page" do
          visit refinery.admin_pages_path

          page.should have_content("Update me")

          click_link "Edit this page"

          fill_in "Title", :with => "Updated"
          click_button "Save"

          page.should have_content("'Updated' was successfully updated.")
        end
      end

      describe 'Previewing' do
        context "an existing page" do
          before(:each) { FactoryGirl.create(:page, :title => 'Preview me') }

          it 'will show the preview changes in a new window', :js => true do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in "Title", :with => "Some changes I'm unsure what they will look like"
            click_button "Preview"

            new_window = page.driver.browser.window_handles.last
            page.within_window new_window do
              page.should have_content("Some changes I'm unsure what they will look like")
            end

          end

          it 'will not save the preview changes', :js => true do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in "Title", :with => "Some changes I'm unsure what they will look like"
            click_button "Preview"

            Page.last.title.should_not == "Some changes I'm unsure what they will look like"
          end

        end

        context 'a brand new page' do
          it "will not save when just previewing", :js => true do
            visit refinery.admin_pages_path

            click_link "Add new page"
            fill_in "Title", :with => "My first page"
            click_button "Preview"

            Page.count.should == 0
          end
        end

        context 'a nested page' do
          let!(:parent_page) { FactoryGirl.create(:page, :title => "Our Parent Page") }
          let!(:nested_page) { FactoryGirl.create(:page, :parent => @parent, :title => 'Preview Me') }

          it "should work like an un-nested page", :js => true do
            visit refinery.admin_pages_path

            within "#page_#{nested_page.id}" do
              find('a[tooltip^=Edit]').click
            end

            fill_in "Title", :with => "Some changes I'm unsure what they will look like"
            click_button "Preview"

            new_window = page.driver.browser.window_handles.last
            page.within_window new_window do
              page.should have_content("Some changes I'm unsure what they will look like")
            end
          end
        end
      end

      describe "destroy" do
        context "when page can be deleted" do
          before(:each) { FactoryGirl.create(:page, :title => "Delete me") }

          it "will show delete button" do
            visit refinery.admin_pages_path

            click_link "Remove this page forever"

            page.should have_content("'Delete me' was successfully removed.")

            Refinery::Page.count.should == 0
          end
        end

        context "when page can't be deleted" do
          before(:each) { FactoryGirl.create(:page, :title => "Indestructible", :deletable => false) }

          it "wont show delete button" do
            visit refinery.admin_pages_path

            page.should have_no_content("Remove this page forever")
            page.should have_no_selector("a[href='/refinery/pages/indestructible']")
          end
        end
      end

      context "duplicate page titles" do
        before(:each) { FactoryGirl.create(:page, :title => "I was here first") }

        it "will append nr to url path" do
          visit refinery.new_admin_page_path

          fill_in "Title", :with => "I was here first"
          click_button "Save"

          Refinery::Page.last.url[:path].should == ["i-was-here-first--2"]
        end
      end

      context "with translations" do
        before(:each) do
          Refinery::I18n.stub(:frontend_locales).and_return([:en, :ru])

          # Create a home page in both locales (needed to test menus)
          home_page = FactoryGirl.create(:page, :title => 'Home',
                                                :link_url => '/',
                                                :menu_match => "^/$")
          Globalize.locale = :ru
          home_page.title = 'Домашняя страница'
          home_page.save
          Globalize.locale = :en
        end

        describe "add a page with title for default locale" do
          before do
            visit refinery.admin_pages_path
            click_link "Add new page"
            fill_in "Title", :with => "News"
            click_button "Save"
          end

          it "should succeed" do
            page.should have_content("'News' was successfully added.")
            Refinery::Page.count.should == 2
          end

          it "should show locale flag for page" do
            p = ::Refinery::Page.find('news')
            within "#page_#{p.id}" do
              page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
            end
          end

          it "should show title in the admin menu" do
            p = ::Refinery::Page.find('news')
            within "#page_#{p.id}" do
              page.should have_content('News')
              page.find_link('Edit this page')[:href].should include('news')
            end
          end

          it "should show in frontend menu for 'en' locale" do
            visit "/"

            within "#menu" do
              page.should have_content('News')
              page.should have_css('a', :href => 'news')
            end
          end

          it "should not show in frontend menu for 'ru' locale" do
            visit "/ru"

            within "#menu" do
              # we should only have the home page in the menu
              page.should have_css('li', :count => 1)
            end
          end
        end

        describe "add a page with title for both locales" do
          before do
            visit refinery.admin_pages_path
            click_link "Add new page"
            within "#switch_locale_picker" do
              click_link "Ru"
            end
            fill_in "Title", :with => "Новости"
            click_button "Save"

            p = ::Refinery::Page.last
            within "#page_#{p.id}" do
              click_link "Application_edit"
            end
            within "#switch_locale_picker" do
              click_link "En"
            end
            fill_in "Title", :with => "News"
            click_button "Save"
          end

          it "should succeed" do
            page.should have_content("'News' was successfully updated.")
            Refinery::Page.count.should == 2
          end

          it "should show both locale flags for page" do
            p = ::Refinery::Page.find('news')
            within "#page_#{p.id}" do
              page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
              page.should have_css("img[src='/assets/refinery/icons/flags/ru.png']")
            end
          end

          it "should show title in admin menu in current admin locale" do
            p = ::Refinery::Page.find('news')
            within "#page_#{p.id}" do
              page.should have_content('News')
            end
          end

          it "should use the slug from the default locale in admin" do
            p = ::Refinery::Page.find('news')
            within "#page_#{p.id}" do
              page.find_link('Edit this page')[:href].should include('news')
            end
          end

          it "should show correct language and slugs for default locale" do
            visit "/"

            within "#menu" do
              page.find_link('News')[:href].should include('news')
            end
          end

          it "should show correct language and slugs for second locale" do
            visit "/ru"

            within "#menu" do
              page.find_link('Новости')[:href].should include('%D0%BD%D0%BE%D0%B2%D0%BE%D1%81%D1%82%D0%B8')
            end
          end
        end

        describe "add a page with title only for secondary locale" do
          before do
            visit refinery.admin_pages_path
            click_link "Add new page"
            within "#switch_locale_picker" do
              click_link "Ru"
            end
            fill_in "Title", :with => "Новости"
            click_button "Save"
          end

          it "should succeed" do
            page.should have_content("'Новости' was successfully added.")
            Refinery::Page.count.should == 2
          end

          it "should show locale flag for page" do
            p = ::Refinery::Page.find('новости')
            within "#page_#{p.id}" do
              page.should have_css("img[src='/assets/refinery/icons/flags/ru.png']")
            end
          end

          it "should not show locale flag for primary locale" do
            p = ::Refinery::Page.find('новости')
            within "#page_#{p.id}" do
              page.should_not have_css("img[src='/assets/refinery/icons/flags/en.png']")
            end
          end

          it "should show title in the admin menu" do
            p = ::Refinery::Page.find('новости')
            within "#page_#{p.id}" do
              page.should have_content('Новости')
            end
          end

          it "should use ID instead of slug in admin" do
            p = ::Refinery::Page.find('новости')
            within "#page_#{p.id}" do
              page.find_link('Edit this page')[:href].should include(p.id.to_s)
            end
          end

          it "should show in frontend menu for 'ru' locale" do
            visit "/ru"

            within "#menu" do
              page.should have_content('Новости')
              page.should have_css('a', :href => 'новости')
            end
          end

          it "should not show in frontend menu for 'en' locale" do
            visit "/"

            within "#menu" do
              # we should only have the home page in the menu
              page.should have_css('li', :count => 1)
            end
          end
        end
      end
    end

    describe "TranslatePages" do
      login_refinery_translator

      describe "add page to main locale" do
        it "should not succeed" do
          visit refinery.admin_pages_path

          click_link "Add new page"

          fill_in "Title", :with => "Huh?"
          click_button "Save"

          page.should have_content("You do not have the required permission to modify pages in this language")
        end
      end

      describe "add page to second locale" do
        before(:each) do
          Refinery::I18n.stub(:frontend_locales).and_return([:en, :lv])
          FactoryGirl.create(:page)
        end

        it "should succeed" do
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
        before(:each) { FactoryGirl.create(:page) }

        it "should not succeed" do
          visit refinery.admin_pages_path

          click_link "Remove this page forever"

          page.should have_content("You do not have the required permission to modify pages in this language.")
          Refinery::Page.count.should == 1
        end
      end

      describe "Pages Link-to Dialog" do
        before do
          Refinery::I18n.frontend_locales = [:en, :ru]

          # Create a page in both locales
          about_page = FactoryGirl.create(:page, :title => 'About')
          Globalize.locale = :ru
          about_page.title = 'About Ru'
          about_page.save
          Globalize.locale = :en
        end

        describe "adding page link" do
          describe "with relative urls" do
            before(:each) { Refinery::Pages.absolute_page_links = false }

            it "should show Russian pages if we're editing the Russian locale" do
              visit 'refinery/pages_dialogs/link_to?wymeditor=true&switch_locale=ru'

              page.should have_content("About Ru")
              page.should have_selector("a[href='/ru/about-ru']")
            end

            it "should show default to the default locale if no query string is added" do
              visit 'refinery/pages_dialogs/link_to?wymeditor=true'

              page.should have_content("About")
              page.should have_selector("a[href='/about']")
            end
          end
          describe "with absolute urls" do
            before(:each) { Refinery::Pages.absolute_page_links = true }

            it "should show Russian pages if we're editing the Russian locale" do
              visit 'refinery/pages_dialogs/link_to?wymeditor=true&switch_locale=ru'

              page.should have_content("About Ru")
              page.should have_selector("a[href='http://www.example.com/ru/about-ru']")
            end

            it "should show default to the default locale if no query string is added" do
              visit 'refinery/pages_dialogs/link_to?wymeditor=true'

              page.should have_content("About")
              page.should have_selector("a[href='http://www.example.com/about']")
            end
          end
        end
      end
    end
  end
end
