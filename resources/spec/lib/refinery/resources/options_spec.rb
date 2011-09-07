require 'spec_helper'

module Refinery
  describe Resources::Options do    
    describe ".reset!" do
      it "should set max_file_size back to the default value" do
        Resources::Options.max_file_size.should == Resources::Options::DEFAULT_MAX_FILE_SIZE
        Resources::Options.max_file_size += 1
        Resources::Options.max_file_size.should_not == Resources::Options::DEFAULT_MAX_FILE_SIZE
        Resources::Options.reset!
        Resources::Options.max_file_size.should == Resources::Options::DEFAULT_MAX_FILE_SIZE
      end
    end
  end
end