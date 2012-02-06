module Refinery
  class CmsGenerator < Rails::Generators::Base
    source_root Pathname.new(File.expand_path('../templates', __FILE__))

    class_option :update, :type => :boolean, :aliases => nil, :group => :runtime,
                          :desc => "Update an existing Refinery CMS based application"
    class_option :fresh_installation, :type => :boolean, :aliases => nil, :group => :runtime, :default => false,
                          :desc => "Allow Refinery to remove default Rails files in a fresh installation"

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
        %w(public/index.html app/views/layouts/application.html.erb).each do |roadblock|
          if (roadblock_path = destination_path.join(roadblock)).file?
            if self.options[:fresh_installation]
              remove_file roadblock_path, :verbose => true
            else
              say_status :"-- You may need to remove '#{roadblock}' for Refinery to function properly --", nil, :yellow
            end
          end
        end
      end

      # Massage environment files
      %w(development test production).map{|e| "config/environments/#{e}.rb"}.each do |env|
        next unless destination_path.join(env).file?

        gsub_file env, "config.assets.compile = false", "config.assets.compile = true", :verbose => false

        insert_into_file env,
                         "  # Refinery has set config.assets.initialize_on_precompile = false by default.\n  config.assets.initialize_on_precompile = false\n\n",
                         :after => "Application.configure do\n" if env == 'production'
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

      if self.behavior == :revoke || ((routes_file = destination_path.join('config/routes.rb')).file? && routes_file.read !~ %r{mount\ Refinery::Core::Engine})

        if destination_path.join('config/routes.rb').file?
          # Append routes
          mount = %Q{
  #  # This line mounts Refinery's routes at the root of your application.
  # This means, any requests to the root URL of your application will go to Refinery::PagesController#home.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Refinery relies on it being the default of "refinery"
  mount Refinery::Core::Engine, :at => '/'

}

          inject_into_file 'config/routes.rb', mount, :after => "Application.routes.draw do\n"
        end
      end

      if self.options[:fresh_installation]
        generator_args = []
        generator_args << '--quiet' if self.options[:quiet]
        Refinery::CoreGenerator.start generator_args
        Refinery::ResourcesGenerator.start generator_args
        Refinery::PagesGenerator.start generator_args
        Refinery::ImagesGenerator.start generator_args
        Refinery::I18nGenerator.start generator_args if defined?(Refinery::I18nGenerator)
      end
    end

  protected

    # Helper method to quickly convert destination_root to a Pathname for easy file path manipulation
    def destination_path
      @destination_path ||= Pathname.new(self.destination_root)
    end
  end
end
