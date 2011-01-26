class TranslatePagePlugin < ActiveRecord::Migration
  def self.up
    PagePart.create_translation_table!({
      :body => :text
    }, {
      :migrate_data => true
    })

    Page.create_translation_table!({
      :title => :string,
      :meta_keywords => :string,
      :meta_description => :text,
      :browser_title => :string
    }, {
      :migrate_data => true
    })

    if (seed_file = Rails.root.join('db', 'seeds', 'pages.rb')).file?
      load seed_file.to_s unless Page.where(:link_url => '/').any?
    end

    Slug.update_all(:locale => ::I18n.locale)
  end

  def self.down
    Page.drop_translation_table! :migrate_data => true
    PagePart.drop_translation_table! :migrate_data => true
  end
end
