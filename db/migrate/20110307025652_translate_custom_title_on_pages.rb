class TranslateCustomTitleOnPages < ActiveRecord::Migration
  def self.up
    unless ::Page::Translation.column_names.map(&:to_sym).include?(:custom_title)
      add_column ::Page::Translation.table_name, :custom_title, :string

      # Re-save custom_title
      ::Page.all.each do |page|
        page.update_attribute(:custom_title, page.untranslated_attributes['custom_title'])
      end

    end
  end

  def self.down
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
