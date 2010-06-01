require 'test_helper'

class RefinerySettingTest < ActiveSupport::TestCase

  fixtures :refinery_settings

  def test_title
    assert_equal "Site Name", refinery_settings(:site_name).title
  end

  def test_getter_method
    assert_equal "My Site", RefinerySetting[:site_name]
    assert_equal "My Site", RefinerySetting['site_name']
    assert_equal "My Site", RefinerySetting.site_name
  end

  def test_find_or_set
    # creating a new setting on the fly
    assert_equal "test", RefinerySetting.find_or_set(:my_setting, "test")
    assert_equal "test", RefinerySetting[:my_setting]
  end

  def test_setter_methods
    assert_equal "My Site", RefinerySetting[:site_name]

    # change the site name setting
    RefinerySetting[:site_name] = "My New Site Name"
    assert_equal "My New Site Name", RefinerySetting[:site_name]

    # change the site name setting again this time with quotes not symbols
    RefinerySetting['site_name'] = "My Site 2"
    assert_equal "My Site 2", RefinerySetting[:site_name]
  end

  def test_per_page
    assert_equal 12, RefinerySetting.per_page
  end

  def test_boolean_settings
    RefinerySetting[:show_dashboard] = true
    assert RefinerySetting[:show_dashboard]

    RefinerySetting[:show_dashboard] = false
    assert !RefinerySetting[:show_dashboard]
  end

  def test_hash_settings
    RefinerySetting[:site_owner_information] = {:name => "david", :email => "dave@test.com"}
    assert_equal "david", RefinerySetting[:site_owner_information][:name]
  end

  def test_integer_settings
    RefinerySetting[:recent_activity_size] = 19
    assert_equal 19, RefinerySetting[:recent_activity_size]
  end

end
