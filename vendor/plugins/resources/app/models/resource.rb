class Resource < ActiveRecord::Base

  has_attachment :storage => (USE_S3_BACKEND ? :s3 : :file_system),
          :size => 0.kilobytes..50.megabytes,
          :path_prefix => (USE_S3_BACKEND ? nil : 'public/system/resources')

  acts_as_indexed :fields => [:title, :type_of_content],
          :index_file => [RAILS_ROOT,"tmp","index"]

  def validate
    errors.add_to_base(t('.must_choose_file')) unless self.filename

    unless self.filename.nil?
      [:size].each do |attr_name|
        enum = attachment_options[attr_name]
        unless enum.nil? || enum.include?(send(attr_name))
          errors.add_to_base(t('.file_should_be_smaller_than_50mb'))
        end
      end
    end

  end

  # used for searching
  def type_of_content
    self.content_type.split("/").join(" ")
  end

  def title
    (split_filename = self[:filename].split('.')).pop and return split_filename.join('.').titleize
  end

  def self.per_page(dialog = false)
    size = (dialog ? 12 : 20)
  end

end
