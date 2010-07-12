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
    Rake::TestTask.new(:units => 'db:test:prepare') do |t|
      t.libs += [Refinery.root.join('test').to_s,
                 Dir[Rails.root.join('vendor', 'plugins', '**', 'test').to_s]].flatten
      t.pattern = [Refinery.root.join('test', 'unit', '**', '*_test.rb').to_s,
                   Rails.root.join('vendor', 'plugins', '**', 'test', '**', '*_test.rb').to_s]
      t.verbose = true
      ENV['RAILS_ROOT'] = Rails.root.to_s
    end
    Rake::Task['test:refinery:units'].comment = 'Run the unit tests in Refinery.'

    Rake::TestTask.new(:functionals => 'db:test:prepare') do |t|
      t.libs += [Refinery.root.join('test').to_s,
                 Dir[Rails.root.join('vendor', 'plugins', '**', 'test').to_s]].flatten
      t.pattern = [Refinery.root.join('test', 'functional', '**', '*_test.rb').to_s,
                   Rails.root.join('vendor', 'plugins', '**', 'functional', '**', '*_test.rb').to_s]
      t.verbose = true
      ENV['RAILS_ROOT'] = Rails.root.to_s
    end
    Rake::Task['test:refinery:functionals'].comment = 'Run the functional tests in Refinery.'

    Rake::TestTask.new(:integration => 'db:test:prepare') do |t|
      t.libs += [Refinery.root.join('test').to_s,
                 Dir[Rails.root.join('vendor', 'plugins', '**', 'test').to_s]].flatten
      t.pattern = [Refinery.root.join('test', 'integration', '**', '*_test.rb').to_s,
                   Rails.root.join('vendor', 'plugins', '**', 'integration', '**', '*_test.rb').to_s]
      t.verbose = true
      ENV['RAILS_ROOT'] = Rails.root.to_s
    end
    Rake::Task['test:refinery:integration'].comment = 'Run the integration tests in Refinery.'

    Rake::TestTask.new(:benchmark => 'db:test:prepare') do |t|
      t.libs << Refinery.root.join('test').to_s
      t.pattern = Refinery.root.join('test', 'performance', '**', '*_test.rb')
      t.verbose = true
      t.options = '-- --benchmark'
      ENV['RAILS_ROOT'] = Rails.root.to_s
    end
    Rake::Task['test:refinery:benchmark'].comment = 'Benchmark the performance tests in Refinery'
  end
end