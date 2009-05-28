namespace :images do

  desc "Regenerate all thumbnails. Useful for when you've changed size or cropping on the images after images have been uploaded."
  task :regenerate => :environment do
    thumbnails = Image.find(:all, :conditions => "parent_id IS NOT NULL")
    puts "Preparing to delete #{thumbnails.size} generated thumbnails"
    
    amount_done = 0
    
    thumbnails.each do |image|
      image.destroy
      amount_done += 1
      puts "--> #{amount_done}/#{thumbnails.size} complete"
    end

    
    originals = Image.find(:all, :conditions => "parent_id IS NULL")
    puts "Preparing to regenerate thumbnails for #{originals.size} images"
    
    amount_done = 0
    
    originals.each do |image|
      image.save
      amount_done += 1
      puts "--> #{amount_done}/#{originals.size} complete"
    end
    
    puts "All thumbnails successfully regenerated."
  end
  
end