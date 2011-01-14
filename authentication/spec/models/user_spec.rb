require 'spec_helper'

Dir[File.expand_path('../../../features/support/factories.rb', __FILE__)].each {|f| require f}

describe User do
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

    describe "role association" do
      it "have a roles attribute" do
        Factory(:user).should respond_to(:roles)
      end
    end
  end

  context "validations" do
    # email and password validations are done by including devises validatable
    # module so those validations are not tested here
    before(:each) do
      @attr = {
        :username => "RefineryCMS",
        :email => "refinery@cms.com",
        :password => "123456",
        :password_confirmation => "123456"
      }
    end

    it "requires username" do
      User.new(@attr.merge(:username => "")).should_not be_valid
    end

    it "rejects duplicate usernames" do
      User.create!(@attr)
      User.new(@attr.merge(:email => "another@email.com")).should_not be_valid
    end
  end

  describe ".find_for_database_authentication" do
    it "finds user either by username or email" do
      user = Factory(:user)
      User.find_for_database_authentication(:login => user.username).should == user
      User.find_for_database_authentication(:login => user.email).should == user
    end
  end

  describe "#can_delete?" do
    before(:each) do
      @user = Factory(:refinery_user)
      @user_not_persisted = Factory.build(:refinery_user)
      @super_user = Factory(:refinery_user)
      @super_user.add_role(:superuser)
    end

    context "won't allow to delete" do
      it "not persisted user record" do
        @user.can_delete?(@user_not_persisted).should be_false
      end

      it "user with superuser role" do
        @user.can_delete?(@super_user).should be_false
      end

      it "if user count with refinery role <= 1" do
        Role[:refinery].users.delete(@user)
        @super_user.can_delete?(@user).should be_false
      end

      it "user himself" do
        @user.can_delete?(@user).should be_false
      end
    end

    context "allow to delete" do
      it "if all conditions return true" do
        @super_user.can_delete?(@user).should be_true
      end
    end
  end

  describe "#plugins=" do
    it "assigns plugins to user" do
      user = Factory(:user)
      plugin_list = ["refinery_one", "refinery_two", "refinery_three"]
      user.plugins = plugin_list
      user.plugins.collect { |p| p.name }.should == plugin_list
    end
  end

  describe "#authorized_plugins" do
    it "returns array of user and always allowd plugins" do
      user = Factory(:user)
      ["refinery_one", "refinery_two", "refinery_three"].each_with_index do |name, index|
        user.plugins.create!(:name => name, :position => index)
      end
      user.authorized_plugins.should == user.plugins.collect { |p| p.name } | Refinery::Plugins.always_allowed.names
    end
  end

  describe "plugins association" do
    before(:each) do
      @user = Factory(:user)
      @plugin_list = ["refinery_one", "refinery_two", "refinery_three"]
      @user.plugins = @plugin_list
    end

    it "have a plugins attribute" do
      @user.should respond_to(:plugins)
    end

    it "returns plugins in ASC order" do
      @user.plugins[0].name.should == @plugin_list[0]
      @user.plugins[1].name.should == @plugin_list[1]
      @user.plugins[2].name.should == @plugin_list[2]
    end

    it "deletes associated plugins" do
      @user.destroy
      UserPlugin.find_by_user_id(@user.id).should be_nil
    end
  end
end
