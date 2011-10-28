class TranslatePagePlugin < ActiveRecord::Migration
  def self.up
    say_with_time("Creating ::Refinery::PagePart translation table") do
      ::Refinery::PagePart.create_translation_table!({
        :body => :text
      }, {
        :migrate_data => true
      })
    end

    say_with_time("Creating ::Refinery::Page translation table") do
      ::Refinery::Page.create_translation_table!({
        :title => :string,
        :meta_keywords => :string,
        :meta_description => :text,
        :browser_title => :string,
        :custom_slug => :string,
        :menu_title => :string
      }, {
        :migrate_data => true
      })
    end

    unless Refinery::Page.where(:link_url => '/').any?
      say_with_time("Seeding pages") { Refinery::Pages::Engine.load_seed }
    end

    say_with_time("Updating slugs") do
      ::Slug.update_all(:locale => I18n.locale)
    end
  end

  def self.down
    # Delete attributes from migration list that are already rolled back.
    (Refinery::Page.translated_attribute_names - ::Refinery::Page.translation_class.column_names.map(&:to_sym)).each do |attribute|
      Refinery::Page.translated_attribute_names.delete(attribute)
    end

    say_with_time("Dropping ::Refinery::Page and ::Refinery::PagePart translation tables") do
      ::Refinery::Page.drop_translation_table! :migrate_data => true
      ::Refinery::PagePart.drop_translation_table! :migrate_data => true
    end
  end
end
