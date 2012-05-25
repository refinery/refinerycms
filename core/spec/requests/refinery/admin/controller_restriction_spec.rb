require "spec_helper"

module Refinery
  describe "plugin access" do
    context "as refinery user" do
      login_refinery_user

      context "with permission" do
        it "allows access" do
          visit refinery.admin_pages_path
          page.body.should_not include '404'
        end
      end

      context "without permission" do
        before do
          Refinery::User.first.plugins = []
        end

        it "denies access" do
          visit refinery.admin_pages_path
          page.body.should include '404'
        end
      end
    end
  end
end
