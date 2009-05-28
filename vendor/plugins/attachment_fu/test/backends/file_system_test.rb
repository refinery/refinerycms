require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))
require 'digest/sha2'

class FileSystemTest < Test::Unit::TestCase
  include BaseAttachmentTests
  attachment_model FileAttachment

  def test_filesystem_size_for_file_attachment(klass = FileAttachment)
    attachment_model klass
    assert_created 1 do
      attachment = upload_file :filename => '/files/rails.png'
      assert_equal attachment.size, File.open(attachment.full_filename).stat.size
    end
  end
  
  test_against_subclass :test_filesystem_size_for_file_attachment, FileAttachment

  def test_should_not_overwrite_file_attachment(klass = FileAttachment)
    attachment_model klass
    assert_created 2 do
      real = upload_file :filename => '/files/rails.png'
      assert_valid real
      assert !real.new_record?, real.errors.full_messages.join("\n")
      assert !real.size.zero?
      
      fake = upload_file :filename => '/files/fake/rails.png'
      assert_valid fake
      assert !fake.size.zero?
      
      assert_not_equal File.open(real.full_filename).stat.size, File.open(fake.full_filename).stat.size
    end
  end
  
  test_against_subclass :test_should_not_overwrite_file_attachment, FileAttachment

  def test_should_store_file_attachment_in_filesystem(klass = FileAttachment)
    attachment_model klass
    attachment = nil
    assert_created do
      attachment = upload_file :filename => '/files/rails.png'
      assert_valid attachment
      assert File.exists?(attachment.full_filename), "#{attachment.full_filename} does not exist"    
    end
    attachment
  end
  
  test_against_subclass :test_should_store_file_attachment_in_filesystem, FileAttachment
  
  def test_should_delete_old_file_when_updating(klass = FileAttachment)
    attachment_model klass
    attachment   = upload_file :filename => '/files/rails.png'
    old_filename = attachment.full_filename
    assert_not_created do
      use_temp_file 'files/rails.png' do |file|
        attachment.filename        = 'rails2.png'
        attachment.temp_paths.unshift File.join(fixture_path, file)
        attachment.save!
        assert  File.exists?(attachment.full_filename), "#{attachment.full_filename} does not exist"    
        assert !File.exists?(old_filename),             "#{old_filename} still exists"
      end
    end
  end
  
  test_against_subclass :test_should_delete_old_file_when_updating, FileAttachment
  
  def test_should_delete_old_file_when_renaming(klass = FileAttachment)
    attachment_model klass
    attachment   = upload_file :filename => '/files/rails.png'
    old_filename = attachment.full_filename
    assert_not_created do
      attachment.filename        = 'rails2.png'
      attachment.save
      assert  File.exists?(attachment.full_filename), "#{attachment.full_filename} does not exist"    
      assert !File.exists?(old_filename),             "#{old_filename} still exists"
      assert !attachment.reload.size.zero?
      assert_equal 'rails2.png', attachment.filename
    end
  end
  
  test_against_subclass :test_should_delete_old_file_when_renaming, FileAttachment
  
  def test_path_partitioning_works_on_integer_id(klass = FileAttachment)
    attachment_model klass
    
    # Create a random attachment object, doesn't matter what.
    attachment = upload_file :filename => '/files/rails.png'
    old_id = attachment.id
    attachment.id = 1
    
    begin
      assert_equal ["0000", "0001", "bar.txt"], attachment.send(:partitioned_path, "bar.txt")
    ensure
      attachment.id = old_id
    end
  end
  
  test_against_subclass :test_path_partitioning_works_on_integer_id, FileAttachment
  
  def test_path_partitioning_with_string_id_works_by_generating_hash(klass = FileAttachmentWithStringId)
    attachment_model klass
    
    # Create a random attachment object, doesn't matter what.
    attachment = upload_file :filename => '/files/rails.png'
    old_id = attachment.id
    attachment.id = "hello world some long string"
    hash = Digest::SHA512.hexdigest("hello world some long string")
    
    begin
      assert_equal [
          hash[0..31],
          hash[32..63],
          hash[64..95],
          hash[96..127],
          "bar.txt"
        ], attachment.send(:partitioned_path, "bar.txt")
    ensure
      attachment.id = old_id
    end
  end
  
  test_against_subclass :test_path_partitioning_with_string_id_works_by_generating_hash, FileAttachmentWithStringId
  
  def test_path_partition_string_id_hashing_is_turned_off_if_id_is_uuid(klass = FileAttachmentWithUuid)
    attachment_model klass
    
    # Create a random attachment object, doesn't matter what.
    attachment = upload_file :filename => '/files/rails.png'
    old_id = attachment.id
    attachment.id = "0c0743b698483569dc65909a8cdb3bf9"
    
    begin
      assert_equal [
          "0c0743b698483569",
          "dc65909a8cdb3bf9",
          "bar.txt"
        ], attachment.send(:partitioned_path, "bar.txt")
    ensure
      attachment.id = old_id
    end
  end
  
  test_against_subclass :test_path_partition_string_id_hashing_is_turned_off_if_id_is_uuid, FileAttachmentWithUuid
end
