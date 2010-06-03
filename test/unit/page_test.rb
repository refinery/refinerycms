require 'test_helper'

class PageTest < ActiveSupport::TestCase

  fixtures :pages, :page_parts

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
    assert_equal true, pages(:services).deletable?
  end

  def test_should_stop_custom_link_pages_from_being_deleted
    assert_equal false, pages(:contact_us).deletable?
  end

  def test_page_tree_structure
    assert_equal 1, pages(:draft_page_child).ancestors.size
    assert_equal pages(:draft_page), pages(:draft_page_child).ancestors.first
    assert_equal 0, pages(:home_page).ancestors.size

    assert_equal 3, pages(:products).children.size
    assert_equal pages(:products), pages(:blue_jelly).ancestors.first
  end

  def test_should_have_custom_seo_settings
    assert_equal "Services", pages(:services).path
    assert_equal "Secret Product - Secret information about secret product", pages(:draft_page_child).path
    assert_equal "Secret information about secret product - Secret Product", pages(:draft_page_child).path(reverse = false)
  end

  def test_should_force_a_non_deletable_page_to_be_deleted
    assert_equal Page, pages(:page_not_found).destroy!.class # not .destroy. Returns the page you just destroyed
  end

  def test_should_have_custom_url_override
    assert_equal({:controller => "/contact"}, pages(:contact_us).url) # the contact us page links to the inquiries plugin form
    assert_equal({:controller => "/"}, pages(:home_page).url) # the home page has a special "/" url
    assert_equal "http://www.resolvedigital.co.nz", pages(:resolve_digital_page).url # this page links to an external url
  end

  def test_should_have_regular_url
    assert pages(:services).url[:controller] == "/pages"
    # not sure how I get it to render the friendly_id url /pages/services
    # test seems to reduce the id instead e.g. /pages/234423
  end

  def test_should_have_paramaterized_url
    # Save the page to generate the friendly_id slug
    pages(:products).save
    assert_equal "products", pages(:products).to_param
  end

  def test_should_have_nested_url
    pages(:blue_jelly).save
    pages(:products).save
    assert_equal ['products','blue-jelly'], pages(:blue_jelly).nested_url # returns ancestors' to_param with its own
  end

  def test_regular_url_should_include_path
    pages(:blue_jelly).save
    pages(:products).save
    assert_equal ['products','blue-jelly'], pages(:blue_jelly).url[:path]
  end

  def test_friendly_id_default_reserved_words
    reserved_words = Page.friendly_id_config.reserved_words
    %W(session login logout refinery users admin pages wymiframe).each do |page_slug|
      assert reserved_words.include?(page_slug), "missing #{page_slug}"
    end
  end

  def test_reserved_words_raise_exception
    # Normally, FriendlyId protects it's reserved words. We should catch these somehow.
    assert_nothing_raised(FriendlyId::ReservedError) { Page.create(:title => "Refinery") }
  end

  def test_drafts
    assert_equal false, pages(:draft_page).live? # the draft page is indeed a draft
    assert_equal true, pages(:home_page).live? # the home page is not a draft
    assert_equal true, pages(:draft_page_child).live? # child pages with draft parents should be drafts too
  end

  def test_home_page
    assert pages(:home_page).home?
    assert !pages(:services).home?
  end

  def test_in_menu_logic
    assert_equal true, pages(:home_page).in_menu? # home page should be in menu
    assert_equal false, pages(:draft_page_child).in_menu? # child pages with draft parents should be hidden
    assert_equal false, pages(:draft_page).in_menu? # draft pages should be hidden

    pages(:home_page).toggle!(:draft) # make the page a draft
    assert_equal false, pages(:home_page).live? # home page is no longer live
    assert_equal false, pages(:home_page).in_menu? # it should also not appear in the menu now

    pages(:home_page).toggle!(:draft) # make the page live again
    assert_equal true, pages(:home_page).in_menu? # home page should reappear in the menu

    pages(:home_page).toggle!(:show_in_menu) # now let's hide the home page from the menu
    assert_equal false, pages(:home_page).in_menu? # yep, it's hidden.

    assert_equal false,  pages(:thank_you).in_menu? # a live page that's hidden should not show in menu
  end

  def test_shown_siblings
    assert_equal 3, pages(:products).children.size
    assert_equal 4, pages(:products).shown_siblings.size
  end

  def test_top_level_page_output
    assert_equal 5, Page.top_level.size

    # testing the order of pages.
    assert_equal pages(:home_page), Page.top_level.first
    assert_equal pages(:resolve_digital_page), Page.top_level.last
    assert_equal pages(:products), Page.top_level.second
    assert_equal pages(:services), Page.top_level.third
  end

  def test_order_of_children
    assert_equal pages(:blue_jelly), pages(:products).children.first
    assert_equal pages(:green_jelly), pages(:products).children.second
    assert_equal pages(:rainbow_jelly), pages(:products).children.last
  end

  def test_title_with_meta
    assert_equal "Home Page", pages(:home_page).title_with_meta
    assert_equal "Secret Product <em>(draft)</em>", pages(:draft_page).title_with_meta
  end

  def test_per_page
    assert_equal 20, Page.per_page
    assert_equal 14, Page.per_page(dialog = true)
  end

  def test_all_page_part_content
    assert_equal "This is the body This is the side body", pages(:home_page).all_page_part_content
  end

  def test_page_parts
    assert_equal page_parts(:home_page_body).body, pages(:home_page)[:body]
    assert_equal page_parts(:home_page_body).body, pages(:home_page)["BODY"]
    assert_equal page_parts(:home_page_side_body).body, pages(:home_page)[:side_body]
    assert_equal page_parts(:home_page_side_body).body, pages(:home_page)["SidE BoDy"]

    # but make sure we can still access other fields through []
    assert_equal "Home Page", pages(:home_page)[:title]
  end

end
