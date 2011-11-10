require 'rails/generators'

module Refinery
  class AppGenerator < Rails::Generators::Base
    
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
    class_option :version, :group => 'rails', :type => :string, :aliases => ['-r'],
      :desc => "Override the version of rails used to generate your application"
    
    def generate
      # nothing yet
    end

  end
end
