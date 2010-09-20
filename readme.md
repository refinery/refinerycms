# Refinery CMS

__An open source Ruby on Rails content management system for Rails 3.__

Refinery also supports Rails 2.x using the [Rails 2.x stable branch](http://github.com/resolve/refinerycms/tree/rails2-stable). More information at [http://refinerycms.com](http://refinerycms.com)

![Refinery Dashboard](http://refinerycms.com/system/images/0000/0576/dashboard.png)

Wanna see Refinery for yourself? [Try the demo](http://demo.refinerycms.com/refinery)

## What's it good at?

__Refinery is great for sites where the client needs to be able to update their website themselves__ without being bombarded with anything too complicated.

Unlike other content managers, Refinery is truly __aimed at the end user__ making it easy for them to pick up and make changes themselves.

### For developers

* Easily customise the look to suit the business.
* __[Extend with custom engines](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/core/engines.md#readme)__ to do anything Refinery doesn't do out of the box.
* Sticks to __"the Rails way"__ as much as possible; we don't force you to learn new templating languages.
* Uses [jQuery](http://jquery.com/) for fast and concise Javascript.

## Requirements

* [Bundler](http://github.com/carlhuda/bundler)
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
* Documentation about: [Pages](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/pages/readme.md#readme), [Images](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/images/readme.md#readme), [Files](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/resources/readme.md#readme), [Inquiries](http://github.com/resolve/refinerycms-inquiries/blob/master/readme.md#readme), [Settings](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/settings/readme.md#readme), [Dashboard](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/dashboard/readme.md#readme), [Authentication & Users](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/authentication/readme.md#readme), [Extending with Engines](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/core/engines.md#readme).

## Features

### [Pages](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/pages/readme.md#readme)

* Easily edit and manage pages with a [WYSIWYG visual editor](http://www.wymeditor.org/).
* Manage you site's structure.

### [Images](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/images/readme.md#readme) & [Files](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/resources/readme.md#readme)

* Easily upload and insert images.
* Upload and link to resources such as PDF documents.
* Uses the popular [Dragonfly](http://github.com/markevans/dragonfly).
* Supports storage on Amazon S3.

### [Inquiries](http://github.com/resolve/refinerycms-inquiries/blob/master/readme.md#readme)

* Collect inquiries from a contact form.
* Manage your inquiries and be notified when new ones come in.
* Checks new inquiries for spam.

### [Settings](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/settings/readme.md#readme)

* Manage the behaviour of Refinery
* Easily integrate with [Google Analytics](https://www.google.com/analytics/)

### [Dashboard](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/dashboard/readme.md#readme)

* Get an overview of what has been updated recently and see recent inquiries.

### [Authentication & Users](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/authentication/readme.md#readme)

* Manage who can access Refinery.
* Control which engines each user has access to.
* Uses the popular [authlogic](http://github.com/binarylogic/authlogic).

### ...Want more? [Extend with Engines](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/core/engines.md#readme)

Extend Refinery easily by running the Refinery engine generator

    rails generate refinery_engine

to get help on how to use that. Or read the full documentation on [writing engines for Refinery](http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/core/engines.md#readme)

### Popular Engines

* [Blog](http://github.com/resolve/refinerycms-blog) - A simple blogging engine that supports posts, categories and comments (with moderation support if you choose to enable it)
* [Portfolio](http://github.com/resolve/refinerycms-portfolio) - manage groups of images like an image gallery.
* [News](http://github.com/resolve/refinerycms-news) - post and manage news items.
* [Theming](http://github.com/resolve/refinerycms-theming) - turn your views, stylesheets, javascripts and images into bundled themes that are reusable and interchangeable.

[Full engine list here](http://github.com/resolve/refinerycms/wiki/engines)

### Example Site Showcase

[List here (add your link when you're done)](http://github.com/resolve/refinerycms/wiki/Example-Site-Showcase)

## License

Refinery is released under the [MIT license](http://github.com/resolve/refinerycms/blob/master/license.md#readme) and is copyright (c) 2005-2010 [Resolve Digital Ltd.](http://www.resolvedigital.co.nz)
