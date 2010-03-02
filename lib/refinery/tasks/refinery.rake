desc 'Removes trailing whitespace across the entire application.'
task :whitespace do
  sh %{find . -name '*.*rb' -exec sed -i '' 's/\t/  /g' {} \\; -exec sed -i '' 's/ *$//g' {} \\; }
end

namespace :test do
  desc "Run the tests that ship with Refinery to ensure any changes you've made haven't caused instability."
  task :refinery do
    errors = %w(test:refinery:units test:refinery:functionals test:refinery:integration).collect do |task|
      begin
        Rake::Task[task].invoke
        nil
      rescue => e
        task
      end
    end.compact
    abort "Errors running #{errors.to_sentence(:locale => :en)}!" if errors.any?
  end
  namespace :refinery do
    Rake::TestTask.new(:units => "db:test:prepare") do |t|
      t.libs << Refinery.root.join("test").to_s
      t.pattern = Refinery.root.join("test", "unit", "**", "*_test.rb").to_s
      t.verbose = true
      ENV["RAILS_ROOT"] = Rails.root.to_s
    end
    Rake::Task['test:refinery:units'].comment = "Run the unit tests in Refinery."

    Rake::TestTask.new(:functionals => "db:test:prepare") do |t|
      t.libs << Refinery.root.join("test").to_s
      t.pattern = Refinery.root.join("test", "functional", "**", "*_test.rb").to_s
      t.verbose = true
      ENV["RAILS_ROOT"] = Rails.root.to_s
    end
    Rake::Task['test:refinery:functionals'].comment = "Run the functional tests in Refinery."

    Rake::TestTask.new(:integration => "db:test:prepare") do |t|
      t.libs << Refinery.root.join("test").to_s
      t.pattern = Refinery.root.join("test", "integration", "**", "*_test.rb").to_s
      t.verbose = true
      ENV["RAILS_ROOT"] = Rails.root.to_s
    end
    Rake::Task['test:refinery:integration'].comment = "Run the integration tests in Refinery."

    Rake::TestTask.new(:benchmark => 'db:test:prepare') do |t|
      t.libs << Refinery.root.join("test").to_s
      t.pattern = Refinery.root.join("test", "performance", "**", "*_test.rb")
      t.verbose = true
      t.options = '-- --benchmark'
      ENV["RAILS_ROOT"] = Rails.root.to_s
    end
    Rake::Task['test:refinery:benchmark'].comment = 'Benchmark the performance tests in Refinery'
  end
end

# You don't need to worry about this unless you're releasing Refinery gems.
begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = %q{refinerycms}
    s.description = %q{A beautiful open source Ruby on Rails content manager for small business. Easy to extend, easy to use, lightweight and all wrapped up in a super slick UI.}
    s.summary = %q{A beautiful open source Ruby on Rails content manager for small business.}
    s.email = %q{info@refinerycms.com}
    s.homepage = %q{http://refinerycms.com}
    s.authors = ["Resolve Digital", "David Jones", "Philip Arndt"]
    s.extra_rdoc_files = %w(readme.md contributors.md license.md VERSION)
    s.rdoc_options << "--inline-source"
    s.has_rdoc = true
  end

  namespace :version do
    namespace :bump do
      desc "Bump the application's version by a build version."
      task :build => [:version_required, :version] do
        version = Jeweler::VersionHelper.new(Rails.root.to_s)
        version.update_to(version.major, version.minor, version.patch, ((version.build || 0).to_i + 1))
        version.write
        $stdout.puts "Updated version: #{version.to_s}"
      end
    end
  end
rescue LoadError
  #puts "Jeweler not available. Install it with: sudo gem install jeweler"
end