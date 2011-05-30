class TranslateCustomTitleOnPages < ActiveRecord::Migration
  def self.up
    unless ::Refinery::Page.translation_class.column_names.map(&:to_sym).include?(:custom_title)
      add_column ::Refinery::Page.translation_class.table_name, :custom_title, :string

      # Re-save custom_title
      ::Refinery::Page.all.each do |page|
        page.update_attribute(:custom_title, page.untranslated_attributes['custom_title'])
      end

    end
  end

  def self.down
    # Re-save custom_title
    ::Refinery::Page.all.each do |page|
      ::Refinery::Page.update_all({
        :custom_title => page.attributes['custom_title']
      }, {
        :id => page.id.to_s
      }) unless page.attributes['custom_title'].nil?
    end

    remove_column ::Refinery::Page.translation_class.table_name, :custom_title
  end
end
