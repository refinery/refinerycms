require "spec_helper"

module Refinery
  describe "custom", :type => :feature do
    refinery_login_with :refinery_user
    after do
      Refinery::Core.javascripts.reject! {|j| %w[custom_js].include?(j) }
      Refinery::Core.stylesheets.reject! {|s| %w[custom_css].include?(s.path) }
    end

    context "javascripts" do
      it "should be rendered when specified" do
        ::Refinery::Core.config.register_javascript('custom_js')
        visit refinery.admin_dashboard_path
        expect(page.body.include?('custom_js.js')).to be
      end
    end

    context "stylesheets" do
      it "should be rendered when specified" do
        ::Refinery::Core.config.register_stylesheet('custom_css')
        visit refinery.admin_dashboard_path
        expect(page.body.include?('custom_css.css')).to be
      end
    end

  end
end
