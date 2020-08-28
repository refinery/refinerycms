# Upgrading to the Latest Stable Version

Refinery constantly changes as we add new features and fix bugs. This guide will show you how to:

* Keep updated with the latest stable versions as they are released

## Introduction

First, you need a current installation of Refinery. Refinery would have been installed by one of two ways, Rubygem or Git. When updating, the latest files are copied into your project.

## Updating a Gem Installation of Refinery

Take a look at <https://rubygems.org/gems/refinerycms> to find the latest version number for Refinery.

Edit your `Gemfile` to reference the latest version of Refinery (a later version than the one shown [may exist](https://rubygems.org/gems/refinerycms/versions)).

```ruby
gem 'refinerycms', '~> 4.0.0'
```

Now install the new gems using bundler's update functionality:

```shell
$ bundle update refinerycms
```

Inside the application's directory, use the Rails generator to update your Refinery installation:

__TIP__: You only need to run the below step when upgrading between major or minor versions. Bug fix releases should not change the database structure. For example, if you are going from 1.0.3 -> 1.0.8 (Bugfix) you do not need to run this command.

__WARNING__: This will overwrite files so make sure you have a backup or have your current code committed to a remote git repository.

```shell
$ rails generate refinery:cms --update
```

Database migrations and new gem dependencies may have been added, so finish your Refinery update with:

```shell
$ bin/rake db:migrate
$ bundle install
```
