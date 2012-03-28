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
* [Install Refinery CMS on Heroku](http://refinerycms.com/guides/heroku)
* [Contribute to Refinery CMS](http://refinerycms.com/guides/contributing-to-refinery)

## Getting Started

If you're new to Refinery, start with this guide:

* __[Getting started with Refinery](http://refinerycms.com/guides/getting-started-with-refinery)__

## What's it good at?

__Refinery is great for sites where the client needs to be able to update their website themselves__ without being bombarded with anything too complicated.

Unlike other content managers, Refinery is truly __aimed at the end user__ making it easy for them to pick up and make changes themselves.

### For developers

* Easily customise the look to suit the business.
* __Extend with custom extensions__ to do anything Refinery doesn't do out of the box.
* Sticks to __"the Rails way"__ as much as possible; we don't force you to learn new templating languages.
* Uses [jQuery](http://jquery.com/) for fast and concise Javascript.

![Refinery Dashboard](http://refinerycms.com/system/images/0000/0576/dashboard.png)

Wanna see Refinery for yourself? [Try the demo](http://demo.refinerycms.com/refinery)

## Help and Documentation

* [Getting Started](http://refinerycms.com/guides/getting-started-with-refinery)
* [Guides](http://refinerycms.com/guides)
* [Google Group Discussion](http://group.refinerycms.org)
* [IRC Channel](http://refinerycms.com/guides/how-to-get-help-with-refinery#irc-channel)
* [GitHub repository](https://github.com/resolve/refinerycms)
* [Developer/API documentation](http://api.refinerycms.org)
* [Twitter Account](http://twitter.com/refinerycms)

## Features

### Pages

* Easily edit and manage pages with a [WYSIWYG visual editor](http://www.wymeditor.org/).
* Manage you site's structure.

### Images & Files

* Easily upload and insert images.
* Upload and link to resources such as PDF documents.
* Uses the popular [Dragonfly](https://github.com/markevans/dragonfly).
* Supports storage on Amazon S3.

### Dashboard

* Get an overview of what has been updated recently and see recent inquiries.

### Authentication & Users

* Manage who can access Refinery.
* Control which extensions each user has access to.
* Uses the popular [devise](https://github.com/plataformatec/devise).

Extend Refinery easily by running the Refinery extension generator. 
For help run the command without any options:

    rails generate refinery:engine

### Popular Engines

* [Blog](https://github.com/resolve/refinerycms-blog) - A simple blogging extension that supports posts, categories and comments (with moderation support if you choose to enable it)
* [Portfolio](https://github.com/resolve/refinerycms-portfolio) - manage groups of images like an image gallery.
* [News](https://github.com/resolve/refinerycms-news) - post and manage news items.

[Full extension list here](http://refinerycms.com/engines)

### Example Site Showcase

[List here (add your link when you're done)](https://github.com/resolve/refinerycms/wiki/Example-Site-Showcase)

## License

Refinery is released under the [MIT license](https://github.com/resolve/refinerycms/blob/master/license.md#readme) and is copyright (c) 2005-2012 [Resolve Digital](http://www.resolvedigital.com)

### Credits

Many of the icons used in Refinery CMS are from the wonderful [Silk library by Mark James](http://www.famfamfam.com/lab/icons/silk/).