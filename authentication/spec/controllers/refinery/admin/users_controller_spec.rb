require "spec_helper"

describe Refinery::Admin::UsersController do
  login_refinery_superuser

  shared_examples_for "new, create, update, edit and update actions" do
    it "loads roles" do
      Refinery::Role.should_receive(:all).once{ [] }
      get :new
    end

    it "loads plugins" do
      user_plugin = Refinery::Plugins.registered.detect { |plugin| plugin.name == "refinery_users" }
      plugins = Refinery::Plugins.new
      plugins << user_plugin
      plugins.should_receive(:in_menu).once{ [user_plugin] }

      Refinery::Plugins.should_receive(:registered).at_least(1).times{ plugins }
      get :new
    end
  end

  describe "#new" do
    it "renders the new template" do
      get :new
      response.should be_success
      response.should render_template("refinery/admin/users/new")
    end

    it_should_behave_like "new, create, update, edit and update actions"
  end

  describe "#create" do
    it "creates a new user with valid params" do
      user = Refinery::User.new :username => "bob"
      user.should_receive(:save).once{ true }
      Refinery::User.should_receive(:new).once.with(instance_of(HashWithIndifferentAccess)){ user }
      post :create, :user => {}
      response.should be_redirect
    end

    it_should_behave_like "new, create, update, edit and update actions"

    it "re-renders #new if there are errors" do
      user = Refinery::User.new :username => "bob"
      user.should_receive(:save).once{ false }
      Refinery::User.should_receive(:new).once.with(instance_of(HashWithIndifferentAccess)){ user }
      post :create, :user => {}
      response.should be_success
      response.should render_template("refinery/admin/users/new")
    end
  end

  describe "#edit" do
    it "renders the edit template" do
      get :edit, :id => refinery_superuser.id
      response.should be_success
      response.should render_template("refinery/admin/users/edit")
    end

    it_should_behave_like "new, create, update, edit and update actions"
  end

  describe "#update" do
    it "updates a user" do
      user = FactoryGirl.create(:refinery_user)
      Refinery::User.should_receive(:find).at_least(1).times{ user }
      put "update", :id => user.id.to_s, :user => {}
      response.should be_redirect
    end

    it_should_behave_like "new, create, update, edit and update actions"
  end
end
