class RemoveTranslatedFieldsFromPages < ActiveRecord::Migration
  def self.up
    ::Page.translated_attribute_names.map(&:to_sym).each do |column_name|
      remove_column ::Page.table_name, column_name if ::Page.column_names.map(&:to_sym).include?(column_name)
    end
  end

  def self.down
    ::Page.translated_attribute_names.map(&:to_sym).each do |column_name|
      add_column ::Page.table_name, column_name, Page::Translation.columns.detect{|c| c.name.to_sym == column_name}.type
    end
  end
end
