# Testing your Extension

Refinery ships with an optional testing extension in the form of a gem called `refinerycms-testing` which will add generators and rake tasks to your extension that provide it with the same RSpec2 testing environment we use to test Refinery. We abstract common test helpers, controller macros, and factories into this extension so you can use these in tests of your own.

This guide will show you how to:

* Bootstrap your extension with the Refinery RSpec2 testing environment
* Run the test suite with Rake for a one time run
* Run the test suite with Guard for quick TDD iterations

## Bootstrap the test environment

__NOTE__: Make sure you perform all of the following steps from within your extension's directory.

In your extension's Gemfile uncomment or add the following line

```ruby
gem 'refinerycms-testing'
```

And run

```shell
$ bundle install
```

Now we will configure our test environment by preparing a dummy refinerycms app

Add the following lines to your extension's Rakefile

```ruby
ENGINE_PATH = File.dirname(*FILE*)
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", *FILE*)

load 'rails/tasks/extension.rake' if File.exists?(APP_RAKEFILE)

require "refinerycms-testing"
Refinery::Testing::Railtie.load_dummy_tasks ENGINE_PATH
```

And run the dummy application generator:

```shell
$ bin/rake refinery:testing:dummy_app
```

__NOTE__: To successfully run rake tasks within your project you may need to add the `refinerycms-testing` gem to your application's Gemfile, too.

## Running the tests with Rake

```shell
$ bin/rake spec
```

This will run the rspec specs.

This is the most simple way to execute the test suite and useful for a one time run.

__NOTE__: If you get *Could not find table* errors, it may help to delete the `spec/dummy` directory and run `bin/rake
refinery:testing:dummy_app` again.

## Running the tests with Guard

We recommend using Guard if you like to develop using TDD. Guard will watch your project for changes in files. If a change is made to a spec or a file that is tested against, it will re-run only the necessary specs. This is a faster way to get feedback during your TDD cycles.

At your extension's root directory run:

```shell
$ bin/guard start
```

Larger Rails apps, particularly on Ruby 1.9.2, may take several seconds (or more) to start up. If that's the case, you might also want to use Spork, which loads a single instance of the Rails environment and forks it to run tests, for even faster feedback cycles.
