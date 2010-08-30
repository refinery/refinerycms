class Resource < ActiveRecord::Base

  # What is the max resource size a user can upload
  MAX_SIZE_IN_MB = 50

  resource_accessor :file

  validates :file, :presence => { :message => I18n.t('file_specify_for_upload') },
                   :length   => { :maximum => MAX_SIZE_IN_MB.megabytes,
                                  :message => I18n.t('file_should_be_smaller_than_max_file_size',
                                                     :max_file_size => MAX_SIZE_IN_MB.megabytes) }

   # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
   acts_as_indexed :fields => [:file_name, :title, :type_of_content]

  # when a dialog pops up with images, how many images per page should there be
  PAGES_PER_DIALOG = 12

  # when listing images out in the admin area, how many images should show per page
  PAGES_PER_ADMIN_INDEX = 20

  delegate :ext, :size, :mime_type, :url, :to => :file

  # How many images per page should be displayed?
  def self.per_page(dialog = false)
    dialog ? PAGES_PER_DIALOG : PAGES_PER_ADMIN_INDEX
  end

  # used for searching
  def type_of_content
    self.mime_type.split("/").join(" ")
  end

  # Returns a titleized version of the filename
  # my_file.pdf returns My File
  def title
    CGI::unescape(self.file_name).gsub(/\.\w+$/, '').titleize
  end

end
