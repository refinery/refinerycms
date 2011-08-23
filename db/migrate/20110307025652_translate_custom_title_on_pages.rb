class TranslateCustomTitleOnPages < ActiveRecord::Migration
  def self.up
    unless ::Refinery::Page.translation_class.column_names.map(&:to_sym).include?(:menu_title)
      add_column ::Refinery::Page.translation_class.table_name, :menu_title, :string

      say_with_time("Re-save menu_title") do
        ::Refinery::Page.all.each do |page|
          say "updating menu_title field for page##{page.id}"
          page.update_attribute(:menu_title, page.untranslated_attributes['menu_title'])
        end
      end
    else
      say "Nothing done, ::Refinery::Page.translation_class table already includes a menu_title field"
    end

    ::Refinery::Page.translation_class.reset_column_information
  end

  def self.down
    say_with_time("Re-save menu_title") do
      ::Refinery::Page.all.each do |page|
        if page.attributes['menu_title'].nil?
          say "Nothing done, page##{page.id} menu_title field is nil"
        else
          say "updating menu_title field for page #{page.id}"
          ::Refinery::Page.update_all({
            :menu_title => page.attributes['menu_title']
          }, {
            :id => page.id.to_s
          })
        end
      end
    end

    remove_column ::Refinery::Page.translation_class.table_name, :menu_title

    ::Refinery::Page.translated_attribute_names.delete(:menu_title)

    ::Refinery::Page.translation_class.reset_column_information
  end
end
