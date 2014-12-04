require "spec_helper"

module Refinery
  describe "custom", :type => :feature do
    refinery_login_with :refinery_user
    after do
      Refinery::Core.javascripts.reject! { |j| %w[custom_js].include?(j) }
      Refinery::Core.stylesheets.reject! { |s| %w[custom_css].include?(s.path) }
    end

    context "javascripts" do
      before do
        ::Refinery::Core.config.register_javascript('custom_js')
      end

      it "should be rendered when specified" do
        visit Refinery::Core.backend_path
        expect(page.body.include?('custom_js.js')).to be
      end
    end

    context "stylesheets" do
      before do
        ::Refinery::Core.config.register_stylesheet('custom_css')
      end

      it "should be rendered when specified" do
        visit Refinery::Core.backend_path
        expect(page.body).to include('custom_css.css')
      end
    end

  end
end
