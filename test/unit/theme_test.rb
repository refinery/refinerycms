require 'test_helper'

class ThemeTest < ActiveSupport::TestCase

  fixtures :themes
  
  def test_folder_title
    assert_equal 'my_theme', themes(:my_theme).folder_title
  end
  
  def test_theme_path
    assert_equal "#{Rails.root}/themes/my_theme", themes(:my_theme).theme_path
  end
  
  def test_preview_image
    assert_equal "#{Rails.root}/themes/my_theme/preview.png", themes(:my_theme).preview_image
  end
  
end