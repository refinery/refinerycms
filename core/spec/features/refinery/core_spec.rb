module Refinery
  module Core
    describe Engine do
      describe "#refinery_inclusion!" do
        it "should be idempotent" do
          expect { visit(refinery.root_path) }.to_not raise_error
          Engine.refinery_inclusion!
          Engine.refinery_inclusion!
          expect { visit(refinery.root_path) }.to_not raise_error
        end
      end
    end
  end
end
