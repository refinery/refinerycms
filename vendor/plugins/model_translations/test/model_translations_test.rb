require 'test_helper'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :posts do |t|
      t.timestamps
    end
    create_table :post_translations do |t|
      t.string     :locale
      t.references :post
      t.string     :title
      t.text       :text
      t.timestamps
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Post < ActiveRecord::Base
  translates :title, :text
  validates_presence_of :title
end

class ModelTranslationsTest < ActiveSupport::TestCase
  def setup
    setup_db
    I18n.locale = I18n.default_locale = :en
    Post.create(:title => 'English title', :text => 'Text')
  end

  def teardown
    teardown_db
  end

  test "database setup" do
    assert Post.count == 1
  end

  test "allow translation" do
    I18n.locale = :sv
    Post.first.update_attribute :title, 'Svensk titel'
    assert_equal 'Svensk titel', Post.first.title
    I18n.locale = :en
    assert_equal 'English title', Post.first.title
  end

  test "assert fallback to default" do
    assert Post.first.title == 'English title'
    I18n.locale = :sv
    assert Post.first.title == 'English title'
  end

  test "parent has_many model_translations" do
    assert_equal PostTranslation, Post.first.model_translations.first.class
  end

  test "translations are deleted when parent is destroyed" do
    I18n.locale = :sv
    Post.first.update_attribute :title, 'Svensk titel'
    assert_equal 2, PostTranslation.count

    Post.destroy_all
    assert_equal 0, PostTranslation.count
  end

  test 'validates_presence_of should work' do
    post = Post.new
    assert_equal false, post.valid?

    post.title = 'English title'
    assert_equal true, post.valid?
  end

  test 'temporary locale switch should not clear changes' do
    I18n.locale = :sv
    post = Post.first
    post.text = 'Svensk text'
    post.title.blank?
    assert_equal 'Svensk text', post.text
  end
end
