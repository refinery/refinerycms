# encoding: utf-8
require "spec_helper"

def new_window_should_have_content(content)
  new_window = page.driver.browser.window_handles.last
  page.within_window new_window do
    page.should have_content(content)
  end
end

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

          page.body.should =~ /Remove this page forever/
          page.body.should =~ /Edit this page/
          page.body.should =~ %r{/refinery/pages/my-first-page/edit}
          page.body.should =~ /Add a new child page/
          page.body.should =~ %r{/refinery/pages/new\?parent_id=}
          page.body.should =~ /View this page live/
          page.body.should =~ %r{/pages/my-first-page}

          Refinery::Page.count.should == 1
        end

        it "includes menu title field" do
          visit refinery.new_admin_page_path

          fill_in "Title", :with => "My first page"
          fill_in "Menu title", :with => "The first page"

          click_button "Save"

          page.should have_content("'My first page' was successfully added.")
          page.body.should =~ %r{/pages/the-first-page}
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

            new_window_should_have_content("Some changes I'm unsure what they will look like")
          end

          it 'will not save the preview changes', :js => true do
            visit refinery.admin_pages_path

            find('a[tooltip^=Edit]').click
            fill_in "Title", :with => "Some changes I'm unsure what they will look like"
            click_button "Preview"

            new_window_should_have_content("Some changes I'm unsure what they will look like")

            Page.by_title("Some changes I'm unsure what they will look like").should be_empty
          end

        end

        context 'a brand new page' do
          it "will not save when just previewing", :js => true do
            visit refinery.admin_pages_path

            click_link "Add new page"
            fill_in "Title", :with => "My first page"
            click_button "Preview"

            new_window_should_have_content("My first page")

            Page.count.should == 0
          end
        end

        context 'a nested page' do
          let!(:parent_page) { FactoryGirl.create(:page, :title => "Our Parent Page") }
          let!(:nested_page) { FactoryGirl.create(:page, :parent => @parent, :title => 'Preview Me') }

          it "works like an un-nested page", :js => true do
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
              page.should have_css('a', :href => 'news')
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
          let(:ru_page_slug) { 'новости' }
          let(:ru_page_slug_encoded) { '%D0%BD%D0%BE%D0%B2%D0%BE%D1%81%D1%82%D0%B8' }
          let!(:news_page) do
            Refinery::I18n.stub(:frontend_locales).and_return([:en, :ru])

            _page = Globalize.with_locale(:en) {
              FactoryGirl.create(:page, :title => en_page_title)
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
            click_button "Save"

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
              FactoryGirl.create(:page, :title => ru_page_title)
            }
          }
          let(:ru_page_id) { ru_page.id }
          let(:ru_page_title) { 'Новости' }
          let(:ru_page_slug) { 'новости' }

          before(:each) do
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
              page.should have_css('a', :href => ru_page_slug)
            end
          end

          it "won't show in frontend menu for 'en' locale" do
            visit "/"

            within "#menu" do
              # we should only have the home page in the menu
              page.should have_css('li', :count => 1)
            end
          end
        end
      end

      describe "new page part", :js => true do
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

      describe 'advanced options' do
        describe 'view and layout templates' do
          context 'when parent page has templates set' do
            before(:each) do
              Refinery::Pages.stub(:use_layout_templates).and_return(true)
              Refinery::Pages.stub(:use_view_templates).and_return(true)
              Refinery::Pages.stub(:layout_template_whitelist).and_return(['abc', 'refinery'])
              Refinery::Pages.stub(:view_template_whitelist).and_return(['abc', 'refinery'])
              Refinery::Pages.stub(:valid_templates).and_return(['abc', 'refinery'])
              parent_page = FactoryGirl.create(:page, :view_template => 'refinery',
                                                      :layout_template => 'refinery')
              parent_page.children.create(FactoryGirl.attributes_for(:page))
            end

            specify 'sub page should inherit them' do
              visit refinery.admin_pages_path

              within '.nested' do
                click_link 'Edit this page'
              end

              within '#page_layout_template' do
                page.find('option[value=refinery]').selected?.should eq('selected')
              end

              within '#page_view_template' do
                page.find('option[value=refinery]').selected?.should eq('selected')
              end
            end
          end
        end
      end
    end

    describe "TranslatePages" do
      login_refinery_translator

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
        before(:each) do
          Refinery::I18n.stub(:frontend_locales).and_return([:en, :lv])
          FactoryGirl.create(:page)
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
        before(:each) { FactoryGirl.create(:page) }

        it "doesn't succeed" do
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
            before(:each) { Refinery::Pages.absolute_page_links = false }

            it "shows Russian pages if we're editing the Russian locale" do
              visit 'refinery/pages_dialogs/link_to?wymeditor=true&switch_locale=ru'

              page.should have_content("About Ru")
              page.should have_selector("a[href='/ru/about-ru']")
            end

            it "shows default to the default locale if no query string is added" do
              visit 'refinery/pages_dialogs/link_to?wymeditor=true'

              page.should have_content("About")
              page.should have_selector("a[href='/about']")
            end
          end

          describe "with absolute urls" do
            before(:each) { Refinery::Pages.absolute_page_links = true }

            it "shows Russian pages if we're editing the Russian locale" do
              visit 'refinery/pages_dialogs/link_to?wymeditor=true&switch_locale=ru'

              page.should have_content("About Ru")
              page.should have_selector("a[href='http://www.example.com/ru/about-ru']")
            end

            it "shows default to the default locale if no query string is added" do
              visit 'refinery/pages_dialogs/link_to?wymeditor=true'

              page.should have_content("About")
              page.should have_selector("a[href='http://www.example.com/about']")
            end
          end

          # see https://github.com/resolve/refinerycms/pull/1583
          context "when switching locales" do
            specify "dialog has correct links", :js => true do
              visit refinery.edit_admin_page_path(about_page)

              click_link "Add Link"

              page.within_frame("dialog_frame") do
                page.should have_content("About")
                page.should have_css("a[href='/about']")

                click_link "cancel_button"
              end

              within "#switch_locale_picker" do
                click_link "Ru"
              end

              click_link "Add Link"

              page.within_frame("dialog_frame") do
                page.should have_content("About Ru")
                page.should have_css("a[href='/ru/about-ru']")
              end
            end
          end
        end
      end
    end
  end
end
