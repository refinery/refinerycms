class CreatePageTranslations < ActiveRecord::Migration
  def self.up
    create_table :page_translations do |t|
      t.references :page
      t.string :custom_title
      t.string :meta_keywords
    end
  end

  def self.down
  end
end
