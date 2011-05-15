require 'spec_helper'

describe Layout do

  def reset_layout(options = {})
    @valid_attributes = {
      :id => 1,
      :template_name => "RSpec is great for testing too"
    }

    @layout.destroy! if @layout
    @layout = Layout.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_layout
  end

  context "validations" do
    
    it "rejects empty template_name" do
      Layout.new(@valid_attributes.merge(:template_name => "")).should_not be_valid
    end

    it "rejects non unique template_name" do
      # as one gets created before each spec by reset_layout
      Layout.new(@valid_attributes).should_not be_valid
    end
    
  end

end