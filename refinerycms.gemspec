# Encoding: UTF-8
# DO NOT EDIT THIS FILE DIRECTLY! Instead, use lib/gemspec.rb to generate it.

Gem::Specification.new do |s|
  s.name              = %q{refinerycms}
  s.version           = %q{1.1.0}
  s.description       = %q{A Ruby on Rails CMS that supports Rails 3. It's easy to extend and sticks to 'the Rails way' where possible.}
<<<<<<< HEAD
  s.date              = %q{2011-08-09}
=======
  s.date              = %q{2011-08-04}
>>>>>>> Move factories into testing engine to share with engines
  s.summary           = %q{A Ruby on Rails CMS that supports Rails 3}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Resolve Digital', 'Philip Arndt', 'David Jones', 'Steven Heidel', 'Uģis Ozols']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)
  s.executables       = %w(refinerycms)

  # Bundler
  s.add_dependency    'bundler',                    '~> 1.0'

  # Refinery CMS
  s.add_dependency    'refinerycms-authentication', '= 1.1.0'
  s.add_dependency    'refinerycms-base',           '= 1.1.0'
  s.add_dependency    'refinerycms-core',           '= 1.1.0'
  s.add_dependency    'refinerycms-dashboard',      '= 1.1.0'
  s.add_dependency    'refinerycms-images',         '= 1.1.0'
  s.add_dependency    'refinerycms-pages',          '= 1.1.0'
  s.add_dependency    'refinerycms-resources',      '= 1.1.0'
  s.add_dependency    'refinerycms-settings',       '= 1.1.0'

  s.files             = [
    '.gitignore',
    '.rspec',
    '.yardopts',
    'Gemfile',
    'Gemfile',
    'Gemfile.lock',
    'Rakefile',
    'app',
    'app/views',
    'app/views/refinery',
    'app/views/refinery/sitemap',
    'app/views/refinery/sitemap/index.xml.builder',
    'app/views/sitemap',
    'app/views/sitemap/index.xml.builder',
    'autotest',
    'autotest/autotest.rb',
    'autotest/discover.rb',
    'bin',
    'bin/refinerycms',
    'changelog.md',
    'changelog.md',
    'config',
    'config/cucumber.yml',
    'config/database.yml.mysql',
    'config/database.yml.postgresql',
    'config/database.yml.sqlite3',
    'config/environments',
    'config/environments/development.rb',
    'config/environments/production.rb',
    'config/environments/test.rb',
    'config/routes.rb',
    'config.ru',
    'features',
    'features/support',
    'features/support/paths.rb',
    'lib',
    'lib/load_path_analyzer.rb',
    'lib/refinery.rb',
    'lib/refinerycms',
    'lib/refinerycms/all.rb',
    'lib/refinerycms.rb',
    'license.md',
    'license.md',
    'public',
    'public/javascripts',
    'public/javascripts/translations.js',
    'readme.md',
    'readme.md',
    'refinerycms.gemspec',
    'spec',
    'spec/coverage',
    'spec/coverage/assets',
    'spec/coverage/assets/0.4.5',
    'spec/coverage/assets/0.4.5/app.js',
    'spec/coverage/assets/0.4.5/fancybox',
    'spec/coverage/assets/0.4.5/fancybox/blank.gif',
    'spec/coverage/assets/0.4.5/fancybox/fancy_close.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_loading.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_nav_left.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_nav_right.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_shadow_e.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_shadow_n.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_shadow_ne.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_shadow_nw.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_shadow_s.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_shadow_se.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_shadow_sw.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_shadow_w.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_title_left.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_title_main.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_title_over.png',
    'spec/coverage/assets/0.4.5/fancybox/fancy_title_right.png',
    'spec/coverage/assets/0.4.5/fancybox/fancybox-x.png',
    'spec/coverage/assets/0.4.5/fancybox/fancybox-y.png',
    'spec/coverage/assets/0.4.5/fancybox/fancybox.png',
    'spec/coverage/assets/0.4.5/fancybox/jquery.fancybox-1.3.1.css',
    'spec/coverage/assets/0.4.5/fancybox/jquery.fancybox-1.3.1.pack.js',
    'spec/coverage/assets/0.4.5/favicon.png',
    'spec/coverage/assets/0.4.5/jquery-1.4.2.min.js',
    'spec/coverage/assets/0.4.5/jquery.dataTables.min.js',
    'spec/coverage/assets/0.4.5/jquery.timeago.js',
    'spec/coverage/assets/0.4.5/jquery.url.js',
    'spec/coverage/assets/0.4.5/loading.gif',
    'spec/coverage/assets/0.4.5/magnify.png',
    'spec/coverage/assets/0.4.5/smoothness',
    'spec/coverage/assets/0.4.5/smoothness/images',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-bg_flat_0_aaaaaa_40x100.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-bg_flat_75_ffffff_40x100.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-bg_glass_55_fbf9ee_1x400.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-bg_glass_65_ffffff_1x400.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-bg_glass_75_dadada_1x400.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-bg_glass_75_e6e6e6_1x400.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-bg_glass_95_fef1ec_1x400.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-bg_highlight-soft_75_cccccc_1x100.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-icons_222222_256x240.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-icons_2e83ff_256x240.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-icons_454545_256x240.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-icons_888888_256x240.png',
    'spec/coverage/assets/0.4.5/smoothness/images/ui-icons_cd0a0a_256x240.png',
    'spec/coverage/assets/0.4.5/smoothness/jquery-ui-1.8.4.custom.css',
    'spec/coverage/assets/0.4.5/stylesheet.css',
    'spec/coverage/index.html',
    'spec/coverage/resultset.yml',
    'spec/rcov.opts',
    'spec/spec_helper.rb',
    'vendor'
  ]
end
