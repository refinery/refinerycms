require "spec_helper"
require 'refinery/pages/caching'

module Refinery
  module Pages
    describe Caching, :caching do
      let(:cache_path) { "/tmp"}
      let(:refinery_cache_path) { "/tmp/refinery/cache/pages"}
      let(:refinery_cache_file) { refinery_cache_path + ".html"}
      before do
        FileUtils.mkpath refinery_cache_path
        FileUtils.touch refinery_cache_file
      end

      after do
        FileUtils.rm_rf refinery_cache_path
        FileUtils.rm_rf refinery_cache_file
      end

      let(:cache) { Caching.new(cache_path) }

      describe "#expire!" do
        it "should call #clear_caching! and #delete_static_files!" do
          cache.should_receive(:clear_caching!)
          cache.should_receive(:delete_static_files!)
          cache.expire!
        end

        describe "#clear_caching!" do
          context "rails cache store supports #delete_matched" do
            before { Rails.cache.stub(:delete_matched)}

            it "should clear rails cache that matched namespace" do
              Rails.cache.should_receive(:delete_matched).with(/.*pages.*/)
              cache.expire!
            end
          end

          context "rails cache store does not supports #delete_matched" do
            before { Rails.cache.stub(:delete_matched).and_raise(NotImplementedError) }

            it "should clear rails cache that matched namespace" do
              Rails.cache.should_receive(:clear)
              silence_warnings do
                cache.expire!
              end
            end
          end
        end

        describe "#delete_static_files!" do
          context "valid cache directory" do
            before { cache.should_receive(:cache_dir_valid?).and_return(true) }

            it "should call #delete_page_cache_directory! and #delete_page_cache_index_file!" do
              cache.should_receive(:delete_page_cache_directory!)
              cache.should_receive(:delete_page_cache_index_file!)
              cache.expire!
            end

            it "should remove page cache directory" do
              File.exists?(refinery_cache_path).should be_true
              cache.expire!
              File.exists?(refinery_cache_path).should be_false
            end

            it "should remove home page cache file" do
              File.exists?(refinery_cache_file).should be_true
              cache.expire!
              File.exists?(refinery_cache_file).should be_false
            end

          end

          context "invalid cache directory" do
            let(:cache) { Caching.new() }
            before { cache.should_receive(:cache_dir_valid?).and_return(false) }

            it "should not call #delete_page_cache_directory! and #delete_page_cache_index_file!" do
              cache.should_not_receive(:delete_page_cache_directory!)
              cache.should_not_receive(:delete_page_cache_index_file!)
              cache.expire!
            end
          end
        end
      end

    end
  end
end
