class Resource < ActiveRecord::Base

  # Docs for attachment_fu http://github.com/technoweenie/attachment_fu
  has_attachment :storage => (USE_S3_BACKEND ? :s3 : :file_system),
                 :size => 0.kilobytes..50.megabytes,
                 :path_prefix => (USE_S3_BACKEND ? nil : 'public/system/resources')

  def validate
    if self.filename.nil?
      errors.add_to_base("You must choose a file to upload")
    else
      [:size].each do |attr_name|
        enum = attachment_options[attr_name]
        unless enum.nil? || enum.include?(send(attr_name))
          errors.add_to_base("Files should be smaller than 50 MB in size") if attr_name == :size
        end
      end
    end
  end

  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title, :type_of_content],
                  :index_file => [Rails.root.to_s, "tmp", "index"]

  # when a dialog pops up with images, how many images per page should there be
  PAGES_PER_DIALOG = 12

  # when listing images out in the admin area, how many images should show per page
  PAGES_PER_ADMIN_INDEX = 20

  # How many images per page should be displayed?
  def self.per_page(dialog = false)
    dialog ? PAGES_PER_DIALOG : PAGES_PER_ADMIN_INDEX
  end

  # used for searching
  def type_of_content
    self.content_type.split("/").join(" ")
  end

  # Returns a titleized version of the filename
  # my_file.pdf returns My File
  def title
    CGI::unescape(self.filename).gsub(/\.\w+$/, '').titleize
  end

end
