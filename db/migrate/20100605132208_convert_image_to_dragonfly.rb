class ConvertImageToDragonfly < ActiveRecord::Migration

  # Use a basic model for the migration - otherwise the acts_as_indexed hooks
  # make copying attributes problematic.
  # (see: http://guides.rubyonrails.org/migrations.html#using-models-in-your-migrations)
  class Image < ActiveRecord::Base; end;

  def self.up
    # Dragonfly required column
    add_column :images, :image_uid, :string

    # Optional Dragonfly columns - persist 'magic' attributes
    add_column :images, :image_ext, :string

    # Rename columns to Dragonfly conventions - persist 'magic' attributes
    rename_column :images, :filename,     :image_name
    rename_column :images, :content_type, :image_mime_type
    rename_column :images, :size,         :image_size
    rename_column :images, :width,        :image_width
    rename_column :images, :height,       :image_height

    # Remove non-Dragonfly columns
    remove_column :images, :thumbnail
    remove_column :images, :image_type

    # Populate the image_uid column for Dragonfly
    Image.all.each do |i|
      i.update_attributes(:image_uid => ("%08d" % i.id).scan(/..../).join('/') << '/' << i.image_name,
                          :image_ext => i.image_name.split('.').last)
    end

    # Remove child records, used by attachment_fu only
    Image.delete_all('parent_id is not null')
    remove_column :images, :parent_id
  end

  def self.down
    remove_column :images, :image_uid
    remove_column :images, :image_ext

    rename_column :images, :image_name,      :filename
    rename_column :images, :image_mime_type, :content_type
    rename_column :images, :image_size,      :size
    rename_column :images, :image_width,     :width
    rename_column :images, :image_height,    :height

    add_column :images, :thumbnail,  :string
    add_column :images, :parent_id,  :integer
    add_column :images, :image_type, :string
  end
end
