require 'refinery/generators'

class RefinerycmsGenerator < ::Refinery::Generators::EngineInstaller

  engine_name :refinerycms
  source_root Pathname.new(File.expand_path('../templates', __FILE__))

  class_option :update, :type => :boolean, :aliases => nil, :group => :runtime,
                        :desc => "Update an existing Refinery CMS based application"

  def generate
    # Ensure the generator doesn't output anything using 'puts'
    self.silence_puts = true

    # Only pretend to do the next actions if this is Refinery to stay DRY
    if Rails.root == Refinery.root
      say_status :'-- pretending to make changes that happen in an actual installation --', nil, :yellow
      old_pretend = self.options[:pretend]
      new_options = self.options.dup
      new_options[:pretend] = true
      self.options = new_options
    end

    # First, effectively move / rename files that get in the way of Refinery CMS
    %w(public/index.html config/cucumber.yml app/views/layouts/application.html.erb).each do |roadblock|
      if (roadblock_path = Rails.root.join(roadblock)).file?
        create_file "#{roadblock}.backup",
                    :verbose => true do roadblock_path.read end
        remove_file roadblock_path, :verbose => true
      end
    end

    unless self.options[:update]
      # Copy asset files (JS, CSS) so they're ready to use.
      %w(application.css formatting.css home.css theme.css).map{ |ss|
        Refinery.root.join('core', 'public', 'stylesheets', ss)
      }.reject{|ss| !ss.file?}.each do |stylesheet|
        copy_file stylesheet,
                  Rails.root.join('public', 'stylesheets', stylesheet.split.last),
                  :verbose => true
      end
      copy_file Refinery.root.join('core', 'public', 'javascripts', 'admin.js'),
                Rails.root.join('public', 'javascripts', 'admin.js'),
                :verbose => true
    end

    # Ensure the config.serve_static_assets setting is present and enabled
    %w(development test production).map{|e| "config/environments/#{e}.rb"}.each do |env|
      gsub_file env, %r{#.*config.serve_static_assets}, 'config.serve_static_assets', :verbose => false

      gsub_file env, "serve_static_assets = false", "serve_static_assets = true # Refinery CMS requires this to be true", :verbose => false

      unless Rails.root.join(env).read =~ %r{Refinery.rescue_not_found}
        append_file env, "Refinery.rescue_not_found = #{env.split('/').last.split('.rb').first == 'production'}"
      end
    end

    # Stop pretending
    if Rails.root == Refinery.root
      say_status :'-- finished pretending --', nil, :yellow
      new_options = self.options.dup
      new_options[:pretend] = old_pretend
      self.options = new_options
    end

    # Ensure .gitignore exists and append our rules to it.
    create_file ".gitignore" unless Rails.root.join('.gitignore').file?
    our_ignore_rules = self.class.source_root.join('.gitignore').read
    our_ignore_rules = our_ignore_rules.split('# REFINERY CMS DEVELOPMENT').first if Rails.root != Refinery.root
    append_file ".gitignore", our_ignore_rules

    # If the admin/base_controller.rb file exists, ensure it does not do the old inheritance
    if (admin_base = Rails.root.join('app', 'controllers', 'admin', 'base_controller.rb')).file?
      gsub_file admin_base,
                "# You can extend refinery backend with your own functions here and they will likely not get overriden in an update.",
                "",
                :verbose => self.options[:update]

      gsub_file admin_base, "< Refinery::AdminBaseController", "< ActionController::Base",
                :verbose => self.options[:update]
    end


    # Append seeds.
    append_file 'db/seeds.rb', :verbose => true do
      self.class.source_root.join('db', 'seeds.rb').read
    end

    # Seeds and migrations now need to be copied from their various engines.
    existing_source_root = self.class.source_root
    ::Refinery::Plugins.registered.pathnames.reject{|p| !p.join('db').directory?}.sort.each do |pathname|
      self.class.source_root pathname
      super
    end
    self.class.source_root existing_source_root

    super

    # The engine installer only installs database templates.
    Pathname.glob(self.class.source_root.join('**', '*')).reject{|f|
      f.directory? or f.to_s =~ /\/db\//
    }.sort.each do |path|
      copy_file path, path.to_s.gsub(self.class.source_root.to_s, Rails.root.to_s)
    end
  end

end
