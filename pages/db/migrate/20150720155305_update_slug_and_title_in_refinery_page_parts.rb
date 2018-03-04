class UpdateSlugAndTitleInRefineryPageParts < ActiveRecord::Migration[4.2]
  def change
    begin
      ::Refinery::PagePart.all.each do |pp|
        pp.title ||= pp.slug
        pp.slug = pp.slug.downcase.gsub(" ", "_")
        pp.save!
      end
    rescue NameError
      warn "Refinery::PagePart was not defined!"
    end
  end
end
