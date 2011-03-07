class TranslateCustomTitleOnPages < ActiveRecord::Migration
  def self.up
    add_column ::Page::Translation.table_name, :custom_title, :string

    # Re-save custom_title
    ::Page.all.each do |page|
      page.update_attribute(:custom_title, page.untranslated_attributes['custom_title'])
    end

    remove_column ::Page.table_name, :custom_title
  end

  def self.down
    # Restore
    add_column ::Page.table_name, :custom_title, :string

    # Re-save custom_title
    ::Page.all.each do |page|
      ::Page.update_all({
        :custom_title => page.attributes['custom_title']
      }, {
        :id => page.id.to_s
      }) unless page.attributes['custom_title'].nil?
    end

    remove_column ::Page::Translation.table_name, :custom_title
  end
end
