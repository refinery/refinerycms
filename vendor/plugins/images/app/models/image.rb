class Image < ActiveRecord::Base

  has_many :pages

  has_attachment :content_type => :image,
                 :storage => (USE_S3_BACKEND ? :s3 : :file_system),
                 :path_prefix => (USE_S3_BACKEND ? nil : 'public/system/images'),
                 :processor => 'Rmagick',
                 :thumbnails => ((((thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {})).is_a?(Hash) ? thumbnails : (RefinerySetting[:image_thumbnails] = {}))) rescue {}),
                 :max_size => MAX_IMAGE_SIZE

  acts_as_indexed :fields => [:title],
          :index_file => [RAILS_ROOT,"tmp","index"]

  def validate
   errors.add_to_base(I18n.translate('no_file_chosen')) unless self.filename

   unless self.filename.nil?
     [:size].each do |attr_name|
       enum = attachment_options[attr_name]

       errors.add_to_base(I18n.translate('file_should_be_smaller_than_max_image_size', :max_image_size => ActionController::Base.helpers.number_to_human_size(MAX_IMAGE_SIZE) )) unless enum.nil? || enum.include?(send(attr_name))
     end
   end

  end

  def title
    self.filename.gsub(/\.\w+$/, '').titleize
  end

  def self.per_page(dialog = false)
    size = (dialog ? 18 : 20)
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
