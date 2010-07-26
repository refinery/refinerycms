# Todos required for 1.0 release

## Solid Test Coverage

* Add Cucumber for the whole of Refinery. (top priority)
* Add unit test coverage for user, user plugin and user mailer
* Add unit test coverage for inquiry mailer and inquiry setting
* Add functional tests for the whole of Refinery.
* Add RSpec for the whole of Refinery.

## Rails 3.0 Support

We've started an effort to move to Rails 3.0 - in fact, you are currently
viewing the Rails 3.0 branch.

Work items still to do:

* Rework to exploit Rails 3 initialization hooks correctly (medium).
* Cucumber tests (medium) to check for regressions.
* Explore making the application into multiple gems, managed by Bundler (as a
  reference, refer to Spree: http://github.com/railsdog/spree)
* Migrate to new generator API  (low).
* Migrate to new Mailer API (low).
* Fix other deprecations (low).

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

# Internet Explorer 7+ Support

* WYMEditor and the dialogs are the weakest areas right now.

# Organise a party and media for 1.0 release

