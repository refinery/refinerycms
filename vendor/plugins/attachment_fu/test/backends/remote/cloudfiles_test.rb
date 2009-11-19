require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'test_helper'))
require 'net/http'

class CloudfilesTest < Test::Unit::TestCase
  def self.test_CloudFiles?
    true unless ENV["TEST_CLOUDFILES"] == "false"
  end

  if test_CloudFiles? && File.exist?(File.join(File.dirname(__FILE__), '../../rackspace_cloudfiles.yml'))
    include BaseAttachmentTests
    attachment_model CloudFilesAttachment

    def test_should_create_correct_container_name(klass = CloudFilesAttachment)
      attachment_model klass
      attachment = upload_file :filename => '/files/rails.png'
      assert_equal attachment.cloudfiles_config[:container_name], attachment.container_name
    end

    test_against_subclass :test_should_create_correct_container_name, CloudFilesAttachment

    def test_should_create_default_path_prefix(klass = CloudFilesAttachment)
      attachment_model klass
      attachment = upload_file :filename => '/files/rails.png'
      assert_equal File.join(attachment_model.table_name, attachment.attachment_path_id), attachment.base_path
    end

    test_against_subclass :test_should_create_default_path_prefix, CloudFilesAttachment

    def test_should_create_custom_path_prefix(klass = CloudFilesWithPathPrefixAttachment)
      attachment_model klass
      attachment = upload_file :filename => '/files/rails.png'
      assert_equal File.join('some/custom/path/prefix', attachment.attachment_path_id), attachment.base_path
    end

    test_against_subclass :test_should_create_custom_path_prefix, CloudFilesWithPathPrefixAttachment


    def test_should_create_valid_url(klass = CloudFilesAttachment)
      attachment_model klass
      attachment = upload_file :filename => '/files/rails.png'
      assert_match(%r!http://cdn.cloudfiles.mosso.com/(.*?)/cloud_files_attachments/1/rails.png!, attachment.cloudfiles_url)
    end

    test_against_subclass :test_should_create_valid_url, CloudFilesAttachment

    def test_should_save_attachment(klass = CloudFilesAttachment)
      attachment_model klass
      assert_created do
        attachment = upload_file :filename => '/files/rails.png'
        assert_valid attachment
        assert attachment.image?
        assert !attachment.size.zero?
        assert_kind_of Net::HTTPOK, http_response_for(attachment.cloudfiles_url)
      end
    end

    test_against_subclass :test_should_save_attachment, CloudFilesAttachment

    def test_should_delete_attachment_from_cloud_files_when_attachment_record_destroyed(klass = CloudFilesAttachment)
      attachment_model klass
      attachment = upload_file :filename => '/files/rails.png'

      urls = [attachment.cloudfiles_url] + attachment.thumbnails.collect(&:cloudfiles_url)

      urls.each {|url| assert_kind_of Net::HTTPOK, http_response_for(url) }
      attachment.destroy
      urls.each do |url|
        begin
          http_response_for(url)
        rescue Net::HTTPForbidden, Net::HTTPNotFound
          nil
        end
      end
    end

    test_against_subclass :test_should_delete_attachment_from_cloud_files_when_attachment_record_destroyed, CloudFilesAttachment



    protected
      def http_response_for(url)
        url = URI.parse(url)
        Net::HTTP.start(url.host, url.port) {|http| http.request_head(url.path) }
      end

      def s3_protocol
        Technoweenie::AttachmentFu::Backends::S3Backend.protocol
      end

      def s3_hostname
        Technoweenie::AttachmentFu::Backends::S3Backend.hostname
      end

      def s3_port_string
        Technoweenie::AttachmentFu::Backends::S3Backend.port_string
      end
  else
    def test_flunk_s3
      puts "s3 config file not loaded, tests not running"
    end
  end
end
