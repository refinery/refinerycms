class UpdateSlugAndTitleInRefineryPageParts < ActiveRecord::Migration
  def change
    Refinery::PagePart.all.each do |pp|
      unless pp.title
        pp.title = pp.slug
      end
      pp.slug = pp.slug.downcase.gsub(" ", "_")
      pp.save!
    end
  end
end