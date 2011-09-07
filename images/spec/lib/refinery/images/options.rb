require 'spec_helper'

module Refinery
  describe Images::Options do    
    describe ".reset!" do
      it "should set options back to their default values" do
        Images::Options.max_image_size.should == Images::Options::DEFAULT_MAX_IMAGE_SIZE
        Images::Options.max_image_size += 1
        Images::Options.max_image_size.should_not == Images::Options::DEFAULT_MAX_IMAGE_SIZE
        Images::Options.reset!
        Images::Options.max_image_size.should == Images::Options::DEFAULT_MAX_IMAGE_SIZE
      end
    end
  end
end