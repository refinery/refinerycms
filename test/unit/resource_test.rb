require 'test_helper'

class ResourceTest < ActiveSupport::TestCase

  fixtures :resources

  def test_titles
    assert_equal "teng.pdf", resources(:pdf_document).filename
    assert_equal "Teng", resources(:pdf_document).title
  end

  def test_per_page
    assert_equal 12, Resource.per_page(dialog = true)
    assert_equal 20, Resource.per_page # dialog = false
  end

  def test_attachment_fu_options
    assert_equal 50.megabytes, Resource.attachment_options[:max_size]

    if Refinery.s3_backend
      assert_equal :s3, Resource.attachment_options[:storage]
      assert_nil Resource.attachment_options[:path_prefix]
    else
      assert_equal :file_system, Resource.attachment_options[:storage]
      assert_equal 'public/system/resources', Resource.attachment_options[:path_prefix]
    end
  end

  def test_type_of_content
    assert_equal "application pdf", resources(:pdf_document).type_of_content
  end

end
