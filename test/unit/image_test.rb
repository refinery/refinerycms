require 'test_helper'

class ImageTest < ActiveSupport::TestCase

  fixtures :images

  def test_titles
    assert_equal "The%20world!.gif", images(:the_world).image_name
    assert_equal "The World!", images(:the_world).title

    assert_equal "car-wallpapers19.jpg", images(:our_car).image_name
    assert_equal "Car Wallpapers19", images(:our_car).title
  end

  def test_delegate_methods
    assert_equal images(:the_world).image_size, images(:the_world).size

    [:size, :mime_type, :url, :width, :height].each do |meth|
      assert_equal images(:the_world).image.send(meth), images(:the_world).send(meth)
    end
  end

  def test_per_page
    assert_equal 12, Image.per_page(dialog = true)
    assert_equal 20, Image.per_page # dialog = false
  end

end
