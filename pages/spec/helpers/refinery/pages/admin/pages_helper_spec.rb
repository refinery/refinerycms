require "spec_helper"

module Refinery
  module Admin
    describe PagesHelper do
      describe "#template_options" do
        context "when page layout/view template is set" do
          it "returns those templates as selected" do
            page = FactoryGirl.create(:page)

            page.view_template = "rspec_template"
            helper.template_options(:view_template, page).should eq(:selected => "rspec_template")

            page.layout_template = "rspec_layout"
            helper.template_options(:layout_template, page).should eq(:selected => "rspec_layout")
          end
        end

        context "when page layout template is set using symbols" do
          before do
            Pages.config.stub(:layout_template_whitelist).and_return [:three, :one, :two]
          end

          it "works as expected" do
            page = FactoryGirl.create(:page, :layout_template => "three")

            helper.template_options(:layout_template, page).should eq(:selected => 'three')
          end
        end

        context "when page layout template isn't set" do
          context "when page has parent and parent has layout_template set" do
            it "returns parent layout_template as selected" do
              parent = FactoryGirl.create(:page, :layout_template => "rspec_layout")
              page = FactoryGirl.create(:page, :parent_id => parent.id)

              expected_layout = { :selected => parent.layout_template }
              helper.template_options(:layout_template, page).should eq(expected_layout)
            end
          end

          context "when page doesn't have parent page" do
            it "returns default application template" do
              page = FactoryGirl.create(:page)

              expected_layout = { :selected => "application" }
              helper.template_options(:layout_template, page).should eq(expected_layout)
            end
          end
        end
      end

      describe "#page_meta_information" do
        let(:page) { FactoryGirl.build(:page) }

        context "when show_in_menu is false" do
          it "adds 'hidden' label" do
            page.show_in_menu = false

            helper.page_meta_information(page).should eq(
              %Q{<span class="label">#{::I18n.t('refinery.admin.pages.page.hidden')}</span>}
            )
          end
        end

        context "when draft is true" do
          it "adds 'draft' label" do
            page.draft = true

            helper.page_meta_information(page).should eq(
              %Q{<span class="label notice">#{::I18n.t('refinery.admin.pages.page.draft')}</span>}
            )
          end
        end
      end

      describe "#page_title_with_translations" do
        let(:page) { FactoryGirl.build(:page) }

        before do
          Globalize.with_locale(:en) do
            page.title = "draft"
            page.save!
          end

          Globalize.with_locale(:lv) do
            page.title = "melnraksts"
            page.save!
          end
        end

        context "when title is present" do
          it "returns it" do
            helper.page_title_with_translations(page).should eq("draft")
          end
        end

        context "when title for current locale isn't available" do
          it "returns existing title from translations" do
            Page.translation_class.where(:locale => :en).first.destroy
            helper.page_title_with_translations(page).should eq("melnraksts")
          end
        end
      end
    end
  end
end
