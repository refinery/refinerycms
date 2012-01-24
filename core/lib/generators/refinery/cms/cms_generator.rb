module Refinery
  class CmsGenerator < Rails::Generators::Base
    source_root Pathname.new(File.expand_path('../templates', __FILE__))

    class_option :update, :type => :boolean, :aliases => nil, :group => :runtime,
                          :desc => "Update an existing Refinery CMS based application"

    def generate
      # Only pretend to do the next actions if this is Refinery to stay DRY
      if destination_path == Refinery.root
        say_status :'-- pretending to make changes that happen in an actual installation --', nil, :yellow
        old_pretend = self.options[:pretend]
        new_options = self.options.dup
        new_options[:pretend] = true
        self.options = new_options
      end

      unless self.options[:update]
        # First, effectively move / rename files that get in the way of Refinery CMS
        %w(public/index.html app/views/layouts/application.html.erb).each do |roadblock|
          if (roadblock_path = destination_path.join(roadblock)).file?
            create_file "#{roadblock}.backup",
                        :verbose => true do roadblock_path.read end
            remove_file roadblock_path, :verbose => true
          end
        end
      end

      # Massage environment files
      %w(development test production).map{|e| "config/environments/#{e}.rb"}.each do |env|
        next unless destination_path.join(env).file?

        gsub_file env, "config.assets.compile = false", "config.assets.compile = true", :verbose => false
      end

      # Stop pretending
      if destination_path == Refinery.root
        say_status :'-- finished pretending --', nil, :yellow
        new_options = self.options.dup
        new_options[:pretend] = old_pretend
        self.options = new_options
      end

      # Ensure .gitignore exists and append our rules to it.
      create_file ".gitignore" unless destination_path.join('.gitignore').file?
      our_ignore_rules = self.class.source_root.join('.gitignore').read
      our_ignore_rules = our_ignore_rules.split('# REFINERY CMS DEVELOPMENT').first if destination_path != Refinery.root
      append_file ".gitignore", our_ignore_rules

      # If the admin/base_controller.rb file exists, ensure it does not do the old inheritance
      if (admin_base = destination_path.join('app', 'controllers', 'refinery', 'admin_controller.rb')).file?
        gsub_file admin_base,
                  "# You can extend refinery backend with your own functions here and they will likely not get overriden in an update.",
                  "",
                  :verbose => self.options[:update]

        gsub_file admin_base, "< ::Refinery::AdminBaseController", "< ActionController::Base",
                  :verbose => self.options[:update]
      end

      # Append seeds.
      create_file "db/seeds.rb" unless destination_path.join('db', 'seeds.rb').file?
      append_file 'db/seeds.rb', :verbose => true do
        self.class.source_root.join('db', 'seeds.rb').read
      end

      force_options = self.options.dup
      force_options[:force] = self.options[:force] || self.options[:update]
      self.options = force_options

      # The engine installer only installs database templates.
      Pathname.glob(self.class.source_root.join('**', '*')).reject{|f|
        f.directory? or f.to_s =~ /\/db\//
      }.sort.each do |path|
        copy_file path, path.to_s.gsub(self.class.source_root.to_s, destination_path.to_s)
      end

      # Create decorator directories
      ['controllers', 'models'].each do |decorator_namespace|
        src_file_path = "app/decorators/#{decorator_namespace}/refinery/.gitkeep"
        copy_file self.class.source_root.join(src_file_path), destination_path.join(src_file_path)
      end
    end

    protected

      # Helper method to quickly convert destination_root to a Pathname for easy file path manipulation
      def destination_path
        @destination_path ||= Pathname.new(self.destination_root)
      end
  end
end
