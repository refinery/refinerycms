class ConvertResourceToDragonfly < ActiveRecord::Migration

  # Use a basic model for the migration - otherwise the acts_as_indexed hooks
  # make copying attributes problematic.
  # (see: http://guides.rubyonrails.org/migrations.html#using-models-in-your-migrations)
  class Resource < ActiveRecord::Base; end;

  def self.up
    # Dragonfly required column
    add_column :resources, :file_uid, :string

    # Optional Dragonfly columns - persist 'magic' attributes
    add_column :resources, :file_ext, :string

    # Rename columns to Dragonfly conventions - persist 'magic' attributes
    rename_column :resources, :filename,     :file_name
    rename_column :resources, :content_type, :file_mime_type
    rename_column :resources, :size,         :file_size

    # Populate the image_uid column for Dragonfly
    Resource.all.each do |r|
      r.update_attributes(:file_uid => ("%08d" % r.id).scan(/..../).join('/') << '/' << r.file_name,
                          :file_ext => r.file_name.split('.').last)
    end

    # Remove child records, used by attachment_fu only
    Resource.delete_all('parent_id is not null')
    remove_column :resources, :parent_id
  end

  def self.down
    remove_column :resources, :file_uid
    remove_column :resources, :file_ext

    rename_column :resources, :file_name,      :filename
    rename_column :resources, :file_mime_type, :content_type
    rename_column :resources, :file_size,      :size

    add_column :resources, :parent_id, :integer
  end
end
