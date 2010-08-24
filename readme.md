# Refinery CMS

__An open source Ruby on Rails content management system.__ More information at [http://refinerycms.com](http://refinerycms.com)

![Refinery Dashboard](http://refinerycms.com/system/images/0000/0576/dashboard.png)

Wanna see Refinery for yourself? [Try the demo](http://demo.refinerycms.com/refinery)

## What's it good at?

__Refinery is great for sites where the client needs to be able to update their website themselves__ without being bombarded with anything too complicated.

Unlike other content managers, Refinery is truly __aimed at the end user__ making it easy for them to pick up and make changes themselves.

### For developers

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

Other dependencies

* [RMagick](http://github.com/rmagick/rmagick) - [Install docs](http://rmagick.rubyforge.org/install-faq.html) or for
Mac OS 10.5+ users [this shell install script](http://github.com/maddox/magick-installer) will be easier.

## How to

* __[Install Refinery](http://tutorials.refinerycms.org/tutorials/how-to-install-refinery)__
* [Update Refinery to the latest version](http://tutorials.refinerycms.org/tutorials/how-to-update-refinery-to-the-latest-version)
* [Install Refinery on Heroku](http://tutorials.refinerycms.org/tutorials/how-to-install-refinery-on-heroku)
* [Run the Refinery test suite](http://tutorials.refinerycms.org/tutorials/how-to-test-refinery)

## Help and Documentation

* [Tutorial Site](http://tutorials.refinerycms.org)
* [Google Group Discussion](http://group.refinerycms.org)
* [IRC Channel](irc://irc.freenode.net/refinerycms)
* [GitHub repository](http://github.com/resolve/refinerycms)
* [Developer/API documentation](http://api.refinerycms.org)

## Features

### [Pages](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/pages/readme.md)

* Easily edit and manage pages with a [WYSIWYG visual editor](http://www.wymeditor.org/)
* Manage you site's structure

### [Images](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/images/readme.md) & [Files](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/resources/readme.md)

* Easily upload and insert images
* Upload and link to resources such as PDF documents
* Uses the popular [attachment_fu](http://github.com/technoweenie/attachment_fu) Rails plugin
* Supports storage on Amazon S3

### [Inquiries](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/inquiries/readme.md)

* Collect inquiries from a contact form
* Manage your inquiries and be notified when new ones come in
* Checks new inquiries for spam

### [Settings](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery_settings/readme.md)

* Manage the behaviour of Refinery
* Easily integrate with [Google Analytics](https://www.google.com/analytics/)

### [Dashboard](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/dashboard/readme.md)

* Get an overview of what has been updated recently and see recent inquiries.

### [Authentication & Users](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/authentication/readme.md)

* Manage who can access Refinery
* Control which plugins each user has access to
* Uses the popular [authlogic](http://github.com/binarylogic/authlogic) authentication Rails plugin

### [Themes](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/themes/readme.md)

* Customise Refinery to look exactly how you want
* The Rails Way: use regular Rails erb views, no templating languages here!

### ...Want more? [Extend with Plugins](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery/plugins.md)

Extend Refinery easily by running the Refinery generator

    ruby script/generate refinery_plugin

to get help on how to use that. Or read the full documentation on [writing plugins for Refinery](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery/plugins.md)

### Popular Plugins

* [Portfolio](http://github.com/resolve/refinerycms-portfolio) - manage groups of images like an image gallery.
* [News](http://github.com/resolve/refinerycms-news) - post and manage news items.

[Full plugin list here](http://github.com/resolve/refinerycms/wiki/engines)

## License

Refinery is released under the [MIT license](http://github.com/resolve/refinerycms/blob/master/license.md) and is copyright (c) 2005-2010 [Resolve Digital Ltd.](http://www.resolvedigital.co.nz)