require 'test_helper'

class ResourceTest < ActiveSupport::TestCase

  fixtures :resources

  def test_titles
    assert_equal "teng.pdf", resources(:pdf_document).file_name
    assert_equal "Teng", resources(:pdf_document).title
  end

  def test_delegate_methods
    assert_equal resources(:pdf_document).file_size, resources(:pdf_document).size

    [:size, :mime_type, :url].each do |meth|
      assert_equal resources(:pdf_document).file.send(meth), resources(:pdf_document).send(meth)
    end
  end

  def test_per_page
    assert_equal 12, Resource.per_page(dialog = true)
    assert_equal 20, Resource.per_page # dialog = false
  end

  def test_type_of_content
    assert_equal "application pdf", resources(:pdf_document).type_of_content
  end

end
