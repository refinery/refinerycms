require "spec_helper"

module Refinery
  describe "custom" do
    refinery_login_with :refinery_user
    after do
      Refinery::Core.javascripts.reject! {|j| %w[custom_js].include?(j) }
      Refinery::Core.stylesheets.reject! {|s| %w[custom_css].include?(s.path) }
    end

    context "javascripts" do
      it "should be rendered when specified" do
        ::Refinery::Core.config.register_javascript('custom_js')
        visit refinery.admin_dashboard_path
        page.body.include?('custom_js.js').should be
      end
    end

    context "stylesheets" do
      it "should be rendered when specified" do
        ::Refinery::Core.config.register_stylesheet('custom_css')
        visit refinery.admin_dashboard_path
        page.body.include?('custom_css.css').should be
      end
    end

  end
end
