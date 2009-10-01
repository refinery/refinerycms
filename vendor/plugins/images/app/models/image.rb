class Image < ActiveRecord::Base
  
  has_many :pages

  has_attachment :content_type => :image, 
                 :storage => :file_system,
                 :path_prefix => 'public/system/images',
                 :processor => 'Rmagick', 
                 :thumbnails => ((RefinerySetting.find_or_set(:image_thumbnails, Hash.new)) rescue Hash.new),
                 :max_size => 5.megabytes

  acts_as_indexed :fields => [:title]

  def validate
   errors.add_to_base("You must choose a file to upload") unless self.filename

   unless self.filename.nil?
     [:size].each do |attr_name|
       enum = attachment_options[attr_name]
       
       errors.add_to_base("Files should be smaller than 50 MB in size") unless enum.nil? || enum.include?(send(attr_name))
     end
   end

  end
  
  def title
    self.filename.gsub(/\.\w+$/, '').titleize
  end
  
  def self.per_page(dialog=false)
    size = !dialog ? 20 : 18
  end
  
  def self.last_page(images, dialog=false)
    page = unless images.size <= self.per_page(dialog)
      (images.size / self.per_page(dialog).to_f).ceil
    else
      nil # this must be nil, it can't be 0 as there apparently isn't a 0th page.
    end
  end
  
  def self.thumbnails
    find(:all, :conditions => "parent_id not null")
  end
  
  def self.originals
    find_all_by_parent_id(nil)
  end
  
end