# Todo

What are some of the known things that need to be done?

## Tests

* Add unit test coverage for user, user plugin and user mailer
* Add unit test coverage for inquiry mailer and inquiry setting
* Add functional tests for the whole of Refinery.
* Add Cucumber for the whole of Refinery. (MOST IMPORTANT)
* Add RSpec for the whole of Refinery.

## Rails 3.0 Support

We've started an effort to move to Rails 3.0 - that just needs to be completed.

Join the IRC channel on freenode.net #refinerycms on August 7th to contribute!

## I18n support

* Check all the views for missing translations
* Translate models and model attributes used in forms (Rails 2.3.8 supports translation form labels!)
* Javascript messages etc:
  - http://github.com/fnando/i18n-js
* Add in i18n support for the front-end as well

## Plugin API

* Install process, update process, copying assets to public
* All these things should be made standard so that it is easier for plugin authors
* Most plugins should be packaged as gems for ease
* Standardize the naming (refinerycms-[plugin_name]), most do this already but there are a few exceptions
