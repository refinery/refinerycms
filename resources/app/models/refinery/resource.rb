module ::Refinery
  class Resource < ActiveRecord::Base

    attr_accessible :id, :file
    # What is the max resource size a user can upload
    MAX_SIZE_IN_MB = 50

    resource_accessor :file

    validates :file, :presence => true
    validates_size_of :file, :maximum => MAX_SIZE_IN_MB.megabytes,
                             :message => :too_big, :size => MAX_SIZE_IN_MB

    # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
    acts_as_indexed :fields => [:file_name, :title, :type_of_content]

    # when a dialog pops up with resources, how many resources per page should there be
    PAGES_PER_DIALOG = 12

    # when listing resources out in the admin area, how many resources should show per page
    PAGES_PER_ADMIN_INDEX = 20

    delegate :ext, :size, :mime_type, :url, :to => :file

    # used for searching
    def type_of_content
      mime_type.split("/").join(" ")
    end

    # Returns a titleized version of the filename
    # my_file.pdf returns My File
    def title
      CGI::unescape(file_name.to_s).gsub(/\.\w+$/, '').titleize
    end

    class << self
      # How many resources per page should be displayed?
      def per_page(dialog = false)
        dialog ? PAGES_PER_DIALOG : PAGES_PER_ADMIN_INDEX
      end

      def create_resources(params)
        resources = []

        unless params.present? and params[:file].is_a?(Array)
          resources << create(params)
        else
          params[:file].each do |resource|
            resources << create(:file => resource)
          end
        end

        resources
      end
    end
  end
end
