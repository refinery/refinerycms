require 'test_helper'

class PageTest < ActiveSupport::TestCase

  def test_should_not_save_page_without_title
    page = Page.new
		assert !page.save, "Saved the page without a title"
  end

end