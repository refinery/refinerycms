require 'fileutils'

class RefinerycmsGenerator < ::Refinery::Generators::EngineInstaller

  engine_name :refinerycms
  source_root Refinery.root

  def generate
    # First, effectively move / rename files that get in the way of Refinery CMS
    %w(public/index.html app/views/layouts/application.html.erb config/cucumber.yml).each do |roadblock|
      if (roadblock = Rails.root.join(roadblock)).file?
        append_file "your_#{roadblock.split.last}", :verbose => true do roadblock.read end
        remove_file roadblock, :verbose => true
      end
    end

    # Append seeds.
    append_file 'db/seeds.rb', :verbose => true do
      Refinery.root.join('db', 'seeds.rb').read
    end

    # Overwrite rails defaults with refinery defaults
    Dir[Refinery.root.join('spec', '*.*').to_s].each do |file|
      copy_file file, :verbose => true
    end

    # Copy in 'important' files to the Rails app.
    %w(.rspec config/cucumber.yml).map{|f| Refinery.root.join(f)}.reject{|f| !f.exist?}.each do |file|
      copy_file Refinery.root.join(file), :verbose => true
    end

    # Copy asset files (JS, CSS) so they're ready to use.
    %w(application.css formatting.css home.css theme.css).map{ |ss|
      Refinery.root.join('vendor', 'refinerycms', 'core', 'public', 'stylesheets', ss)
    }.reject{|ss| !ss.file?}.each do |stylesheet|
      copy_file stylesheet,
                Rails.root.join('public', 'stylesheets', stylesheet.split.last),
                :verbose => true
    end
    copy_file Refinery.root.join('vendor', 'refinerycms', 'core', 'public', 'javascripts', 'admin.js'),
              Rails.root.join('public', 'javascripts', 'admin.js'),
              :verbose => true


    # Ensure the config.serve_static_assets setting is present and enabled
    %w(development test production).map{|e| "config/environments/#{e}.rb"}.each do |env|
      contents = Rails.root.join(env).read
      contents.gsub! %r{#.*config.serve_static_assets}, 'config.serve_static_assets'
      contents.gsub! "serve_static_assets = false", "serve_static_assets = true # Refinery CMS requires this to be true"

      Rails.root.join(env).open('w') { |file| file.puts(contents) }

      append_file env, "Refinery.rescue_not_found = #{env.split('/').last.split('.rb').first == 'production'}"
    end

    # Ensure .gitignore exists and append our stuff to it.
    append_file ".gitignore", Refinery.root.join('.gitignore').read.split('# REFINERY CMS DEVELOPMENT').first

    super
  end

end
