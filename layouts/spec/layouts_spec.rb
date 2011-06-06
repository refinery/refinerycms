require 'spec_helper'

describe "page and layout templates", :type => :request do
  RefinerySetting.create(:name => "use_layout_templates",       :value => 0, :destroyable => false)
  RefinerySetting.create(:name => "use_page_templates",         :value => 0, :destroyable => false)
  RefinerySetting.create(:name => "layout_template_whitelist",  :value => ['application'], :destroyable => false)
  RefinerySetting.create(:name => "view_template_whitelist",    :value => ['home','show'], :destroyable => false)

  let(:home) do
    Page.create!(:title => 'Home', :deletable => true)
  end

  home.parts.create(:title => 'body', :content => "I'm the first page part for this page.")
  home.parts.create(:title => 'side body', :content => "Closely followed by the second page part.")

  let (:about) do
    Page.create!({:title => 'About', :deletable => true})
  end

  about.parts.create(:title => 'body', :content => "I'm the first page part for this page.")
  about.parts.create(:title => 'side body', :content => "Closely followed by the second page part.")

  let(:page) do
    Page.create!({
      :title => "RSpec is great for testing too",
      :deletable => true
    })
  end
  let(:child) { page.children.create(:title => 'The child page') }

  def turn_on_layout_templates
    RefinerySetting.set(:use_multi_layout, {:value => false, :scoping => 'pages'})
  end

  def turn_off_layout_templates
    RefinerySetting.set(:use_marketable_urls, {:value => true})
  end

  it "can sign in to the admin" do
    @user ||= Factory(:refinery_user)

    within("#session") do
      fill_in 'user_login',    :with => @user.email
      fill_in 'user_password', :with => 'greenandjuicy'
    end

    click_button 'submit_button'
  end

#  it "should not appear in the dropdown if not in the whitelist" do
#  end
#
#  it "should not appear in the dropdown if not in the filesystem" do
#  end
#
#  it "should say hello when changed to the custom layout" do
#  end
#
#  it "should not say hello when feature is disabled" do
#  end
end
