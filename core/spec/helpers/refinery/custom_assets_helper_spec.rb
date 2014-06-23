require "spec_helper"

module Refinery
  describe CustomAssetsHelper, :type => :helper do
    def clear_assets_used_by_spec
      Refinery::Core.javascripts.reject! {|j| %w[test parndt].include?(j) }
      Refinery::Core.stylesheets.reject! {|s| %w[test parndt].include?(s.path) }
    end

    before { clear_assets_used_by_spec }
    after { clear_assets_used_by_spec }

    describe "custom_javascripts" do
      it "should return one custom javascript in array when one javascript is registred" do
        Refinery::Core.config.register_javascript("test")
        expect(helper.custom_javascripts.last).to eq("test")
      end

      it "should return two custom javascripts in array when two javascripts are registred" do
        Refinery::Core.config.register_javascript("test")
        Refinery::Core.config.register_javascript("parndt")
        expect(helper.custom_javascripts).to include("test", "parndt")
      end
    end

    describe "custom_stylesheets" do
      it "should return one custom stylesheet class in array when one stylesheet is registred" do
        Refinery::Core.config.register_stylesheet("test")
        expect(helper.custom_stylesheets.last.path).to eq("test")
      end

      it "should return two custom stylesheet classes in array when two stylesheets are registred" do
        Refinery::Core.config.register_stylesheet("test")
        Refinery::Core.config.register_stylesheet("parndt")
        expect(helper.custom_stylesheets.map(&:path)).to include("test", "parndt")
      end

      it "should return stylesheet class with path and options when both are specified" do
        Refinery::Core.config.register_stylesheet("test", :media => 'screen')
        expect(helper.custom_stylesheets.last.path).to eq("test")
        expect(helper.custom_stylesheets.last.options).to eq({:media => 'screen'})
      end
    end
  end
end
