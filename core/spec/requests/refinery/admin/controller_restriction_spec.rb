require "spec_helper"

module Refinery
  describe "plugin access" do
    context "as refinery user" do
      refinery_login_with :refinery_user

      context "with permission" do
        it "allows access" do
          visit refinery.admin_pages_path
          page.body.should_not include '404'
        end
      end

      context "without permission" do
        before do
          logged_in_user.stub(:plugins).and_return []
        end

        it "denies access" do
          visit refinery.admin_pages_path
          page.body.should include '404'
        end
      end
    end
  end
end
