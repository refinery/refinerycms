# Refinery CMS

__An open source Ruby on Rails content management system for Rails 3.__

More information at [http://refinerycms.com](http://refinerycms.com)

[![Donate to the project using Flattr](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=parndt&url=https://github.com/resolve/refinerycms&title=Refinery CMS&language=en_GB&tags=github&category=software)
[![Build Status](https://secure.travis-ci.org/resolve/refinerycms.png)](http://travis-ci.org/resolve/refinerycms)

## Requirements

* [Bundler](http://gembundler.com)
* [ImageMagick](http://www.imagemagick.org/script/install-source.php)
  * Mac OS X users should use [homebrew's](https://github.com/mxcl/homebrew/wiki/installation) `brew install imagemagick` or the [magick-installer](https://github.com/maddox/magick-installer).

## How to

* __[Install Refinery CMS](http://refinerycms.com/download)__
* [Update Refinery CMS to the latest stable version](http://refinerycms.com/guides/how-to-update-refinery-to-the-latest-stable-version)
* [Install Refinery CMS on Heroku](http://refinerycms.com/guides/how-to-install-refinery-on-heroku)
* [Run the Refinery CMS test suite](http://refinerycms.com/guides/how-to-test-refinery)
* __[Contribute to Refinery CMS](http://refinerycms.com/guides/how-to-contribute-to-refinery-development)__
* __[Donate to the Refinery CMS core team](http://pledgie.com/campaigns/8431)__

## Getting Started

If you're new to Refinery, start with this guide:

* __[Getting started with Refinery](http://refinerycms.com/guides/getting-started-with-refinery)__

## What's it good at?

__Refinery is great for sites where the client needs to be able to update their website themselves__ without being bombarded with anything too complicated.

Unlike other content managers, Refinery is truly __aimed at the end user__ making it easy for them to pick up and make changes themselves.

### For developers

* Easily customise the look to suit the business.
* __[Extend with custom engines](https://github.com/resolve/refinerycms/blob/master/doc/engines.md#readme)__ to do anything Refinery doesn't do out of the box.
* Sticks to __"the Rails way"__ as much as possible; we don't force you to learn new templating languages.
* Uses [jQuery](http://jquery.com/) for fast and concise Javascript.

![Refinery Dashboard](http://refinerycms.com/system/images/0000/0576/dashboard.png)

Wanna see Refinery for yourself? [Try the demo](http://demo.refinerycms.com/refinery)

## Help and Documentation

* [Getting Started](http://refinerycms.com/guides/getting-started-with-refinery)
* [Guides](http://refinerycms.com/guides)
* [Google Group Discussion](http://group.refinerycms.org)
* [IRC Channel](http://refinerycms.com/guides/how-to-get-help-with-refinery#irc-channel)
* [GitHub repository](http://github.com/resolve/refinerycms)
* [Developer/API documentation](http://api.refinerycms.org)
* [Twitter Account](http://twitter.com/refinerycms)
* Documentation about: [Pages](https://github.com/resolve/refinerycms/blob/master/doc/pages.md#readme), [Images](http://github.com/resolve/refinerycms/blob/master/doc/images.md#readme), [Files](http://github.com/resolve/refinerycms/blob/master/doc/resources.md#readme), [Inquiries](http://github.com/resolve/refinerycms-inquiries/blob/master/readme.md#readme), [Settings](http://github.com/resolve/refinerycms/blob/master/doc/settings.md#readme), [Dashboard](http://github.com/resolve/refinerycms/blob/master/doc/dashboard.md#readme), [Authentication & Users](http://github.com/resolve/refinerycms/blob/master/doc/authentication.md#readme), [Extending with Engines](http://github.com/resolve/refinerycms/blob/master/doc/engines.md#readme).

## Features

### [Pages](http://github.com/resolve/refinerycms/blob/master/doc/pages.md#readme)

* Easily edit and manage pages with a [WYSIWYG visual editor](http://www.wymeditor.org/).
* Manage you site's structure.

### [Images](http://github.com/resolve/refinerycms/blob/master/doc/images.md#readme) & [Files](http://github.com/resolve/refinerycms/blob/master/doc/resources.md#readme)

* Easily upload and insert images.
* Upload and link to resources such as PDF documents.
* Uses the popular [Dragonfly](http://github.com/markevans/dragonfly).
* Supports storage on Amazon S3.

### [Inquiries](http://github.com/resolve/refinerycms-inquiries/blob/master/readme.md#readme)

* Collect inquiries from a contact form.
* Manage your inquiries and be notified when new ones come in.
* Checks new inquiries for spam.

### [Settings](http://github.com/resolve/refinerycms/blob/master/doc/settings.md#readme)

* Manage the behaviour of Refinery
* Easily integrate with [Google Analytics](https://www.google.com/analytics/)

### [Dashboard](http://github.com/resolve/refinerycms/blob/master/doc/dashboard.md#readme)

* Get an overview of what has been updated recently and see recent inquiries.

### [Authentication & Users](http://github.com/resolve/refinerycms/blob/master/doc/authentication.md#readme)

* Manage who can access Refinery.
* Control which engines each user has access to.
* Uses the popular [devise](http://github.com/plataformatec/devise).

### ...Want more? [Extend with Engines](http://github.com/resolve/refinerycms/blob/master/doc/engines.md#readme)

Extend Refinery easily by running the Refinery engine generator

    rails generate refinery:engine

to get help on how to use that. Or read the full documentation on [writing engines for Refinery](https://github.com/resolve/refinerycms/blob/master/doc/generators.md)

### Popular Engines

* [Blog](http://github.com/resolve/refinerycms-blog) - A simple blogging engine that supports posts, categories and comments (with moderation support if you choose to enable it)
* [Portfolio](http://github.com/resolve/refinerycms-portfolio) - manage groups of images like an image gallery.
* [News](http://github.com/resolve/refinerycms-news) - post and manage news items.

[Full engine list here](http://github.com/resolve/refinerycms/wiki/engines)

### Example Site Showcase

[List here (add your link when you're done)](http://github.com/resolve/refinerycms/wiki/Example-Site-Showcase)

## License

Refinery is released under the [MIT license](http://github.com/resolve/refinerycms/blob/master/license.md#readme) and is copyright (c) 2005-2011 [Resolve Digital](http://www.resolvedigital.com)

### Credits

Many of the icons used in Refinery CMS are from the wonderful [Silk library by Mark James](http://www.famfamfam.com/lab/icons/silk/).