class AddCachedSlugToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :cached_slug, :string
    Page.all.each do |p|
      p.save!
    end
  end

  def self.down
    remove_column :pages, :cached_slug
  end
end
