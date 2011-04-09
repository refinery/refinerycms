class TranslatePagePlugin < ActiveRecord::Migration
  def self.up
    say_with_time("Creating ::PagePart translation table") do
      ::PagePart.create_translation_table!({
        :body => :text
      }, {
        :migrate_data => true
      })
    end

    say_with_time("Creating ::Page translation table") do
      ::Page.create_translation_table!({
        :title => :string,
        :meta_keywords => :string,
        :meta_description => :text,
        :browser_title => :string
      }, {
        :migrate_data => true
      })
    end

    if (seed_file = Rails.root.join('db', 'seeds', 'pages.rb')).file?
      load seed_file.to_s unless Page.where(:link_url => '/').any?
    end

    say_with_time("Updating slugs") do
      ::Slug.update_all(:locale => ::I18n.locale)
    end
  end

  def self.down
    say_with_time("Dropping ::Page and ::PagePart translation tables") do
      ::Page.drop_translation_table! :migrate_data => true
      ::PagePart.drop_translation_table! :migrate_data => true
    end
  end
end
