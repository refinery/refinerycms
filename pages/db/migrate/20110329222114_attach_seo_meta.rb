class AttachSeoMeta < ActiveRecord::Migration

  def self.up
    # Grab the attributes of the records that currently exist
    existing_translations = ::Refinery::Page.translation_class.all.map(&:attributes)

    # Remove columns
    ::SeoMeta.attributes.keys.each do |field|
      if ::Refinery::Page.translation_class.column_names.map(&:to_sym).include?(field)
        remove_column ::Refinery::Page.translation_class.table_name, field
      end
    end

    # Reset column information because otherwise the old columns will still exist.
    [::Refinery::Page, ::Refinery::Page.translation_class].each do |model|
      ActiveRecord::Base.connection.schema_cache.clear_table_cache!(model.table_name)
      model.reset_column_information
    end

    # Re-attach seo_meta
    ::Refinery::Page.translation_class.send :is_seo_meta

    # Migrate data
    existing_translations.each do |translation|
      ::Refinery::Page.translation_class.find(translation['id']).update_attributes(
        ::SeoMeta.attributes.keys.reject{|k|
          ::Refinery::Page.translation_class.column_names.map(&:to_sym).exclude?(k)
        }.inject({}) {|attributes, name|
          attributes.merge(name => translation[name.to_s])
        }
      )
    end

    # Reset column information again because otherwise the old columns will still exist.
    ::Refinery::Page.reset_column_information
  end

  def self.down
    # Grab the attributes of the records that currently exist
    existing_translations = ::Refinery::Page.translation_class.all.map(&:attributes)

    # Add columns back to your model
    ::SeoMeta.attributes.each do |field, field_type|
      unless ::Refinery::Page.translation_class.column_names.map(&:to_sym).include?(field)
        add_column ::Refinery::Page.translation_class.table_name, field, field_type
      end
    end

    # Reset column information because otherwise the new columns won't exist yet.
    ::Refinery::Page.translation_class.reset_column_information

    # Migrate data
    existing_translations.each do |translation|
      ::Refinery::Page.translation_class.update_all(
        ::SeoMeta.attributes.keys.inject({}) {|attributes, name|
          attributes.merge(name => translation[name.to_s])
        }, :id => translation['id']
      )
    end

    ::SeoMeta.attributes.keys.each do |k|
      ::Refinery::Page.translation_class.module_eval %{
        def #{k}
        end

        def #{k}=(*args)
        end
      }
    end

    # Reset column information again because otherwise the old columns will still exist.
    ::Refinery::Page.reset_column_information
  end

end
