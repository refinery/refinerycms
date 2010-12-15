require 'spec_helper'

describe Page do

  def reset_page(options = {})
    @valid_attributes = {
      :id => 1,
      :title => "RSpec is great for testing too",
      :deletable => true
    }

    @page.destroy! if @page
    @page = Page.create!(@valid_attributes)
    @page.update_attributes(options)
  end

  def page_cannot_be_destroyed
    @page.destroy.should == false
  end

  def create_child
    @child = @page.children.create(:title => 'The child page')
  end

  def create_page_parts
    @page.parts.create(:title => 'body', :content => "I'm the first page part for this page.")
    @page.parts.create(:title => 'side body', :content => "Closely followed by the second page part.")
  end

  def turn_off_marketable_urls
    RefinerySetting.set(:use_marketable_urls, {:value => false, :scoping => 'pages'})
  end


  before(:each) do
    reset_page
  end

  context "cannot be deleted under certain rules" do
    it "if link_url is present" do
      reset_page({:link_url => '/plugin-name'})
      page_cannot_be_destroyed
    end


    it "if refinery team deems it so" do
      reset_page({:deletable => false})
      page_cannot_be_destroyed
    end

    it "if menu_match is present" do
      reset_page({:menu_match => '^/RSpec is great for testing too.*$'})
      page_cannot_be_destroyed
    end

    it "unless you really want it to! >:]" do
      reset_page
      @page.destroy!
    end
  end

  context "page urls" do
    it "should return a full path" do
      @page.path.should == 'RSpec is great for testing too'
    end

    it "and all of its parent page titles, reversed" do
      create_child
      @child.path.should == 'RSpec is great for testing too - The child page'
    end

    it "or normally ;-)" do
      create_child
      @child.path({:reversed => false}).should == 'The child page - RSpec is great for testing too'
    end

    it ".path() still responds to the deprecated boolean" do
      create_child
      capture_stdout { @child.path(false).should == 'The child page - RSpec is great for testing too' }
    end

    it "prints a logger warning when the deprecated boolean is used for path()" do
      create_child
      log_messages = capture_stdout { @child.path(false) }
      log_messages.should_not be_empty
    end

    it "should return its url" do
      @page.link_url = '/contact'
      @page.url.should == '/contact'

      reset_page
      @page.url[:path].should == ["rspec-is-great-for-testing-too"]
      @page.url[:id].should be_nil

      turn_off_marketable_urls
      @page.url[:id].should == "rspec-is-great-for-testing-too"
      @page.url[:path].should be_nil
    end
  end

  context "home page" do
    it "should respond as the home page" do
      @page.link_url = '/'
      @page.home?.should == true
    end

    it "should not respond as the home page" do
      @page.home?.should == false
    end
  end

  context "content sections (page parts)" do
    it "should return the content when using []" do
      create_page_parts

      @page[:body].should == "<p>I'm the first page part for this page.</p>"
      @page["BoDY"].should == "<p>I'm the first page part for this page.</p>"
    end

    it "should return all page part content" do
      create_page_parts

      @page.all_page_part_content.should == "<p>I'm the first page part for this page.</p> <p>Closely followed by the second page part.</p>"
    end

    it "should reposition correctly" do
      create_page_parts
      @page.parts.first.position = 6
      @page.parts.last.position = 4

      @page.parts.first.position.should == 6
      @page.parts.last.position.should == 4

      @page.reposition_parts!

      @page.parts.first.position.should == 0
      @page.parts.last.position.should == 1
    end
  end

  context "draft pages" do
    it "should not be a live page when set to draft" do
      @page.draft = true
      @page.live?.should == false

      @page.draft = false
      @page.live?.should == true
    end
  end


end
