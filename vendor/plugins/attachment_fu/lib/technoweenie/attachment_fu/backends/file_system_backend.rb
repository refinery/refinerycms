require 'fileutils'
require 'digest/sha2'

module Technoweenie # :nodoc:
  module AttachmentFu # :nodoc:
    module Backends
      # Methods for file system backed attachments
      module FileSystemBackend
        def self.included(base) #:nodoc:
          base.before_update :rename_file
        end

        # Gets the full path to the filename in this format:
        #
        #   # This assumes a model name like MyModel
        #   # public/#{table_name} is the default filesystem path
        #   RAILS_ROOT/public/my_models/5/blah.jpg
        #
        # Overwrite this method in your model to customize the filename.
        # The optional thumbnail argument will output the thumbnail's filename.
        def full_filename(thumbnail = nil)
          file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
          File.join(RAILS_ROOT, file_system_path, *partitioned_path(thumbnail_name_for(thumbnail)))
        end

        # Used as the base path that #public_filename strips off full_filename to create the public path
        def base_path
          @base_path ||= File.join(RAILS_ROOT, 'public')
        end

        # The attachment ID used in the full path of a file
        def attachment_path_id
          ((respond_to?(:parent_id) && parent_id) || id) || 0
        end

        # Partitions the given path into an array of path components.
        #
        # For example, given an <tt>*args</tt> of ["foo", "bar"], it will return
        # <tt>["0000", "0001", "foo", "bar"]</tt> (assuming that that id returns 1).
        #
        # If the id is not an integer, then path partitioning will be performed by
        # hashing the string value of the id with SHA-512, and splitting the result
        # into 4 components. If the id a 128-bit UUID (as set by :uuid_primary_key => true)
        # then it will be split into 2 components.
        #
        # To turn this off entirely, set :partition => false.
        def partitioned_path(*args)
          if respond_to?(:attachment_options) && attachment_options[:partition] == false
            args
          elsif attachment_options[:uuid_primary_key]
            # Primary key is a 128-bit UUID in hex format. Split it into 2 components.
            path_id = attachment_path_id.to_s
            component1 = path_id[0..15] || "-"
            component2 = path_id[16..-1] || "-"
            [component1, component2] + args
          else
            path_id = attachment_path_id
            if path_id.is_a?(Integer)
              # Primary key is an integer. Split it after padding it with 0.
              ("%08d" % path_id).scan(/..../) + args
            else
              # Primary key is a String. Hash it, then split it into 4 components.
              hash = Digest::SHA512.hexdigest(path_id.to_s)
              [hash[0..31], hash[32..63], hash[64..95], hash[96..127]] + args
            end
          end
        end

        # Gets the public path to the file
        # The optional thumbnail argument will output the thumbnail's filename.
        def public_filename(thumbnail = nil)
          full_filename(thumbnail).gsub %r(^#{Regexp.escape(base_path)}), ''
        end

        def filename=(value)
          @old_filename = full_filename unless filename.nil? || @old_filename
          write_attribute :filename, sanitize_filename(value)
        end

        # Creates a temp file from the currently saved file.
        def create_temp_file
          copy_to_temp_file full_filename
        end

        protected
          # Destroys the file.  Called in the after_destroy callback
          def destroy_file
            FileUtils.rm full_filename
            # remove directory also if it is now empty
            Dir.rmdir(File.dirname(full_filename)) if (Dir.entries(File.dirname(full_filename))-['.','..']).empty?
          rescue
            logger.info "Exception destroying  #{full_filename.inspect}: [#{$!.class.name}] #{$1.to_s}"
            logger.warn $!.backtrace.collect { |b| " > #{b}" }.join("\n")
          end

          # Renames the given file before saving
          def rename_file
            return unless @old_filename && @old_filename != full_filename
            if save_attachment? && File.exists?(@old_filename)
              FileUtils.rm @old_filename
            elsif File.exists?(@old_filename)
              FileUtils.mv @old_filename, full_filename
            end
            @old_filename =  nil
            true
          end

          # Saves the file to the file system
          def save_to_storage
            if save_attachment?
              # TODO: This overwrites the file if it exists, maybe have an allow_overwrite option?
              FileUtils.mkdir_p(File.dirname(full_filename))
              FileUtils.cp(temp_path, full_filename)
              FileUtils.chmod(attachment_options[:chmod] || 0644, full_filename)
            end
            @old_filename = nil
            true
          end

          def current_data
            File.file?(full_filename) ? File.read(full_filename) : nil
          end
      end
    end
  end
end
