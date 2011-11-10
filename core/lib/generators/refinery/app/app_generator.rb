require 'thor'
require 'thor/group'

module Refinery
  class AppGenerator < Thor::Group
    include Thor::Actions
    
    argument :app_path
    desc File.read(File.expand_path('../USAGE', __FILE__))
    
    source_root Pathname.new(File.expand_path('../templates', __FILE__))

    # General options
    class_option :force, :type => :boolean, :aliases => ['-f'], :default => false,
      :desc => "Force overwriting of directory"
    class_option :gems, :type => :array, :aliases => ['-g'],
      :desc => "Additional gems to install"
    class_option :heroku, :type => :string, :default => nil,
      :desc => "Set up and deploy to Heroku"
    class_option :confirm, :type => :boolean, :aliases => ['-c'], :default => false,
      :desc => "Confirm any prompts that require input"
    class_option :testing, :type => :boolean, :aliases => ['-t'], :default => true,
      :desc => "Automatically set up the project with refinerycms-testing support"
    class_option :trace, :type => :boolean, :default => false,
      :desc => "Investigate any problems with the installer"
    class_option :version, :type => :boolean, :default => false,
      :desc => "Display the installed version of RefineryCMS"
    
    # Database options
    class_option :adapter, :group => 'database', :type => :string, :aliases => ['-d'], :default => 'sqlite3',
      :desc => "Select the database adapter (default: sqlite3)"
    class_option :ident, :group => 'database', :type => :boolean, :default => false,
      :desc => "Use ident database authentication (for mysql or postgresql)"
    class_option :host, :group => 'database', :type => :string, :aliases => ['-h'], :default => 'localhost',
      :desc => "Set the database hostname"
    class_option :password, :group => 'database', :type => :string, :aliases => ['-p'], :default => 'refinery',
      :desc => "Set the database password"
    class_option :skip_db, :group => 'database', :type => :boolean, :default => false,
      :desc => "Skip any database creation or migration tasks"
    
    # Rails options
    class_option :rails_version, :group => 'rails', :type => :string, :aliases => ['-r'],
      :desc => "Override the version of rails used to generate your application"
    
    RAILS_MINOR_VERSION = '3.1'
    
    class << self
      def reserved_app_names
        @reserved_app_names ||= [
          'refinery',
          'refinerycms',
          'test',
          'testing',
          'rails'
        ]
      end
    end
    
    def generate
      validate_options!
      
      # nothing yet
    end
    
    protected
    
      def validate_options!
        app_name = app_path.split(File::SEPARATOR).last
        
        rails_version_to_use = options[:rails_version] || rails_version_in_path
        unless valid_rails_version?(rails_version_to_use)
          puts "\nRails #{rails_version_to_use} is not supported by Refinery #{Refinery.version}, " \
               "please use Rails #{RAILS_MINOR_VERSION}.x instead."
          puts "\nYou can tell Refinery CMS an installed and compatible rails version to use like so:\n"
          puts "\nrefinerycms #{app_name} --rails-version #{RAILS_MINOR_VERSION}"
          puts "\n"
          exit(1)
        end
        
        unless valid_app_name?(app_name)
          puts "\nYou can't use '#{app_name}' as a name for your project, this is a reserved word that will cause conflicts."
          puts "Please choose another name for your new project."
          puts "\n"
          exit(1)
        end
        
        unless options[:force] || !File.directory?(app_path)
          puts "\nThe directory '#{app_path}' that you specified already exists."
          puts "Use --force to overwrite an existing directory."
          puts "\n"
          exit(1)
        end
        
        if options[:heroku]
          if options[:heroku].to_s.include?('_') or options[:heroku].to_s.length > 30
            message = ["\nThe application name '#{options[:heroku]}' that you specified is invalid for Heroku."]
            suggested_name = options[:heroku].dup.to_s
            if suggested_name.include?('_')
              message << "This is because it contains underscores which Heroku does not allow."
              suggested_name.gsub!(/_/, '-')
            end
            if suggested_name.length > 30
              message << "This is#{" also" unless suggested_name.nil?} because it is longer than 30 characters."
              suggested_name = suggested_name[0..29]
            end

            if options[:force] || options[:confirm]
              options[:heroku] = suggested_name
            else
              message << "Please choose another name like '#{suggested_name}'"
              message << "Or use --confirm to automatically use '#{suggested_name}'"
              message << "\n"
              puts message.join("\n")
              exit(1)
            end
          end
        end
      end
      
      def valid_rails_version?(rails_version)
        !rails_version !~ %r{\b#{RAILS_MINOR_VERSION}}
      end
      
      def valid_app_name?(app_name)
        !self.class.reserved_app_names.include?(app_name.downcase)
      end
      
    private
      
      # Returns a string representation of the rails version of what is currently found in your path
      def rails_version_in_path
        @rails_version_in_path ||= run('rails --version', :verbose => false, :capture => true).to_s.gsub(/(Rails |\n)/, '')
      end
  end
end
