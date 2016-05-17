require "spec_helper"

module Refinery
  module Admin
    describe PagesHelper, :type => :helper do
      describe "#template_options" do
        context "when page layout/view template is set" do
          it "returns those templates as selected" do
            page = FactoryGirl.create(:page)

            page.view_template = "rspec_template"
            expect(helper.template_options(:view_template, page)).to eq(:selected => "rspec_template")

            page.layout_template = "rspec_layout"
            expect(helper.template_options(:layout_template, page)).to eq(:selected => "rspec_layout")
          end
        end

        context "when page layout template is set using symbols" do
          before do
            allow(Pages.config).to receive(:layout_template_whitelist).and_return [:three, :one, :two]
          end

          it "works as expected" do
            page = FactoryGirl.create(:page, :layout_template => "three")

            expect(helper.template_options(:layout_template, page)).to eq(:selected => 'three')
          end
        end

        context "when page layout template isn't set" do
          context "when page has parent and parent has layout_template set" do
            it "returns parent layout_template as selected" do
              parent = FactoryGirl.create(:page, :layout_template => "rspec_layout")
              page = FactoryGirl.create(:page, :parent_id => parent.id)

              expected_layout = { :selected => parent.layout_template }
              expect(helper.template_options(:layout_template, page)).to eq(expected_layout)
            end
          end

          context "when page doesn't have parent page" do
            it "returns default application template" do
              page = FactoryGirl.create(:page)

              expected_layout = { :selected => "application" }
              expect(helper.template_options(:layout_template, page)).to eq(expected_layout)
            end
          end
        end
      end

      describe "#page_meta_information" do
        let(:page) { FactoryGirl.build(:page) }

        context "when show_in_menu is false" do
          it "adds 'hidden' label" do
            page.show_in_menu = false

            expect(helper.page_meta_information(page)).to eq(
              %Q{<span class="label">#{::I18n.t('refinery.admin.pages.page.hidden')}</span>}
            )
          end
        end

        context "when skip_to_first_child is true" do
          it "adds 'skip to first child' label" do
            page.skip_to_first_child = true

            expect(helper.page_meta_information(page)).to eq(
              %Q{<span class="label">#{::I18n.t('refinery.admin.pages.page.skip_to_first_child')}</span>}
            )
          end
        end

        context "when link_url is present" do
          it "adds 'redirected' label" do
            page.link_url = '/redirect'

            expect(helper.page_meta_information(page)).to eq(
              %Q{<span class="label">#{::I18n.t('refinery.admin.pages.page.redirected')}</span>}
            )
          end
        end

        context "when draft is true" do
          it "adds 'draft' label" do
            page.draft = true

            expect(helper.page_meta_information(page)).to eq(
              %Q{<span class="label notice">#{::I18n.t('refinery.admin.pages.page.draft')}</span>}
            )
          end
        end
      end
    end
  end
end
