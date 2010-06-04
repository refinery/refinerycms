# Todo

What are some of the known things that need to be done?

## Tests

* Add unit test coverage for user, user plugin and user mailer
* Add unit test coverage for inquiry mailer and inquiry setting
* Add functional tests for the whole of Refinery.

# Rails 3.0 Support

We've started an effort to move to Rails 3.0 - that just needs to be completed.

# Improve the Generator

We need to have support for build in Refinery field types like "image". So I could run

  ./script/generate refinery staff name:string bio:text mugshot:image
  
And it will automatically create a form field that pops open the image picker on the staff form.

There is now a partial to easily call an image picker.

# I18n support

* Check all the views for missing translations
* Translate model attributes used in forms
* Think about i18n in the javascript files. I've found a few options:
  - http://tore.darell.no/posts/introducing_babilu_rails_i18n_for_your_javascript
  - http://github.com/fnando/i18n-js

  We propably will have to modify one of these, to use the locales in the plugins.
  UPDATE: I'm going for nr 2, since the first isn't that active anymore. (see github pages of both projects)

