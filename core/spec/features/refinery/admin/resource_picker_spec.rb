require "spec_helper"

module Refinery
  describe "resource_picker", :type => :feature do
    refinery_login_with :refinery_user

    context 'No resource present' do
      it 'shows the add icon and message' do
        pending "implementation"
      end

      it "doesn't show the manage resources icons" do
        pending "implementation"
      end

      it 'adds a resource' do
        pending "implementation"
      end
    end

    context 'Resource present' do
      it "doesn't show the add icon and message" do
        pending "implementation"
      end

      it "shows the link and management icons for the resource" do
        pending "implementation"
      end

      it 'detaches the resource from the object' do
        pending "implementation"
      end

      it 'replaces the resource with another resource' do
        pending "implementation"
      end

      it 'allows the resource to be downloaded (but why?)' do
        pending "implementation"
      end
    end
  end
end
