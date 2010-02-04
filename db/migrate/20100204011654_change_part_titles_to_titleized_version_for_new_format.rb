class ChangePartTitlesToTitleizedVersionForNewFormat < ActiveRecord::Migration
  def self.up
    PagePart.all.each do |page_part|
      page_part.update_attribute(:title, page_part.title.titleize)
    end
  end

  def self.down
    PagePart.all.each do |page_part|
      page_part.update_attribute(:title, page_part.title.downcase.gsub(" ", "_"))
    end
  end
end
