require File.expand_path('../../../spec_helper', __FILE__)

describe Page do
  before(:each) do
    @valid_attributes = {
      :title => "RSpec is great for testing too"
    }
  end

  it "should create a new instance given valid attributes" do
    Page.create!(@valid_attributes)
  end
end
