require 'dragonfly'

module Refinery
  class Resource < Refinery::Core::BaseModel
    include Resources::Validators

    translates :resource_title

    attribute :resource_title

    dragonfly_accessor :file, :app => :refinery_resources

    validates :file, :presence => true
    validates_with FileSizeValidator

    delegate :ext, :size, :mime_type, :url, :to => :file

    before_destroy :cached_mime_type, :prepend => true

    def cached_mime_type
      @cached_mime_type ||= mime_type
    end

    # used for searching
    def type_of_content
      cached_mime_type.split("/").join(" ")
    end

    # Returns a titleized version of the filename
    # my_file.pdf returns My File
    def title
      resource_title.presence || CGI::unescape(file_name.to_s).gsub(/\.\w+$/, '').titleize
    end

    def update_index
      return if self.aai_config.disable_auto_indexing
      copy = self.dup.tap{ |r| r.file_uid = r.file_uid_was}
      self.class.index_remove(copy)
      self.class.index_add(self)
    end

    class << self
      # How many resources per page should be displayed?
      def per_page(dialog = false)
        dialog ? Resources.pages_per_dialog : Resources.pages_per_admin_index
      end

      def create_resources(params)
        resources = []

        if params.present? and params[:file].is_a?(Array)
          params[:file].each do |resource|
            resources << create({:file => resource}.merge(params.except(:file).to_h))
          end
        else
          resources << create(params)
        end

        resources
      end
    end
  end
end
