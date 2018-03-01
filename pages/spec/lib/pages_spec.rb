require "spec_helper"

module Refinery
  describe Pages do
    describe ".valid_templates" do
      before do
        File.open(File.join(subject.root, "spec", "ugisozols.html"), "w+") do
        end
      end

      after { File.delete(File.join(subject.root, "spec", "ugisozols.html")) }

      context "when pattern match valid templates" do
        it "returns an array of valid templates" do
          expect(subject.valid_templates('spec', '*html*')).to include("ugisozols")
        end
      end

      context "when pattern doesn't match valid templates" do
        it "returns empty array" do
          expect(subject.valid_templates('huh', '*html*')).to eq([])
        end
      end
    end

    describe ".default_parts_for" do
      context "with no view template" do
        it "returns the default page parts" do
          expect(subject.default_parts_for(Page.new)).to eq subject.default_parts
        end
      end

      context "with registered type" do
        let(:type_name) { "custom_type" }
        before { Pages::Types.registered.register(type_name) { |type| type.parts = type_parts } }
        after { Pages::Types.registered.delete(Pages::Types.registered.find_by_name(type_name)) }

        context "page parts specified as array of hashes (part attributes)" do
          let(:type_parts) { [{slug: "body", title: "Body"}] }
          it "returns the parts for the type" do
            type_parts = Pages::Types.registered.find_by_name(type_name).parts
            page = Page.new(view_template: type_name)
            expect(subject.default_parts_for(page)).to eq type_parts
          end
        end

        context "page parts specified as array of strings" do
          let(:type_parts) { %w[Body] }
          it "returns the parts for the type as a hash" do
            page = Page.new(view_template: type_name)
            expect(subject.default_parts_for(page)).to eq [{slug: "body", title: "Body"}]
          end

          xit "warns that this configuration format is deprecated"
        end
      end
    end
  end
end
