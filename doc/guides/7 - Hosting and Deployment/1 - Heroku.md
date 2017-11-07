# Heroku

[Heroku](http://heroku.com) is a popular hosting choice for many developers. This guide will show you how to:

* Install and deploy a Refinery application on the Heroku hosting platform

## Creating a new Refinery application on Heroku

First you need to install Refinery. To do that you need the refinerycms gem.

```shell
gem install refinerycms
```

Then, if you haven't done so already, follow the first three steps of the [Heroku quick start guide](https://devcenter.heroku.com/articles/quickstart). They cover signing up for Heroku, installing the Heroku client, and
logging in through the client.

Now it's time to create your Refinery application using the built in `--heroku` option:

```shell
refinerycms myapp --heroku
```

__NOTE__: Heroku relies on [Git](http://git-scm.com/download) being installed on your system. You should install it beforehand.

Watch the output for these lines:

```shell
Creating Heroku app..
Running: cd /path/to/app/myapp && heroku create
Creating random-site-name..... done
Created http://random-site-name.herokuapp.com/
```

This will output the URL for your Heroku-hosted Refinery application. Your application should now be live at <http://random-site-name.heroku.com>.

__NOTE__: you may have issues precompiling your assets, which may result in system images not loading. Skip to the following Step 3 for a fix.

## Deploying an existing local Refinery application

If you have already built a Refinery application locally, you'll need to make some changes to be able to deploy to Heroku.

### Step 1: Update the Gemfile

#### If your local database is not PostgreSQL

You don't have to change your local database settings to use PostgreSQL, but Heroku depends on the presence of the `pg` gem. So, in your Gemfile, change:

```ruby
gem 'sqlite3' # or whatever the database driver for your local database is
```

to:

```ruby
group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
```

__WARNING__: Using differing databases for development and production is not recommended. Occasionally, specific Rails idioms may have different effects on different databases. We encourage you to set up and develop on PostgreSQL if you intend to deploy your application to Heroku.

#### Getting a place to store files

If you want to use Refinery's image and resource support, you need to follow the guide [Amazon S3 for Uploads](/guides/amazon-s3-for-uploads) below (you can do the other steps in that section after your site is first
deployed).

#### Applying your changes

Now we just need to run bundle and add the changes to git:

```shell
$ bundle install
$ git add Gemfile
$ git add Gemfile.lock
$ git commit -m "setup for Heroku"
```

### Step 2: Set up your app on Heroku

```shell
$ app_name="your-app-name"
$ heroku create $app_name --stack cedar
$ git push heroku master
```

### Step 3: Set up asset precompilation

Inside `config/application.rb`, at the end of the config block, make sure you add the following:

```ruby
config.assets.initialize_on_precompile = true
```

This is necessary to make post-deploy asset precompilation happen. Without this, Refinery will fail to compile its assets, owing to its use of Rails' URL helpers inside of its Javascript files (necessary for its WYSIWYG editor).

You may also need to enable the experimental `user-env-compile` option on Heroku. You can read more [here](https://devcenter.heroku.com/articles/labs-user-env-compile), but in short, run the following command:

```shell
heroku labs:enable user-env-compile
```

In theory, this should only affect applications where `initialize_on_precompile` is false or default; however, you may need to set the `user_env_compile` option if you receive complaints about being unable to connect to `127.0.0.1`.

(If someone else created the Heroku app for you, make sure it is on the [Cedar stack](https://devcenter.heroku.com/articles/cedar). Cedar is the newest stack and Heroku recommends it for new apps. You can run `heroku stack` to check which stack your app is on.)

### Step 4 (Option 1): Start from clean slate

If you haven't set up anything locally, or don't want to copy your local database to heroku, you'll need to run a few commands to get Refinery's database set up.

```shell
$ heroku run rake db:migrate
$ heroku run rake db:seed
```

This will set up the required database tables, and set up a homepage. Log in to your site to set up your first user.

```shell
$ heroku open
```

### Step 4 (Option 2): Copy your data from your local database to the Heroku app

If you've developed your website locally, you likely have information in a local database that you would like to use. Rather than trying to recreate all that on Heroku, Heroku provides you with a task that requires you to install the `taps` gem. Be warned, though: Taps has been known to raise errors with Ruby 1.9.3.

If you receive any errors or the transfer fails the first time, switch to 1.9.2 to be safe.

You'll want to actually install taps to your system - not just add it to your Gemfile.

```shell
gem install taps
```

Now copy the data to your Heroku app.

```shell
heroku pg:push
```

If that command gives you the error "no such file to load --taps/operation", you have run into
[this Heroku and taps bug](https://github.com/heroku/heroku/issues/69). See its comments for fixes to try.

## Troubleshooting

### Missing a required gem

Simply add that gem to the Gemfile.

### Images or Resources don't work

Double check your `S3_` information and make sure that the right buckets actually exist. You can confirm against the values Heroku has recorded by running `heroku config`.

See the [How to use Amazon S3 for uploads](/guides/amazon-s3-for-uploads) guide for more specific information on file storage.

### Other problems?

Otherwise, run `heroku logs` or `heroku logs --tail` and see if you can spot the error yourself. Or you could explore the [help options available](/guides/how-to-get-help).
