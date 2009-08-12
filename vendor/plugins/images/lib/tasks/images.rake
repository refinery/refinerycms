namespace :images do

  desc "Regenerate all thumbnails. Useful for when you've changed size or cropping on the images after images have been uploaded."
  task :regenerate => :environment do
    thumbnails_size = Image.count(:conditions => "parent_id IS NOT NULL")
    puts "Preparing to delete #{thumbnails_size} generated thumbnails"
        
    if Image.destroy_all("parent_id IS NOT null")
      puts "--> #{thumbnails_size} thumbnails deleted"
    else
      puts "There may have been a problem deleting the thumbnails."
    end
    
    originals = Image.originals
    puts "Preparing to regenerate thumbnails for #{originals.size} images"
    amount_done = 0
    
    originals.each do |image|
      image.save
      amount_done += 1
      puts "--> #{amount_done}/#{originals.size} complete"
    end
    
    puts "Image regeneration complete."
  end
  
end