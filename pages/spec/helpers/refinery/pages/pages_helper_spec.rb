require 'spec_helper'

module Refinery
  describe PagesHelper do
    describe "#sanitize_hash" do
      context "when hash value responds to html_safe" do
        it "returns hash with sanitized values" do
          hash = { :key => "hack<script>" }
          helper.sanitize_hash(hash).should eq("key" => "hack")
        end
      end

      context "when hash value is an array" do
        it "returns hash with sanitized values" do
          hash = { :key => { :x => "hack<script>", :y => "malware<script>" } }
          helper.sanitize_hash(hash).should eq("key"=>{"x"=>"hack", "y"=>"malware"})
        end
      end

      context "when string value doesn't repsond to html_safe" do
        it "returns hash with value untouched" do
          String.any_instance.stub(:respond_to?).and_return(false)

          hash = { :key => "hack<script>" }
          helper.sanitize_hash(hash).should eq("key"=>"hack<script>")
        end
      end
    end
  end
end
