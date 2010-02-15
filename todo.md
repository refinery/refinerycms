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