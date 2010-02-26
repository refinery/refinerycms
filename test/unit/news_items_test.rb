require 'test_helper'

class NewsItemsTest < ActiveSupport::TestCase

  fixtures :news_items

  def setup
    @new_news_item = NewsItem.new
    @new_valid_news_item = NewsItem.new(:title => "valid post", :body => "yep looks valid", :publish_date => Date.today)
  end

  def test_should_not_save_without_title_and_body
    assert !@new_news_item.save

    assert_equal "can't be blank", @new_news_item.errors.on('title')
    assert_equal "can't be blank", @new_news_item.errors.on('body')
    assert_equal "can't be blank", @new_news_item.errors.on('publish_date')

    assert @new_valid_news_item.save
  end

  def test_per_page
    assert_equal 20, NewsItem.per_page
  end

  def test_named_scopes
    assert_equal 2, NewsItem.published.size
    assert NewsItem.latest.size < 10

    assert_equal news_items(:new_team_member), NewsItem.latest.first
  end

end
