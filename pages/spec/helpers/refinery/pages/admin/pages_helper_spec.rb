require "spec_helper"

module Refinery
  module Admin
    describe PagesHelper do
      describe "#template_options" do
        context "when page layout/view template is set" do
          it "returns empty hash" do
            page = FactoryGirl.create(:page)

            page.view_template = "rspec_template"
            helper.template_options(:view_template, page).should eq({})

            page.layout_template = "rspec_layout"
            helper.template_options(:layout_template, page).should eq({})
          end
        end

        context "when page layout/view template is set using symbols" do
          before do
            Pages.config.stub(:view_template_whitelist).and_return [:one, :two, :three]
            Pages.config.stub(:layout_template_whitelist).and_return [:three, :one, :two]
          end

          it "works as expected" do
            page = FactoryGirl.create(:page)

            helper.template_options(:view_template, page).should eq(:selected => 'one' )
            helper.template_options(:layout_template, page).should eq(:selected => 'three')
          end
        end

        context "when page layout/view template isn't set" do
          context "when page has parent" do
            it "returns option hash based on parent page" do
              parent = FactoryGirl.create(:page, :view_template => "rspec_view",
                                                 :layout_template => "rspec_layout")
              page = FactoryGirl.create(:page, :parent_id => parent.id)

              expected_view = { :selected => parent.view_template }
              helper.template_options(:view_template, page).should eq(expected_view)

              expected_layout = { :selected => parent.layout_template }
              helper.template_options(:layout_template, page).should eq(expected_layout)
            end
          end

          context "when page doesn't have parent page" do
            before do
              Pages.config.stub(:view_template_whitelist).and_return %w(one two)
              Pages.config.stub(:layout_template_whitelist).and_return %w(two one)
            end

            it "returns option hash with first item from configured whitelist" do
              page = FactoryGirl.create(:page)

              expected_view = { :selected => "one" }
              helper.template_options(:view_template, page).should eq(expected_view)

              expected_layout = { :selected => "two" }
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

            helper.page_meta_information(page).should eq("<span class=\"label\">hidden</span>")
          end
        end

        context "when draft is true" do
          it "adds 'draft' label" do
            page.draft = true

            helper.page_meta_information(page).should eq("<span class=\"label notice\">draft</span>")
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
            Refinery::Page::Translation.where(:locale => :en).first.delete
            helper.page_title_with_translations(page).should eq("melnraksts")
          end
        end
      end
    end
  end
end
