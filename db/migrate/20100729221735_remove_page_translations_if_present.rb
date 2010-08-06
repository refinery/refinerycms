class RemovePageTranslationsIfPresent < ActiveRecord::Migration
  def self.up
    begin
      drop_table :page_translations
    rescue
      puts "-- page_translations did not exist, all is well."
    end
  end

  def self.down
  end
end
