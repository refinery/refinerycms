class Resource < ActiveRecord::Base
    
  has_attachment :storage => :file_system,
		      :size => 0.kilobytes..50.megabytes,
          :path_prefix => 'public/system/resources'

  def validate
    errors.add_to_base("You must choose a file to upload") unless self.filename
    
    unless self.filename.nil?
      [:size].each do |attr_name|
        enum = attachment_options[attr_name]
        unless enum.nil? || enum.include?(send(attr_name))
          errors.add_to_base("Files should be smaller than 50 MB in size")
        end
      end
    end
    
  end

	def title
		(split_filename = self[:filename].split('.')).pop and return split_filename.join('.').titleize
	end
  
end