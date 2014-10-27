# Refinery CMS

__An open source content management system for Rails 4.1+__

More information at [http://refinerycms.com](http://refinerycms.com)

[![Build Status](https://travis-ci.org/refinery/refinerycms.svg?branch=master)](https://travis-ci.org/refinery/refinerycms)  [![Code Climate](https://codeclimate.com/github/refinery/refinerycms.svg)](https://codeclimate.com/github/refinery/refinerycms)  [![Coverage Status](https://img.shields.io/coveralls/refinery/refinerycms.svg)](https://coveralls.io/r/refinery/refinerycms?branch=master)

You can chat with us using Gitter:

[![Gitter chat](https://badges.gitter.im/refinery/refinerycms.svg)](https://gitter.im/refinery/refinerycms)

## Requirements

* [Bundler](http://gembundler.com)
* [ImageMagick](http://www.imagemagick.org/script/install-source.php)
  * Mac OS X users should use [homebrew's](https://github.com/mxcl/homebrew/wiki/installation) `brew install imagemagick` or the [magick-installer](https://github.com/maddox/magick-installer).

## How to

* __[Install Refinery CMS](http://refinerycms.com/download)__
* [Install Refinery CMS on Heroku](http://refinerycms.com/guides/heroku)
* [Contribute to Refinery CMS](readme.md#contributing)

## Getting Started

If you're new to Refinery, start with this guide:

* __[Getting Started](http://refinerycms.com/guides/getting-started)__

If you want to use Rails 4.1.x with Refinery now, install using this template:

    rails new app_name -m http://refinerycms.com/t/edge

## What's it good at?

__Refinery is great for sites where the client needs to be able to update their website themselves__ without being bombarded with anything too complicated.

Unlike other content managers, Refinery is truly __aimed at the end user__ making it easy for them to pick up and make changes themselves.

### For developers

* Easily customise the look to suit the business.
* __Extend with custom extensions__ to do anything Refinery doesn't do out of the box.
* Sticks to __"the Rails way"__ as much as possible; we don't force you to learn new templating languages.
* Uses [jQuery](http://jquery.com/) for fast and concise Javascript.

![Refinery Pages UI](http://refinerycms.com/system/images/0000/0576/dashboard.png)

Wanna see Refinery for yourself? [Try the demo](http://demo.refinerycms.com/refinery).

## Help and Documentation

* [Getting Started](http://refinerycms.com/guides/getting-started)
* [Guides](http://refinerycms.com/guides)
* [Google Group Discussion](http://group.refinerycms.org)
* [IRC Channel](http://refinerycms.com/guides/how-to-get-help#irc-channel)
* [Gitter chat](https://gitter.im/refinery/refinerycms)
* [GitHub repository](https://github.com/refinery/refinerycms)
* [Developer/API documentation](http://rubydoc.info/github/refinery/refinerycms)
* [Twitter Account](https://twitter.com/refinerycms)

## Features

### Pages

* Easily edit and manage pages with a visual editor.
* Manage your site's structure.

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
* Uses the popular [Devise](https://github.com/plataformatec/devise).

### Custom Extensions

Extend Refinery easily by running the Refinery extension generator.
For help run the command without any options:

    rails generate refinery:engine

### Popular Extensions

* [Blog](https://github.com/refinery/refinerycms-blog) - A simple blogging extension that supports posts, categories and comments with optional moderation support.
* [Portfolio](https://github.com/refinery/refinerycms-portfolio) - manage groups of images like an image gallery.
* [News](https://github.com/refinery/refinerycms-news) - post and manage news items.
* [Inquiries](https://github.com/refinery/refinerycms-inquiries) - simple contact form that notifies you and customer when an inquiry is made.

[Full extension list here](http://refinerycms.com/engines)

### Example Site Showcase

[List here (add your link when you're done)](https://github.com/refinery/refinerycms/wiki/Example-Site-Showcase)

## Contributing

See [contributing.md](contributing.md)
and [Contributing to Refinery](http://refinerycms.com/guides/contributing-to-refinery)
guide for details about contributing and running test.

## License

Refinery is released under the MIT license. See the [license.md file](license.md#readme) for details.

### Credits

Many of the icons used in Refinery CMS are from the wonderful [Silk library by Mark James](http://www.famfamfam.com/lab/icons/silk/).
