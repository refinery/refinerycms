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
  end

  def self.down
    Page.drop_translation_table! :migrate_data => true
    PagePart.drop_translation_table! :migrate_data => true
  end
end
