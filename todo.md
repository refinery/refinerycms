# Todo

What are some of the known things that need to be done?

## Tests

* Add unit test coverage for user, user plugin and user mailer
* Add unit test coverage for inquiry mailer and inquiry setting
* Add functional tests for the whole of Refinery.

# Rails 3.0 Support

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

# Improve the Generator

We need to have support for build in Refinery field types like "image". So I could run

  ./script/generate refinery staff name:string bio:text mugshot:image

And it will automatically create a form field that pops open the image picker on the staff form.

There is now a partial to easily call an image picker.

# I18n support

* Check all the views for missing translations
  - Write a small tool that extracts t('.whatever') and check which translation keys are missing, or which keys are not used at all.
* Translate models and model attributes used in forms (Rails 2.3.8 supports translation form labels!)
* Javascript messages etc:
  - http://github.com/fnando/i18n-js
