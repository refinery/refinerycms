# Todo

What are some of the known things that need to be done?

## Internationalization

We've got a branch for it and we need to merge that into the master.

## Tests

* Add unit test coverage for user, user plugin and user mailer
* Add unit test coverage for inquiry mailer and inquiry setting
* Add functional tests for the whole of Refinery.

# Rails 3.0 Support

We've started an effort to move to Rails 3.0 - in fact, you are currently
viewing the Rails 3.0 branch.

Work items still to do:

* Routing fixes (high).
* Rework to exploit Rails 3 initialization hooks correctly (medium).
* Cucumber tests (medium) to check for regressions.
* Test that the application works as a gem.
* Explore making the application into multiple gems, managed by Bundler.
* Migrate to new generator API  (low)..
* Migrate to new Mailer API (low).
* Fix other deprecations (low).
