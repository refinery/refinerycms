# Contribution Guidelines #

## Submitting a new issue ##

If you want to ensure that your issue gets fixed *fast* you should
attempt to reproduce the issue in an isolated example application that
you can share.

## Running tests ##

Always run tests first. Quick start for tests (requires a dummy application) :

    bundle install
    bundle exec rake refinery:testing:dummy_app
    bundle exec rake

## Making a pull request ##

If you'd like to submit a pull request please adhere to the following:

1. Your code *must* be tested. Please TDD your code!
2. No single-character variables.
3. Two-spaces instead of tabs.
4. Double-quoted strings are fine for all use cases.
5. General Rails/Ruby naming conventions for files and classes.
6. Please add `[ci skip]` to your commit message for purely documentation changes **only**.

Please note that you must adhere to each of the above mentioned rules.
Failure to do so will result in an immediate closing of the pull
request. If you update and rebase the pull request to follow the
guidelines your pull request will be re-opened and considered for
inclusion.

## Links ##

See also the [Contributing to Refinery](http://refinerycms.com/guides/contributing-to-refinery) guide.
