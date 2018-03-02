require "spec_helper"

module Refinery
  module Pages
    describe Type do
      subject { Type.new }

      describe ".parts=" do
        it "returns an array of hashes unaltered" do
          parts = [{title: "Body", slug: "body"}]
          subject.parts = parts
          expect(subject.parts).to eq parts
        end

        it "rewrites an array of strings and warns about this deprecated format" do
          parts = ["Side Bar"]
          rewritten_parts = [{title: "Side Bar", slug: "side_bar"}]
          expect(Refinery).to receive(:deprecate).with("
            Change Refinery::Pages.default_parts= from #{parts} to #{rewritten_parts}
          ".strip, when: "4.1.0")

          subject.parts = parts
          expect(subject.parts).to eq rewritten_parts
        end
      end
    end
  end
end

