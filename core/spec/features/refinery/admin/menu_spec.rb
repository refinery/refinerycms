require "spec_helper"

module Refinery
  describe "Menu", type: :feature do
    refinery_login

    before do
      visit Refinery::Core.backend_path
    end

    describe "Sidebar" do
      before do
        allow(Refinery::Core).to receive(:site_name).and_return('Company Name')
      end

      context "When hovering", js: true do
        before do
          visit Refinery::Core.backend_path
          page.find('#sidebar-left').hover
        end

        describe "Site Name link" do
          
          it "is visible" do
            within('#sidebar-left') do
              expect(page).to have_link('Company Name', href: '/', visible: true)
            end
          end
        end

        describe "Menu" do
          it "has one active link" do
            within('#sidebar-left') do
              expect(page).to have_selector("ul.menu-items li a.active", count: 1)
            end
          end
        end

        describe "Menu Item" do
          it "is visible" do
            within('#sidebar-left') do
              expect(page).to have_link('Pages', href: '/refinery/pages', visible: true)
            end
          end
        end

        describe "Logout Link" do
          let(:logout_path) { '/refinery/logout' }

          context "When logout path set" do
            before do
              allow(Refinery::Core).to receive(:refinery_logout_path).and_return(logout_path)
              visit Refinery::Core.backend_path
            end

            it "is visible" do
              within('#sidebar-left') do
                expect(page).to have_link('Log out', href: logout_path, visible: true)
              end
            end
          end

          context "When logout path not set" do
            it "is not visible" do
              within('#sidebar-left') do
                expect(page).not_to have_link("Log out", href: logout_path)
              end
            end
          end
        end
      end

      context "When not hovering" do
        before do
          visit Refinery::Core.backend_path
        end

        describe 'Site Name link' do
          it "is not visible" do
            within('#sidebar-left') do
              expect(page).to have_link('Company Name', href: '/', visible: false)
            end
          end
        end

        describe "Menu item" do
          it "is not visible" do
            within('#sidebar-left') do
              expect(page).to have_link('Pages', href: '/refinery/pages', visible: false)
            end
          end
        end
      end
    end
  end
end
