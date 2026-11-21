# frozen_string_literal: true

require 'dragonfly'

module Refinery
  class Resource < Refinery::Core::BaseModel
    include Resources::Validators

    extend Mobility
    translates :resource_title

    dragonfly_accessor :file, app: :refinery_resources

    validates :file, presence: true
    validates_with FileSizeValidator
    validates_property :mime_type,
                       of: :file,
                       in: ::Refinery::Resources.whitelisted_mime_types,
                       message: :incorrect_format

    delegate :ext, :size, :mime_type, :url, to: :file

    before_save :sanitize_svg
    before_destroy :cached_mime_type, prepend: true

    def cached_mime_type
      @cached_mime_type ||= mime_type
    end

    # used for searching
    def type_of_content
      cached_mime_type.split('/').join(' ')
    end

    # Returns a titleized version of the filename
    # my_file.pdf returns My File
    def title
      resource_title.presence || CGI.unescape(file_name.to_s).gsub(/\.\w+$/, '').titleize
    end

    def update_index
      return if aai_config.disable_auto_indexing
      copy = dup.tap { |r| r.file_uid = r.file_uid_was }
      self.class.index_remove(copy)
      self.class.index_add(self)
    end

    private

    def sanitize_svg
      return unless file.present? && file.mime_type.to_s == 'image/svg+xml'

      data = file.data
      doc = Nokogiri::XML(data)
      doc.xpath('//*[local-name()="script"]').remove
      doc.xpath('//@*[starts-with(local-name(), "on")]').remove
      doc.xpath('//@*[local-name()="href" and starts-with(normalize-space(.), "javascript:")]').remove

      cleaned = doc.to_xml
      return if cleaned == data

      original_name = file.name
      io = StringIO.new(cleaned)
      io.define_singleton_method(:original_filename) { original_name }
      self.file = io
    end

    public

    class << self
      # How many resources per page should be displayed?
      def per_page(dialog = false)
        dialog ? Resources.pages_per_dialog : Resources.pages_per_admin_index
      end

      def create_resources(params)
        resources = []

        if params.present? && params[:file].is_a?(Array)
          params[:file].each do |resource|
            resources << create({ file: resource }.merge(params.except(:file).to_h))
          end
        else
          resources << create(params)
        end

        resources
      end
    end
  end
end
