require 'spec_helper'

Dir[File.expand_path('../../../features/support/factories.rb', __FILE__)].each {|f| require f}

describe User do
  include AuthenticatedTestHelper

  context "Roles" do
    context "add_role" do
      it "raises Exception when Role object is passed" do
        user = Factory(:user)
        lambda{ user.add_role(Role.new)}.should raise_exception
      end

      it "adds a Role to the User when role not yet assigned to User" do
        user = Factory(:user)
        lambda {
          user.add_role(:new_role)
        }.should change(user.roles, :count).by(1)
        user.roles.collect(&:title).should include("NewRole")
      end

      it "does not add a Role to the User when this Role is already assigned to User" do
        user = Factory(:refinery_user)
        lambda {
          user.add_role(:refinery)
        }.should_not change(user.roles, :count).by(1)
        user.roles.collect(&:title).should include("Refinery")
      end
    end

    context "has_role" do
      it "raises Exception when Role object is passed" do
        user = Factory(:user)
        lambda{ user.has_role?(Role.new)}.should raise_exception
      end

      it "returns the true if user has Role" do
        user = Factory(:refinery_user)
        user.has_role?(:refinery).should be_true
      end

      it "returns false if user hasn't the Role" do
        user = Factory(:refinery_user)
        user.has_role?(:refinery_fail).should be_false
      end

    end

  end

end
