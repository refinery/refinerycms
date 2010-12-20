require 'refinery/generators'

class RefinerycmsGenerator < ::Refinery::Generators::EngineInstaller

  engine_name :refinerycms
  source_root Refinery.root.join(*%w[core lib generators templates])

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
    %w(public/index.html app/views/layouts/application.html.erb config/cucumber.yml).each do |roadblock|
      if (roadblock = Rails.root.join(roadblock)).file?
        create_file "your_#{roadblock.split.last}", :verbose => true do roadblock.read end
        remove_file roadblock, :verbose => true
      end
    end

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

    # Ensure the config.serve_static_assets setting is present and enabled
    %w(development test production).map{|e| "config/environments/#{e}.rb"}.each do |env|
      gsub_file env, %r{#.*config.serve_static_assets}, 'config.serve_static_assets'

      gsub_file env, "serve_static_assets = false", "serve_static_assets = true # Refinery CMS requires this to be true"

      append_file env, "Refinery.rescue_not_found = #{env.split('/').last.split('.rb').first == 'production'}"
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

    # Overwrite rails defaults with refinery defaults and other 'important files'
    ['spec/*.*', '.rspec', 'config/cucumber.yml'].map{|f| Dir[self.class.source_root.join(f)]}.flatten.each do |file|
      copy_file file, file.sub(%r{#{self.class.source_root}/?}, ''),
                :verbose => true
    end

    # Append seeds.
    append_file 'db/seeds.rb', :verbose => true do
      self.class.source_root.join('db', 'seeds.rb').read
    end

    existing_source_root = self.class.source_root
    # Seeds and migrations now need to be copied from their various engines.
    ::Refinery::Plugins.registered.pathnames.reject{|p| !p.join('db').directory?}.each do |pathname|
      self.class.source_root pathname
      super
    end
    self.class.source_root existing_source_root

    # When we're inside Refinery we don't need the migrations.
    unless Rails.root == Refinery.root
      # Change the source_root for database templates
      self.class.source_root Refinery.root

      # Call the engine generator.
      super
    end
  end

end
