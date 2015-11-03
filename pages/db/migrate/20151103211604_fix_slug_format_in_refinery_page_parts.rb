class FixSlugFormatInRefineryPageParts < ActiveRecord::Migration
  def change
    begin
      ::Refinery::PagePart.all.each do |pp|
        pp.slug = pp.slug.downcase.gsub(" ", "_")
        pp.save!
      end
    rescue NameError
      warn "Refinery::PagePart was not defined!"
    end
  end
end
