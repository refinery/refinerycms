require 'pathname'

module Refinery
  class CmsGenerator < Rails::Generators::Base
    source_root Pathname.new(File.expand_path('../templates', __FILE__))

    class_option :update,  :type => :boolean, :aliases => nil, :group => :runtime,
                           :desc => "Update an existing Refinery CMS based application"
    class_option :fresh_installation, :type => :boolean, :aliases => nil, :group => :runtime, :default => false,
                           :desc => "Allow Refinery to remove default Rails files in a fresh installation"
    class_option :heroku,  :type => :string, :default => nil, :group => :runtime, :banner => 'APP_NAME',
                           :desc => "Deploy to Heroku after the generator has run."
    class_option :stack,   :type => :string, :default => 'cedar', :group => :runtime,
                           :desc => "Specify which Heroku stack you want to use. Requires --heroku option to function."
    class_option :skip_db, :type => :boolean, :default => false, :aliases => nil, :group => :runtime,
                           :desc => "Skip over any database creation, migration or seeding."
    class_option :skip_migrations, :type => :boolean, :default => false, :aliases => nil, :group => :runtime,
                           :desc => "Skip over installing or running migrations."

    def generate
      start_pretending?

      manage_roadblocks! unless self.options[:update]

      ensure_environments_are_sane!

      stop_pretending?

      append_gemfile!

      append_gitignore!

      append_asset_pipeline!

      forced_overwriting?

      copy_files!

      create_decorators!

      mount!

      run_additional_generators! if self.options[:fresh_installation]

      migrate_database!

      seed_database!

      deploy_to_hosting?
    end

  protected

    def append_asset_pipeline!
      application_css = 'app/assets/stylesheets/application.css'
      if destination_path.join(application_css).file?
        insert_into_file application_css, %q{*= require refinery/formatting
 *= require refinery/theme
 },      :before => "*= require_self"
      end
    end

    def append_gemfile!
      if destination_path.join('Gemfile').file? &&
         destination_path.join('Gemfile').read !~ %r{group :development, :test do\n.+?gem 'sqlite3'\nend}m
        gsub_file 'Gemfile', %q{gem 'sqlite3'}, %q{group :development, :test do
  gem 'sqlite3'
end}  end
    end

    def append_gitignore!
      # Ensure .gitignore exists and append our rules to it.
      create_file ".gitignore" unless destination_path.join('.gitignore').file?
      our_ignore_rules = self.class.source_root.join('.gitignore').read
      our_ignore_rules = our_ignore_rules.split('# REFINERY CMS DEVELOPMENT').first if destination_path != Refinery.root
      append_file ".gitignore", our_ignore_rules
    end

    def append_heroku_gems!
      append_file 'Gemfile', %q{
# The Heroku gem allows you to interface with Heroku's API
gem 'heroku'

# Fog allows you to use S3 assets (added for Heroku)
gem 'fog'
}
      # If postgres is not the database in use, Heroku still needs it.
      if destination_path.join('Gemfile').file? && destination_path.join('Gemfile').read !~ %r{gem ['"]pg['"]}
        append_file 'Gemfile', %q{
# Postgres support (added for Heroku)
gem 'pg'
}
      end
    end

    def bundle!
      run 'bundle install'
    end

    def copy_files!
      # The extension installer only installs database templates.
      Pathname.glob(self.class.source_root.join('**', '*')).reject{|f|
        f.directory? or f.to_s =~ /\/db\//
      }.sort.each do |path|
        copy_file path, path.to_s.gsub(self.class.source_root.to_s, destination_path.to_s)
      end
    end

    def create_decorators!
      # Create decorator directories
      %w[controllers models].each do |decorator_namespace|
        src_file_path = "app/decorators/#{decorator_namespace}/refinery/.gitkeep"
        copy_file self.class.source_root.join(src_file_path), destination_path.join(src_file_path)
      end
    end

    def deploy_to_hosting?
      if heroku?
        append_heroku_gems!

        bundle!

        # Sanity check the heroku application name and save whatever messages are produced.
        message = sanity_check_heroku_application_name!

        # Supply the deploy process with the previous messages to make them visible.
        deploy_to_hosting_heroku!(message)
      end
    end

    def deploy_to_hosting_heroku!(message = nil)
      say_status "Initializing and committing to git..", nil
      run "git init && git add . && git commit -am 'Created application using Refinery CMS #{Refinery.version}'"

      say_status message, nil, :yellow if message

      say_status "Creating Heroku app..", nil
      run ["heroku create",
           (options[:heroku] if heroku?),
           "#{"--stack #{options[:stack]}" if options[:stack]}"
          ].compact.join(' ')

      say_status "Pushing to Heroku (this takes time, be patient)..", nil
      run "git push heroku master"

      say_status "Setting up the Heroku database..", nil
      run "heroku#{' run' if options[:stack] == 'cedar'} rake db:migrate"

      say_status "Restarting servers...", nil
      run "heroku restart"
    end

    # Helper method to quickly convert destination_root to a Pathname for easy file path manipulation
    def destination_path
      @destination_path ||= Pathname.new(self.destination_root)
    end

    def ensure_environments_are_sane!
      # Massage environment files
      %w(development test production).map{|e| "config/environments/#{e}.rb"}.each do |env|
        next unless destination_path.join(env).file?

        # Refinery does not necessarily expect action_mailer to be available as
        # we may not always require it (currently only the authentication extension).
        # Rails, however, will optimistically place config entries for action_mailer.
        insert_into_file env, "  if config.respond_to?(:action_mailer)\n  ",
                              :before => %r{^[^#]+config\.action_mailer\.}, :verbose => false
        insert_into_file env, "\n  end",
                              :after => %r{^[^#]+config\.action_mailer\..*}, :verbose => false

        gsub_file env, "config.assets.compile = false", "config.assets.compile = true", :verbose => false
      end
    end

    def forced_overwriting?
      force_options = self.options.dup
      force_options[:force] = self.options[:force] || self.options[:update]
      self.options = force_options
    end

    def heroku?
      options[:heroku].present?
    end

    def manage_roadblocks!
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

    def migrate_database!
      unless self.options[:skip_migrations]
        rake 'railties:install:migrations'
        rake 'db:create db:migrate' unless self.options[:skip_db]
      end
    end

    def mount!
      if (routes_file = destination_path.join('config', 'routes.rb')).file? && (self.behavior == :revoke || (routes_file.read !~ %r{mount\ Refinery::Core::Engine}))
        # Append routes
        mount = %Q{
  # This line mounts Refinery's routes at the root of your application.
  # This means, any requests to the root URL of your application will go to Refinery::PagesController#home.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Refinery relies on it being the default of "refinery"
  mount Refinery::Core::Engine, :at => '/'

}

        inject_into_file 'config/routes.rb', mount, :after => "Application.routes.draw do\n"
      end
    end

    def run_additional_generators!
      generator_args = []
      generator_args << '--quiet' if self.options[:quiet]
      Refinery::CoreGenerator.start generator_args
      Refinery::AuthenticationGenerator.start generator_args if defined?(Refinery::AuthenticationGenerator)
      Refinery::ResourcesGenerator.start generator_args if defined?(Refinery::ResourcesGenerator)
      Refinery::PagesGenerator.start generator_args if defined?(Refinery::PagesGenerator)
      Refinery::ImagesGenerator.start generator_args if defined?(Refinery::ImagesGenerator)
      Refinery::I18nGenerator.start generator_args if defined?(Refinery::I18nGenerator)
    end

    def sanity_check_heroku_application_name!
      if heroku? && options[:heroku].to_s.include?('_') || options[:heroku].to_s.length > 30
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

        options[:heroku] = suggested_name

        message << "We have changed the name to '#{suggested_name}' for you, hope it suits you.\n"
        message.join("\n")
      end

      options[:heroku] = '' if options[:heroku] == 'heroku'
    end

    def seed_database!
      rake 'db:seed' unless self.options[:skip_db] || self.options[:skip_migrations]
    end

    def start_pretending?
      # Only pretend to do the next actions if this is Refinery to stay DRY
      if destination_path == Refinery.root
        say_status :'-- pretending to make changes that happen in an actual installation --', nil, :yellow
        old_pretend = self.options[:pretend]
        new_options = self.options.dup
        new_options[:pretend] = true
        self.options = new_options
      end
    end

    def stop_pretending?
      # Stop pretending
      if destination_path == Refinery.root
        say_status :'-- finished pretending --', nil, :yellow
        new_options = self.options.dup
        new_options[:pretend] = old_pretend
        self.options = new_options
      end
    end
  end
end
