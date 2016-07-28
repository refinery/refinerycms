require "spec_helper"

module Refinery
  module Core
    describe Engine, :type => :feature do
      describe "#refinery_inclusion!" do
        it "should be idempotent" do
          expect { visit(refinery.root_path) }.not_to raise_error
          Engine.refinery_inclusion!
          Engine.refinery_inclusion!
          expect { visit(refinery.root_path) }.not_to raise_error
        end
      end
    end
  end
end
