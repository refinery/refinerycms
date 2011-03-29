class CreateSeoMeta < ActiveRecord::Migration

  def self.up
    create_table :seo_meta do |t|
      t.integer :seo_meta_id
      t.string :seo_meta_type

      t.string :browser_title
      t.string :meta_keywords
      t.text :meta_description

      t.timestamps
    end

    add_index :seo_meta, :id
    add_index :seo_meta, [:seo_meta_id, :seo_meta_type]

    # Grab the attributes of the records that currently exist
    existing_translations = ::Page::Translation.all.map(&:attributes)

    # Remove columns
    ::SeoMeta.attributes.keys.each do |field|
      if ::Page::Translation.column_names.map(&:to_sym).include?(field)
        remove_column ::Page::Translation.table_name, field
      end
    end

    # Reset column information because otherwise the old columns will still exist.
    ::Page::Translation.reset_column_information

    # Re-attach seo_meta
    ::Page::Translation.module_eval do
      is_seo_meta
    end

    # Migrate data
    existing_translations.each do |translation|
      ::Page::Translation.find(translation['id']).update_attributes(
        ::SeoMeta.attributes.keys.inject({}) {|attributes, name|
          attributes.merge(name => translation[name.to_s])
        }
      )
    end
  end

  def self.down
    # Grab the attributes of the records that currently exist
    existing_translations = ::Page::Translation.all.map(&:attributes)

    # Add columns back to your model
    ::SeoMeta.attributes.each do |field, field_type|
      unless ::Page::Translation.column_names.map(&:to_sym).include?(field)
        add_column ::Page::Translation.table_name, field, field_type
      end
    end

    # Reset column information because otherwise the new columns won't exist yet.
    ::Page::Translation.reset_column_information

    # Migrate data
    existing_translations.each do |translation|
      ::Page::Translation.find(translation['id']).update_attributes(
        ::SeoMeta.attributes.keys.inject({}) {|attributes, name|
          attributes.merge(name => translation[name.to_s])
        }
      )
    end

    drop_table :seo_meta
  end

end
