require 'test_helper'

class PageTest < ActiveSupport::TestCase
	
	fixtures :pages
	
	def setup
		@new_page = Page.new
	end
	
  def test_should_not_save_page_without_title
		assert !@new_page.save, "Saved the page without a title"
  end

	def test_should_stop_system_pages_from_being_deleted
		assert_equal false, pages(:home_page).deletable?
		assert_equal false, pages(:page_not_found).destroy
	end
	
	def test_should_allow_normal_pages_to_be_deleted
		assert_equal true, pages(:services_page).deletable?
	end
	
	def test_should_stop_custom_link_pages_from_being_deleted
		assert_equal false, pages(:contact_us).deletable?
	end
	
	def test_should_have_custom_seo_settings
		assert_equal "Services", pages(:services_page).path
		assert_equal "Secret Product - Secret information about secret product", pages(:draft_page_child).path
	end

end