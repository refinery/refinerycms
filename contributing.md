# Contribution Guidelines #

## Submitting a new issue ##

If you want to ensure that your issue gets fixed *fast* you should
attempt to reproduce the issue in an isolated example application that
you can share.

## Running tests ##

Always run tests first. Quick start for tests (requires a dummy application) :

    bundle install
    bundle exec rake refinery:testing:dummy_app
    rake

## Making a pull request ##

If you'd like to submit a pull request please adhere to the following:

1. Your code *must* be tested. Please TDD your code!
2. No single-character variables
3. Two-spaces instead of tabs
4. Single-quotes instead of double-quotes unless you are using string
   interpolation or escapes.
5. General Rails/Ruby naming conventions for files and classes

Please note that you must adhere to each of the above mentioned rules.
Failure to do so will result in an immediate closing of the pull
request. If you update and rebase the pull request to follow the
guidelines your pull request will be re-opened and considered for
inclusion.

## Links ##

See also [Contributing to Refinery](http://refinerycms.com/guides/contributing-to-refinery) guide.
