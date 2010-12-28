class TranslatePagePlugin < ActiveRecord::Migration
  def self.up
    Page.create_translation_table!({
      :title => :string,
      :meta_keywords => :string,
      :meta_description => :text,
      :browser_title => :string
    }, {
      :migrate_data => true
    })

    PagePart.create_translation_table!({
      :body => :text
    }, {
      :migrate_data => true
    })
  end

  def self.down
    Page.drop_translation_table!
    PagePart.drop_translation_table!
  end
end
