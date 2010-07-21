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
* Easily __[Theme and customise](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/themes/readme.md)__ the look to suit the business
* __[Extend with custom plugins](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery/plugins.md)__ to do anything Refinery doesn't do out of the box
* Sticks to __"the Rails way"__ as much as possible. We don't force you to learn new templating languages.
* Uses [jQuery](http://jquery.com/) for fast and concise JavaScript

## Requirements

Refinery's gem requirements are:

* [acts_as_indexed = 0.6.3](http://github.com/parndt/acts_as_indexed)
* [authlogic = 2.1.5](http://rubygems.org/gems/authlogic)
* [friendly_id = 3.0.6](http://rubygems.org/gems/friendly_id)
* [rails = 2.3.8](http://rubygems.org/gems/rails)
* [rmagick ~> 2.12.0](http://rubygems.org/gems/rmagick)
* [truncate_html = 0.3.2](http://rubygems.org/gems/truncate_html)
* [will_paginate = 2.3.14](http://rubygems.org/gems/will_paginate)

### Other dependencies

* [RMagick](http://github.com/rmagick/rmagick) - [Install docs](http://rmagick.rubyforge.org/install-faq.html) or for
Mac OS 10.5 or 10.6 users [this shell install script](http://github.com/maddox/magick-installer) will be easier.

## Installing and Setting Up Refinery

[See the tutorial](http://tutorials.refinerycms.org/tutorials/how-to-install-refinery)

## Help and Developer Documentation

* [Tutorial Site](http://resolve.github.com/refinerycms)
* [Google Group Discussion](http://group.refinerycms.org)
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

### When using git

You can update by running these commands:

    git remote add refinerycms git://github.com/resolve/refinerycms.git
    git pull refinerycms master

This will pull in all of the updated files in the project and may result in some merge conflicts which you will need to resolve.

## What comes included with Refinery

### [Pages](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/pages/readme.md)

* Easily edit and manage pages with a [WYSIWYG visual editor](http://www.wymeditor.org/)
* Manage you site's structure

### [Images](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/images/readme.md) & [Files](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/resources/readme.md)

* Easily upload and insert images
* Upload and link to resources such as PDF documents
* Uses the popular [attachment_fu](http://github.com/technoweenie/attachment_fu) Rails plugin

### [Inquiries](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/inquiries/readme.md)

* Collect inquiries from a contact form
* Manage your inquiries and be notified when new ones come in
* Checks new inquiries for spam

### [Settings](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery_settings/readme.md)

* Manage the behaviour of Refinery
* Easily integrate with [Google Analytics](https://www.google.com/analytics/)

### [Dashboard](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/dashboard/readme.md)

* Get an overview of what has been updated recently

### [Authentication & Users](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/authentication/readme.md)

* Manage who can access Refinery
* Control which plugins each user has access to
* Uses the popular [authlogic](http://github.com/binarylogic/authlogic) authentication Rails plugin

### [Themes](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/themes/readme.md)

* Customise Refinery to look exactly how you want
* The Rails Way: use regular Rails erb views, no templating languages here!

### ...Want more? [Extend with Plugins](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery/plugins.md)

Extend Refinery easily by running the Refinery generator

    ruby script/generate refinery

to get help on how to use that. Or read the full documentation on [writing plugins for Refinery](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery/plugins.md)

### Run the Tests

If you have installed Refinery using git (described above in step 1 of installing Refinery) then you'll be able to run the tests. At your Rails root run:

    rake test

### Popular Plugins

* [Portfolio](http://github.com/resolve/refinerycms-portfolio) - manage groups of images like an image gallery.
* [News](http://github.com/resolve/refinerycms-news) - post and manage news items.

## License

Refinery is released under the MIT license and is copyright (c) 2005-2010 [Resolve Digital Ltd.](http://www.resolvedigital.co.nz)

[Read the license](http://github.com/resolve/refinerycms/blob/master/license.md)
