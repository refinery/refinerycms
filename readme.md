# Refinery CMS

__An open source Ruby on Rails content management system for small business.__

## Demo Site

* [Front end live demo ](http://demo.refinerycms.com)
* [Back end live demo ](http://demo.refinerycms.com/admin)

For more screenshots, example sites & high level information: [http://refinerycms.com](http://refinerycms.com)

![Refinery Dashboard](http://refinerycms.com/system/images/0000/0576/dashboard.png)

## What it's good at?

__Refinery is great for small business sites where the client needs to be able to update their website themselves__ without being bombarded with anything too complicated.

Unlike other content managers, Refinery is truly aimed at the end user making it easy for them to pick up and make changes themselves.

### For developers

* Allows you to get a small business site completed __ridiculously quickly__
* Easily __[Theme and customise](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/themes/themes.md)__ the look to suit the business
* __[Extend with custom plugins](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery/plugins.md)__ to do anything Refinery doesn't do out of the box
* Sticks to __"the Rails way"__ as much as possible. We don't force you to learn new templating languages.
* Uses [jQuery](http://jquery.com/) for fast and concise JavaScript

## Requirements

Refinery's gem requirements are:

* [authlogic ~> 2.1.4](http://rubygems.org/gems/authlogic)
* [friendly_id ~> 3.0.4](http://rubygems.org/gems/friendly_id)
* [hpricot ~> 0.8](http://rubygems.org/gems/hpricot)
* [rails ~> 2.3.6](http://rubygems.org/gems/rails)
* [rmagick ~> 2.12.2](http://rubygems.org/gems/rmagick)
* [will_paginate ~> 2.3.12](http://rubygems.org/gems/will_paginate)

### Other dependencies

* [RMagick](http://github.com/rmagick/rmagick) - [Install docs](http://rmagick.rubyforge.org/install-faq.html) or for
Mac OS 10.5 or 10.6 users [this shell install script](http://github.com/maddox/magick-installer) will be easier.

## Installing and Setting Up Refinery

### 1. Get the Refinery code

#### Install the Gem

    gem install refinerycms
    refinery path/to/project

#### Or, clone Refinery's GIT repository

The git repository is where all of the changes are made when any new code is written or existing code is updated. For this reason it is often better to use the gem or to checkout a particular tag (the latest is usually considered the most stable). So unless you want to use the latest code, checkout the latest tag by replacing 0.9.X.XX below with the appropriate version:

    git clone git://github.com/resolve/refinerycms.git mynewsite.com
    cd ./mynewsite.com
    git checkout 0.9.X.XX
    git remote rm origin
    git remote add origin git@github.com:you/yournewsite.git
    mv ./config/database.yml.example ./config/database.yml

### 2. Configuration

Firstly, edit ``config/database.yml`` to reflect your database server details.

Next you'll need to install bundler if you don't have it already:

    gem install bundler

Now you will need to make sure that you specify the correct database driver and web server.
The default choices are mysql and unicorn but to change them open up ``Gemfile`` which is in your application's root directory.
You'll see a section like this:

    # Specify the database driver as appropriate for your application (only one).
    gem 'mysql', :require => 'mysql'
    #gem 'sqlite3-ruby', :require => 'sqlite3'

    # Specify your favourite web server (only one).
    gem 'unicorn', :group => :development
    #gem 'mongrel', :group => :development

To choose a different driver or web server just comment out the one we've pre-selected and uncomment or write the one you want instead.

After you have bundler and you've chosen your database driver and web server, you'll need to install the gems that Refinery depends on.
You can do this by running:

    bundle install

Next create your database and fill it with Refinery's default data:

    rake db:setup

Note: The news engine that was previously in Refinery's core was extracted into a separate gem / plugin to be found here:

    http://github.com/resolve/refinerycms-news

Now, news should be up and running.

### 3. Starting up your site

    ruby script/server

Now visit [http://localhost:3000](http://localhost:3000) and your Refinery site should be running.

You will be prompted to setup your first user.

## Help and Developer Documentation

* [Tutorial Site](http://resolve.github.com/refinerycms)
* [Google Group Discussion](http://groups.google.com/group/refinery-cms)
* [Developer/API documentation](http://api.refinerycms.org)
* [GitHub repository](http://github.com/resolve/refinerycms)
* [Developer video - 26 mins](http://refinerycms.com/pages/for-developers)
* [IRC Channel](irc://irc.freenode.net/refinerycms)

## Setting Up on Heroku or Using S3 for Storage

If you're using [Heroku](http://heroku.com/) you will want to put

    Refinery.s3_backend = true

in your ``config/environments/production.rb`` file to make Refinery store files uploaded on Amazon S3.

## Updating to the latest Refinery

### When using the gem

Simply run the command:

    rake refinery:update

and the up-to-date core files will be copied from the latest gem into your project.

### When using GIT

You can update by running these commands:

    git remote add refinerycms git://github.com/resolve/refinerycms.git
    git pull refinerycms master

This will pull in all of the updated files in the project and may result in some merge conflicts which you will need to resolve.

## What comes included with Refinery

### [Pages](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/pages/pages.md)

* Easily edit and manage pages with a [WYSIWYG visual editor](http://www.wymeditor.org/)
* Manage you site's structure

### [Images](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/images/images.md) & [Files](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/resources/resources.md)

* Easily upload and insert images
* Upload and link to resources such as PDF documents
* Uses the popular [attachment_fu](http://github.com/technoweenie/attachment_fu) Rails plugin

### [Inquiries](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/inquiries/inquiries.md)

* Collect inquiries from a contact form
* Manage your inquiries and be notified when new ones come in

### [News](http://github.com/resolve/refinerycms-news)

* Post news about your company and update your visitors

### [Settings](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery_settings/settings.md)

* Manage the behaviour of Refinery
* Easily integrate with [Google Analytics](https://www.google.com/analytics/)

### [Dashboard](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/dashboard/dashboard.md)

* Get an overview of what has been updated recently

### [Authentication & Users](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/authentication/authentication.md)

* Manage who can access Refinery
* Control which plugins each user has access to
* Uses the popular [authlogic](http://github.com/binarylogic/authlogic) authentication Rails plugin

### [Themes](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/themes/themes.md)

* Customise Refinery to look exactly how you want
* The Rails Way: use regular Rails erb views, no templating languages here!

### ...Want more? [Extend with Plugins](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery/plugins.md)

Extend Refinery easily by running the Refinery generator

    ruby script/generate refinery

to get help on how to use that. Or read the full documentation on [writing plugins for Refinery](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery/plugins.md)

### Run the Tests

If you have installed Refinery using GIT (described above in step 1 of installing Refinery) then you'll be able to run the tests. At your Rails root run:

    rake test

### What about a portfolio?

Check out the [portfolio plugin gem](http://github.com/resolve/refinerycms-portfolio)

## License

Refinery is released under the MIT license and is copyright (c) 2005-2009 [Resolve Digital Ltd.](http://www.resolvedigital.co.nz)

[Read the license](http://github.com/resolve/refinerycms/blob/master/license.md)
