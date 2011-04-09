class TranslateCustomTitleOnPages < ActiveRecord::Migration
  def self.up
    unless ::Page::Translation.column_names.map(&:to_sym).include?(:custom_title)
      add_column ::Page::Translation.table_name, :custom_title, :string

      say_with_time("Re-save custom_title") do
        ::Page.all.each do |page|
          say "updating custom_title field for page##{page.id}"
          page.update_attribute(:custom_title, page.untranslated_attributes['custom_title'])
        end
      end
    else
      say "Nothing done, ::Page::Translation table already includes a custom_title field"
    end

    ::Page::Translation.reset_column_information
  end

  def self.down
    say_with_time("Re-save custom_title") do
      ::Page.all.each do |page|
        if page.attributes['custom_title'].nil?
          say "Nothing done, page##{page.id} custom_title field is nil"
        else
          say "updating custom_title field for page #{page.id}"
          ::Page.update_all({
            :custom_title => page.attributes['custom_title']
          }, {
            :id => page.id.to_s
          })
        end
      end
    end

    remove_column ::Page::Translation.table_name, :custom_title

    ::Page.translated_attribute_names.delete(:custom_title)

    ::Page::Translation.reset_column_information
  end
end
