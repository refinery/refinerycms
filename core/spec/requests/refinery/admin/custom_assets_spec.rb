require "spec_helper"

module Refinery
  describe "custom" do
    login_refinery_user

    context "javascripts" do
      before(:each) do
        ::Refinery::Core.clear_javascripts!
      end

      it "should be rendered when specified" do
        ::Refinery::Core.register_javascript('custom_js')
        visit refinery_admin_dashboard_path
        page.body.include?('custom_js.js').should be
      end
    end

    context "stylesheets" do
      before(:each) do
        ::Refinery::Core.clear_stylesheets!
      end

      it "should be rendered when specified" do
        ::Refinery::Core.register_stylesheet('custom_css')
        visit refinery_admin_dashboard_path
        page.body.include?('custom_css.css').should be
      end
    end

  end
end
