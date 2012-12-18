require "spec_helper"

module Refinery
  module Pages

    describe ".tabs" do
      after do
        Refinery::Pages.instance_eval { @tabs = [] }
      end

      it "returns an array of registered tabs" do
        rspec_tab = Refinery::Pages::Tab.register do |tab|
          tab.name = "rspec"
          tab.partial = "rspec"
        end

        Refinery::Pages.tabs.should include(rspec_tab)
      end
    end

    describe ".tabs_for_template" do
      after do
        Refinery::Pages.instance_eval { @tabs = [] }
      end

      it "returns all tabs for which #templates hasn't been set" do
        rspec_tab = Refinery::Pages::Tab.register do |tab|
          tab.name = "rspec"
          tab.partial = "rspec"
        end

        Refinery::Pages.tabs_for_template("huh").should include(rspec_tab)
      end

      it "returns tabs with matched template" do
        rspec_tab = Refinery::Pages::Tab.register do |tab|
          tab.name = "rspec"
          tab.partial = "rspec"
          tab.templates = "rspec"
        end

        Refinery::Pages.tabs_for_template("rspec").should include(rspec_tab)
      end
    end

    describe Tab do
      after do
        Refinery::Pages.instance_eval { @tabs = [] }
      end

      describe ".register" do
        it "requires name to be set" do
          lambda {
            Refinery::Pages::Tab.register do |tab|
              tab.partial = "rspec"
            end
          }.should raise_error(/A tab MUST have a name!/)
        end

        it "requires partial to be set" do
          lambda {
            Refinery::Pages::Tab.register do |tab|
              tab.name = "rspec"
            end
          }.should raise_error(/A tab MUST have a partial!/)
        end

        it "sets #templates if it's not set" do
          rspec_tab = Refinery::Pages::Tab.register do |tab|
            tab.name = "rspec"
            tab.partial = "rspec"
          end

          rspec_tab.templates.should eq(["all"])
        end

        it "converts #templates to array if it's not an array already" do
          rspec_tab = Refinery::Pages::Tab.register do |tab|
            tab.name = "rspec"
            tab.partial = "rspec"
            tab.templates = "rspec"
          end

          rspec_tab.templates.should eq(["rspec"])
        end
      end
    end
  end
end
