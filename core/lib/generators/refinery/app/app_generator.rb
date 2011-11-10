require 'thor'
require 'thor/group'
require 'rails/generators'

module Refinery
  class AppGenerator < Rails::Generators::Base
    
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
    
    def run!
      @rails_version_to_use = options[:rails_version] || rails_version_in_path
      
      validate_options!
      generate_rails!
    end
    
    protected
    
      def validate_options!
        app_name = app_path.split(File::SEPARATOR).last
        
        unless valid_rails_version?(@rails_version_to_use)
          puts "\nRails #{@rails_version_to_use} is not supported by Refinery #{Refinery.version}, " \
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
      
      def generate_rails!
        # Generate a rails application
        rails_command = "rails _#{@rails_version_to_use}_ new \"#{app_path}\""
        rails_command << " --database #{options[:adapter]}"
        rails_command << " --force" if options[:force]
        rails_command << " --skip-test-unit"
        rails_command << " --skip-bundle" # Rails automatically installs the bundle, but so do we!
        rails_command << " -m http://jruby.org" if defined? JRUBY_VERSION
        
        rails_output = nil
        inside(app_path) do
          rails_output = run(rails_command, :verbose => false, :capture => true)
        end
        puts app_path
        puts rails_output
  
        # Detect non-success or a blank rails output or starting with "Can't initialize" or "Error"
        if !$?.success? or rails_output.to_s.length == 0 or rails_output =~ /^(Can't\ initialize|Error)/
          puts "\nGenerating Rails application failed. Exiting..."
          if run('gem list rails', :verbose => false, :capture => true) !~ %r{[( ]#{@rails_version_to_use}(.0)*[,\)]}
            puts "\nDo you have Rails #{@rails_version_to_use} installed?"
          end
          puts "\n"
          exit(1)
        else
          if defined? JRUBY_VERSION
            find_and_replace(app_path.join('Gemfile'), /['|"]sqlite3['|"]/, "'activerecord-jdbcsqlite3-adapter'")
          end

          # Remove rails from the Gemfile so that Refinery can manage it
          find_and_replace('Gemfile', %r{^gem 'rails'}, "# gem 'rails'")
  
          # Override database host
          if options[:host] != 'localhost' && (adapter = options[:adapter]) != 'sqlite3'
            adapter = 'mysql2' if adapter == 'mysql'
            find_and_replace('config/database.yml', "\n  adapter: #{adapter}", "\n  adapter: #{adapter}\n  host: #{options[:host]}")
          end
  
          # Override database username and password
          if options[:ident]
            find_and_replace('config/database.yml', %r{username:}, '#username:')
            find_and_replace('config/database.yml', %r{password:}, '#password:')
          else
            find_and_replace('config/database.yml', %r{username:.*}, "username: #{options[:username]}")
            find_and_replace('config/database.yml', %r{password:.*}, "password: \"#{options[:password]}\"")
          end
  
          puts "\n---------"
          puts "Refinery successfully installed in '#{@app_path}'!\n\n"
        end
      end
      
    private
    
      def find_and_replace(file, find, replace)
        contents = File.read(File.join(@app_path, file)).gsub!(find, replace)
        File.open(File.join(@app_path, file), "w") do |f|
          f.puts contents
        end
      end
      
      def valid_rails_version?(rails_version)
        !rails_version !~ %r{\b#{RAILS_MINOR_VERSION}}
      end
      
      def valid_app_name?(app_name)
        !self.class.reserved_app_names.include?(app_name.downcase)
      end
      
      # Returns a string representation of the rails version of what is currently found in your path
      def rails_version_in_path
        @rails_version_in_path ||= run('rails --version', :verbose => false, :capture => true).to_s.gsub(/(Rails |\n)/, '')
      end
  end
end
