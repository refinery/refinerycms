require 'test_helper'

class PagePartTest < ActiveSupport::TestCase

  fixtures :page_parts

  def setup
    @new_page_part = PagePart.new
  end

  def test_should_not_save_page_part_without_title
    assert !@new_page_part.save, "Saved the page part without a title"
  end

  def test_alias_content_body_works
    assert_equal page_parts(:home_page_body).body, page_parts(:home_page_body).content
  end

end
