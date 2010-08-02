class Resource < ActiveRecord::Base

  # What is the max resource size a user can upload
  MAX_SIZE_IN_MB = 50

  # Docs for attachment_fu http://github.com/technoweenie/attachment_fu
  has_attachment :storage => (Refinery.s3_backend ? :s3 : :file_system),
                 :max_size => MAX_SIZE_IN_MB.megabytes,
                 :path_prefix => (Refinery.s3_backend ? nil : 'public/system/resources')

   # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
   acts_as_indexed :fields => [:filename, :title, :type_of_content]

  # we could use validates_as_attachment but it produces 4 odd errors like
  # "size is not in list". So we basically here enforce the same validation
  # rules here except display the error messages we want
  # This is a known problem when using attachment_fu
  def validate
    if self.filename.nil?
      errors.add_to_base(I18n.translate('must_choose_file'))
    else
      [:size].each do |attr_name|
        enum = attachment_options[attr_name]

        unless enum.nil? || enum.include?(send(attr_name))
          errors.add_to_base(I18n.translate('file_should_be_smaller_than_max_file_size',
                              :max_file_size => ActionController::Base.helpers.number_to_human_size(MAX_SIZE_IN_MB.megabytes) ))
        end
      end
    end
  end

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
