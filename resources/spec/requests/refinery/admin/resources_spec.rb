# Encoding: UTF-8
require "spec_helper"

module Refinery
  module Admin
    describe "Resources" do
      refinery_login_with :refinery_user

      context "when no files" do
        it "invites to upload file" do
          visit refinery.admin_resources_path
          page.should have_content(%q{There are no files yet. Click "Upload new file" to add your first file.})
        end
      end

      it "shows upload file link" do
        visit refinery.admin_resources_path
        page.should have_content("Upload new file")
        page.should have_selector("a[href*='/refinery/resources/new']")
      end


      context "new/create" do
        it "uploads file", :js => true do
          visit refinery.admin_resources_path
          click_link "Upload new file"

          page.should have_selector 'iframe#dialog_iframe'

          page.within_frame('dialog_iframe') do
            attach_file "resource_file", Refinery.roots(:'refinery/resources').
                                                  join("spec/fixtures/refinery_is_awesome.txt")
            click_button ::I18n.t('save', :scope => 'refinery.admin.form_actions')
          end

          page.should have_content("Refinery Is Awesome.txt")
          Refinery::Resource.count.should == 1
        end

        describe "max file size" do
          before do
            Refinery::Resources.stub(:max_file_size).and_return('1224')
          end

          context "in english" do
            before do
              Refinery::I18n.stub(:current_locale).and_return(:en)
            end

            it "is shown" do
              visit refinery.admin_resources_path
              click_link "Upload new file"

              within('#maximum_file_size') do
                page.should have_content "1.2 KB"
              end
            end
          end

          context "in danish" do
            before do
              Refinery::I18n.stub(:current_locale).and_return(:da)
            end
              
            it "is shown" do
              visit refinery.admin_resources_path

              click_link "Tilføj en ny fil"
              within "#maximum_file_size" do
                page.should have_content "1,2 KB"
              end
            end
          end
        end
      end

      context "edit/update" do
        let!(:resource) { FactoryGirl.create(:resource) }

        it "updates file" do
          visit refinery.admin_resources_path
          page.should have_content("Refinery Is Awesome.txt")
          page.should have_selector("a[href='/refinery/resources/#{resource.id}/edit']")

          click_link "Edit this file"

          page.should have_content("Download current file or replace it with this one...")
          page.should have_selector("a[href*='/refinery/resources']")

          attach_file "resource_file", Refinery.roots(:'refinery/resources').join("spec/fixtures/refinery_is_awesome2.txt")
          click_button "Save"

          page.should have_content("Refinery Is Awesome2")
          Refinery::Resource.count.should == 1
        end
      end

      context "destroy" do
        let!(:resource) { FactoryGirl.create(:resource) }

        it "removes file" do
          visit refinery.admin_resources_path
          page.should have_selector("a[href='/refinery/resources/#{resource.id}']")

          click_link "Remove this file forever"

          page.should have_content("'Refinery Is Awesome' was successfully removed.")
          Refinery::Resource.count.should == 0
        end
      end

      context "download" do
        let!(:resource) { FactoryGirl.create(:resource) }

        it "succeeds" do
          visit refinery.admin_resources_path

          click_link "Download this file"

          page.should have_content("http://www.refineryhq.com/")
        end

        context 'when the extension is mounted with a named space' do
          before do
            Rails.application.routes.draw do
              mount Refinery::Core::Engine, :at => "/about"
            end
            Rails.application.routes_reloader.reload!
          end

          after do
            Rails.application.routes.draw do
              mount Refinery::Core::Engine, :at => "/"
            end
          end

          it "succeeds" do
            visit refinery.admin_resources_path

            click_link "Download this file"

            page.should have_content("http://www.refineryhq.com/")
          end

        end
      end
    end
  end
end
