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

* Check all the views for missing translations (TIP: Start with grep "todo" . -r 
  it should return some issues i've found, but not yet solved)
* Write a tool that extracts all the t(<matchdata>) and I18n.translate(<matchdata>) 
  from the projects, dumps it into a yml file. This should allow us to write another tool,
  that checks the correctness of our translation files (Wheter we have covered all the translation keys,
  and which ones are doubles). I'm thinking about making this a separate rake task, so that We'll be able to use
  this in our other projects.
* Think about i18n in the javascript files. I've found a few options:
  - http://tore.darell.no/posts/introducing_babilu_rails_i18n_for_your_javascript
  - http://github.com/fnando/i18n-js

  We propably will have to modify one of these, to use the locales in the plugins.
