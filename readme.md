# Refinery CMS

An open source Ruby on Rails content management system for small business.

* [Front end live demo ](http://demo.refinerycms.com)
* [Back end live demo ](http://demo.refinerycms.com/admin)

For more screenshots, example sites & high level information: [http://refinerycms.com](http://refinerycms.com)

![Refinery Dashboard](http://refinerycms.com/system/images/0000/0576/dashboard.png)

## What it's good at?

__Refinery is great for small business sites where the client needs to be able to update their website themselves__ without being bombarded with anything too complicated.

Unlike other content managers, Refinery is truly aimed at the end user making it easy for them to pick up and make changes themselves.

For developers Refinery makes it easy to:

* Get a small business site up and running __ridiculously quickly__
* __Theme and customise__ the look to suit the business
* __Extend with custom plugins__ to do anything Refinery doesn't do out of the box

## Requirements

Refinery runs using a number of gems which (as of Refinery version 0.9.5.29) are outlined below:

* [rake >= 0.8.3](http://gemcutter.org/gems/rake)
* [friendly_id >= 2.2.2](http://gemcutter.org/gems/friendly_id)
* [will_paginate >= 2.3.11](http://gemcutter.org/gems/will_paginate)
* [rails >= 2.3.5](http://gemcutter.org/gems/rails)
* [aasm >= 2.1.3](http://gemcutter.org/gems/aasm)
* [unicode >= 0.1](http://gemcutter.org/gems/unicode)
* [slim_scrooge >= 1.0.3](http://gemcutter.org/gems/slim_scrooge)
* [hpricot >= 0.8.1](http://gemcutter.org/gems/hpricot)

### Other dependancies

* [RMagick](http://github.com/rmagick/rmagick) - [Install docs](http://rmagick.rubyforge.org/install-faq.html) or for
Mac OS users [this install script](http://github.com/maddox/magick-installer) will be easier.

## Installing and Setting Up Refinery

### 1. Get the Refinery code

#### Install the Gem

    gem install refinerycms --source http://gemcutter.org
    refinery /path/to/project

#### Or, clone Refinery's Git repository

    git clone git://github.com/resolve/refinerycms.git mynewsite.com
    cd ./mynewsite.com
    git remote rm origin
    git remote add origin git@github.com:you/yournewsite.git
    mv ./config/database.yml.example ./config/database.yml

### 2. Configuration

Firstly, edit ``config/database.yml`` to reflect your database server details.

Next create your database and fill it with Refinery's default data:

    rake db:setup

After your database exists, you'll need to install the gems that Refinery depends on. You can do this by running:

    rake gems:install

### 3. Starting up your site

    ruby script/server

Now in your browser go to [http://localhost:3000](http://localhost:3000) and your site should be running.

You will be prompted to setup your first user.

## Help and Developer Documentation

* [Google Group Discussion](http://groups.google.com/group/refinery-cms)
* [Developer/API documentation](http://api.refinerycms.org)
* [Developer video - 26 mins](http://refinerycms.com/pages/for-developers)

## Setting Up on Heroku

If you're using [Heroku](http://heroku.com/) you will want to put

    USE_S3_BACKEND = true
  
in your ``config/production.rb`` file.

## Updating to the latest Refinery

### When using the gem

Simply run the command:

    refinery-update-core /path/to/project/root/

and the up-to-date core files will be copied from the latest gem into your project.

### When using Git

You can update by running these commands:

    git remote add refinerycms git://github.com/resolve/refinerycms.git
    git pull refinerycms master

This will pull in all of the updated files in the project and may result in some merge conflicts which you will need to resolve.

## What comes included with Refinery

### Pages

* Easily edit and manage pages with a [WYSIWYG visual editor](http://www.wymeditor.org/)
* Manage you site's structure

### Images & Resources

* Easily upload and insert images
* Upload and link to resources like PDF documents

### Inquiries

* Collect inquiries from a contact form
* Manage your inquiries and be notified when new ones come in

### News

* Post news about your company and update your visitors

### Settings

* Manage various aspects of Refinery

### Dashboard

* Get an overview of what has been updated recently
  
### ...Want more?

Extend Refinery easily by running the Refinery generator

    ruby script/generate refinery
  
to get help on how to use that.

### What about a portfolio?

Check out the [portfolio plugin gem](http://github.com/resolve/portfolio)

## License

Refinery is released under the MIT license and is copyright (c) 2005-2009 [Resolve Digital Ltd.](http://www.resolvedigital.co.nz)

A copy of the MIT license can be found in the license.md file.