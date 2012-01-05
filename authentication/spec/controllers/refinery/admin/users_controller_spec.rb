require "spec_helper"

describe Refinery::Admin::UsersController do
  login_refinery_user

  shared_examples_for "new, create, update, edit and update actions" do
    it "should load roles" do
      Refinery::Role.should_receive(:all).once{ [] }
      get :new
    end

    it "should load plugins" do
      plugins = Refinery::Plugins.new
      plugins.should_receive(:in_menu).once{ [] }

      Refinery::Plugins.should_receive(:registered).at_least(1).times{ plugins }
      get :new
    end
  end

  describe "#new" do
    it "should render the new template" do
      get :new
      response.should be_success
      response.should render_template("refinery/admin/users/new")
    end

    it_should_behave_like "new, create, update, edit and update actions"
  end

  describe "#create" do
    it "should create a new user with valid params" do
      user = Refinery::User.new :username => "bob"
      user.should_receive(:save).once{ true }
      Refinery::User.should_receive(:new).once.with(instance_of(HashWithIndifferentAccess)){ user }
      post :create, :user => {}
      response.should be_redirect
    end

    it_should_behave_like "new, create, update, edit and update actions"

    it "should re-render #new if there are errors" do
      user = Refinery::User.new :username => "bob"
      user.should_receive(:save).once{ false }
      Refinery::User.should_receive(:new).once.with(instance_of(HashWithIndifferentAccess)){ user }
      post :create, :user => {}
      response.should be_success
      response.should render_template("refinery/admin/users/new")
    end
  end

  describe "#edit" do
    it "should render the edit template" do
      Refinery::User.should_receive(:find).at_least(1).times{ Refinery::User.new }
      get :edit, :id => "1"
      response.should be_success
      response.should render_template("refinery/admin/users/edit")
    end

    it_should_behave_like "new, create, update, edit and update actions"
  end

  describe "#update" do
    it "should update a user" do
      user = ::Refinery::User.new
      user.stub(:update_attributes) { true }
      Refinery::User.should_receive(:find).at_least(1).times{ user }
      put :update, :id => "1", :user => {}
      response.should be_redirect
    end

    it_should_behave_like "new, create, update, edit and update actions"
  end
end
