require 'socket'
begin
  require 'testrbl' # before bundler is setup so it does not need to be in the Gemfile
rescue LoadError
end

ROOT_PATH = File.expand_path('../spec/dummy', __FILE__)

Zeus::Server.define! do
  stage :boot do

    action do
      ENV_PATH  = File.expand_path('config/environment',  ROOT_PATH)
      BOOT_PATH = File.expand_path('config/boot',  ROOT_PATH)
      APP_PATH  = File.expand_path('config/application',  ROOT_PATH)

      require BOOT_PATH
      require 'rails/all'
    end

    stage :default_bundle do
      action { Bundler.require(:default) }

      stage :development_environment do
        action do
          Bundler.require(:development)
          Rails.env = ENV['RAILS_ENV'] = "development"
          require APP_PATH
          Rails.application.require_environment!
        end

        command :generate, :g do
          begin
            require 'rails/generators'
            Rails.application.load_generators
          rescue LoadError # Rails 3.0 doesn't require this block to be run, but 3.2+ does
          end
          require 'rails/commands/generate'
        end

        command :runner, :r do
          require 'rails/commands/runner'
        end

        command :console, :c do
          require 'rails/commands/console'
          Rails::Console.start(Rails.application)
        end

        command :server, :s do
          require 'rails/commands/server'
          server = Rails::Server.new
          Dir.chdir(Rails.application.root)
          server.start
        end

        stage :prerake do
          action do
            require 'rake'
            load 'Rakefile'
          end

          command :rake do
            Rake.application.run
          end

        end
      end

      stage :test_environment do
        action do
          Bundler.require(:test)

          Rails.env = ENV['RAILS_ENV'] = 'test'
          require APP_PATH

          $rails_rake_task = 'yup' # lie to skip eager loading
          Rails.application.require_environment!
          $rails_rake_task = nil
          $LOAD_PATH.unshift(ROOT_PATH) unless $LOAD_PATH.include?(ROOT_PATH)

          if Dir.exist?(ROOT_PATH + "/test")
            test = File.join(ROOT_PATH, 'test')
            $LOAD_PATH.unshift(test) unless $LOAD_PATH.include?(test)
          end

          if Dir.exist?(ROOT_PATH + "/spec")
            spec = File.join(ROOT_PATH, 'spec')
            $LOAD_PATH.unshift(spec) unless $LOAD_PATH.include?(spec)
          end

        end

        if Dir.exist?(ROOT_PATH + "/test")
          stage :test_helper do
            action { require 'test_helper' }

            command :testrb do
              argv = ARGV

              # try to find patter by line using testrbl
              if defined?(Testrbl) && argv.size == 1 and argv.first =~ /^\S+:\d+$/
                file, line = argv.first.split(':')
                argv = [file, '-n', "/#{Testrbl.send(:pattern_from_file, File.readlines(file), line)}/"]
                puts "using -n '#{argv[2]}'" # let users copy/paste or adjust the pattern
              end

              runner = Test::Unit::AutoRunner.new(true)
              if runner.process_args(argv)
                exit runner.run
              else
                abort runner.options.banner + " tests..."
              end
            end
          end
        end

        stage :spec_helper do
          action { require File.join(ROOT_PATH, '..', 'spec_helper') }

          command :rspec do
            exit RSpec::Core::Runner.run(ARGV)
          end
        end

      end

    end
  end
end

