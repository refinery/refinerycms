require "spec_helper"

module Refinery
  describe AdminController, "including ApplicationHelper" do

    def load_controller
      load File.join(File.dirname(__FILE__), '../../../app/controllers/refinery/admin_controller.rb')
    end

    before do
      # Let's unload the AdminController, since what we want to test occurs
      # at loading time.
      Refinery.send(:remove_const, "AdminController")
    end

    context "when ApplicationHelper is defined" do
      before do
        module ::ApplicationHelper
          def cook_pancakes; end
        end
      end

      it "should be included as a helper" do
        load_controller
        Refinery::AdminController.new._helpers.instance_methods.grep(/cook_pancakes/).should_not be_empty
      end
    end

    context "when ApplicationHelper is not defined" do
      before do
        Object.send(:remove_const, "ApplicationHelper")
      end

      it "should not raise" do
        load_controller
        Refinery::AdminController.new._helpers.instance_methods.grep(/cook_pancakes/).should be_empty
      end

      after do
        module ::ApplicationHelper; end
      end
    end

    after do
      # Let's ensure that the AdminController is reloaded so we don't bugger up
      # other specs.
      load_controller unless Refinery.constants(true).include?(:AdminController)
    end
  end
end
