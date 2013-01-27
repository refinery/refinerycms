require 'dragonfly'

module Refinery
  class Resource < Refinery::Core::BaseModel
    ::Refinery::Resources::Dragonfly.setup!

    include Resources::Validators

    attr_accessible :id, :file

    resource_accessor :file

    validates :file, :presence => true
    validates_with FileSizeValidator

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
        dialog ? Resources.pages_per_dialog : Resources.pages_per_admin_index
      end

      def create_resources(params)
        resources = []

        unless params.present? and params[:file].is_a?(Array)
          resources << create(params)
        else
          params[:file].each do |resource|
            resources << create({:file => resource}.merge(params.except(:file)))
          end
        end

        resources
      end
    end
  end
end
