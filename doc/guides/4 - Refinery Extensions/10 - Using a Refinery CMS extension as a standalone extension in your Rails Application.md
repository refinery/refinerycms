# Using a Refinery CMS extension as a standalone extension in your Rails Application

A Refinery CMS extension can be used as a standalone extension in your Rails application.

This guide will show you how to:

* Bootstrap a rails application with just the use of a Refinery CMS extension like `refinerycms-blog`

## Bootstrap a rails app with just the use of a Refinery CMS extension like `refinerycms-blog`

First, bootstrap a new rails application:

```shell
$ rails _4.2.6_ new blog_test_app
```

Put just the `refinerycms-blog` in your project's Gemfile:

```ruby
gem "refinerycms-blog", git: "https://github.com/refinery/refinerycms-blog"
```

This will merely pull in `refinerycms-core` and `refinerycms-settings` based on the current gemspec dependencies.

Then you can run:

```shell
$ bundle install
$ rails generate refinery:cms
```

And all the other normal set up tasks like migrations.

Now, you should have a Rails app with __only__ the Refinery CMS Blog.

Finally, start your application and enjoy the use of Refinery CMS Blog only:

```shell
$ rails server
```