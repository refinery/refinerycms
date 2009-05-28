class RefineryGenerator < Rails::Generator::NamedBase
  
  def initialize(*runtime_args)
    super(*runtime_args)
    $title_name = singular_name.gsub("_", " ").gsub(/\b([a-z])/) { $1.capitalize }
  end
  
  def manifest
    record do |m|
      # Copy controller, model and migration
      directories = ["vendor/plugins/#{plural_name}", "vendor/plugins/#{plural_name}/app", "vendor/plugins/#{plural_name}/app/controllers", 
        "vendor/plugins/#{plural_name}/app/controllers/admin", "vendor/plugins/#{plural_name}/app/models", "vendor/plugins/#{plural_name}/app/views", 
        "vendor/plugins/#{plural_name}/app/helpers", "vendor/plugins/#{plural_name}/app/views", "vendor/plugins/#{plural_name}/app/views/admin",
        "vendor/plugins/#{plural_name}/config"]
      for dir in directories
        m.directory dir
      end
      
      m.template "controller.rb", "vendor/plugins/#{plural_name}/app/controllers/admin/#{plural_name}_controller.rb"
      m.template "model.rb", "vendor/plugins/#{plural_name}/app/models/#{singular_name}.rb"
      m.template "config/routes.rb", "vendor/plugins/#{plural_name}/config/routes.rb"
      
      m.directory 'db/migrate/'

      m.migration_template 'migration.rb', 'db/migrate', :assigns => {:migration_name => "Create#{class_name.pluralize}"}, :migration_file_name => "create_#{singular_name.pluralize}"
      
      # Create view directory
      view_dir = File.join("vendor/plugins/#{plural_name}/app/views/admin", plural_name)
      m.directory view_dir
      
      # Copy in all views
      view_files = ['index.html.erb', '_form.html.erb', '_list.html.erb', '_make_sortable.html.erb', 'edit.html.erb', 'new.html.erb', 'reorder.html.erb']
                    
      for file in view_files
        m.template "views/#{file}", "#{view_dir}/#{file}"
      end
      
      # Now for the public view and controller
      public_dir = File.join("vendor/plugins/#{plural_name}/app/views/", plural_name)
      m.directory public_dir
      
      m.template "views/show.html.erb", "#{public_dir}/show.html.erb"
      m.template "public_controller.rb", "vendor/plugins/#{plural_name}/app/controllers/#{plural_name}_controller.rb"

      # Add in the init file that ties the plugin to the app.
      m.template "init.rb", "vendor/plugins/#{plural_name}/init.rb"

      puts "IMPORTANT"
      puts "---------------------------------------"
      puts "Don't forgot to run 'rake db:migrate' to add the table to the DB"
      puts "---------------------------------------"
    end
  end

end