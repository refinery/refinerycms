require "spec_helper"

module Refinery
  describe "menu", type: :feature do
    refinery_login

    before do
      visit Refinery::Core.backend_path
    end

    describe "sidebar" do
      before do
        allow(Refinery::Core).to receive(:site_name).and_return('Company Name')
      end

      context "when hover", js: true do
        before do
          visit Refinery::Core.backend_path
          page.execute_script('$("#sidebar-left").trigger("mouseenter")')
        end

        it "has site_name link" do
          within('#sidebar-left') do
            expect(page).to have_selector("a[href='/']")
            expect(page).to have_content('Company Name')
          end
        end

        describe "menu item" do
          it "has a fullname" do
            within('#sidebar-left') do
              expect(page).to have_selector("a[href='/refinery/pages']")
              expect(page).to have_selector("i.icon.icon-pages")
              expect(page).to have_content("PAGES")
            end
          end
        end

        describe "logout link" do
          let(:logout_path) { '/refinery/logout' }

          context "when set" do
            before do
              allow(Refinery::Core).to receive(:refinery_logout_path).and_return(logout_path)
              visit Refinery::Core.backend_path
              page.execute_script('$("#sidebar-left").trigger("mouseenter")')
            end

            it "is present" do
              within('#sidebar-left') do
                expect(page).to have_selector("a[href='#{logout_path}']")
                expect(page).to have_content("Log out")
              end
            end
          end

          context "when not set" do
            it "is not present" do
              within('#sidebar-left') do
                expect(page).not_to have_content("Log out")
                expect(page).not_to have_selector("a[href='#{logout_path}']")
              end
            end
          end
        end
      end

      context "when not hover" do
        before do
          visit Refinery::Core.backend_path
        end

        it "has no site_name link" do
          within('#sidebar-left') do
            expect(page).to have_selector("a[href='/']")
            expect(page).to have_content('Company Name')
          end
        end

        describe "menu item" do
          it "has an icon only" do
            within('#sidebar-left') do
              expect(page).to have_selector("a[href='/refinery/pages']")
              expect(page).to have_selector("i.icon.icon-pages")
              expect(page).not_to have_content("PAGES")
            end
          end
        end
      end

      describe "menu item" do
        context "when backend root page" do
          it "has one active link" do
            within('#sidebar-left') do
              expect(page).to have_selector("ul.menu-items li a.active", count: 1)
            end
          end
        end
      end
    end
  end
end
