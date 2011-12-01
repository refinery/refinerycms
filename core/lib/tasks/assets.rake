# From http://stackoverflow.com/questions/7430578/how-to-universally-skip-database-touches-when-precompiling-assets-on-heroku/7528124#7528124
namespace :assets do
  # Prepend the assets:precompile_prepare task to assets:precompile.
  task :precompile => :precompile_prepare

  # This task will be called before assets:precompile to optimize the
  # compilation, i.e. to prevent any DB calls.
  task 'precompile_prepare' do
    # Without this assets:precompile will call itself again with this var set.
    # This basically speeds things up.
    ENV['RAILS_GROUPS'] = 'assets'

    # Devise uses this flag to prevent connecting to the db.
    ENV['RAILS_ASSETS_PRECOMPILE'] = 'true'
  end

end