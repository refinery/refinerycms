require "spec_helper"

module Refinery
  describe "custom", type: :feature do
    refinery_login

    let(:custom_js){ Refinery.roots('refinery/core').join('spec/support/fixtures/custom_js.js') }
    let(:custom_css){ Refinery.roots('refinery/core').join('spec/support/fixtures/custom_css.css') }

    before do
      Rails.application.config.assets.precompile += %W( #{custom_js} #{custom_css} )
    end

    after do
      Refinery::Core.javascripts.reject! { |j| %W[#{custom_js}].include?(j) }
      Refinery::Core.stylesheets.reject! { |s| %W[#{custom_css}].include?(s.path) }
    end

    context "javascripts" do
      before do
        ::Refinery::Core.config.register_javascript(custom_js)
      end

      it "should be rendered when specified" do
        visit Refinery::Core.backend_path
        expect(page.body.include?('custom_js')).to be
      end
    end

    context "stylesheets" do
      before do
        ::Refinery::Core.config.register_stylesheet(custom_css)
      end

      it "should be rendered when specified" do
        visit Refinery::Core.backend_path
        expect(page.body.include?('custom_css')).to be
      end
    end

  end
end
