# Todos required for 0.9.9 release

## Engine API

* Install process, update process
* All these things should be made standard so that it is easier for engine authors
* The refinery_engine generator should create those files necessary for the engine to be installed elsewhere
* Most engines should be packaged as gems for ease
* Standardize the naming (refinerycms-[engine_name]), most do this already but there are a few exceptions

## Internet Explorer 7+ Support

* WYMEditor and the dialogs are the weakest areas right now.

## Solid Test Coverage

* Add more Cucumber features for the whole of Refinery.
* Add RSpec for the whole of Refinery, particularly:
  - User, User plugin and User mailer
  - Inquiry mailer and Inquiry setting

## I18n support

* Check all the views for missing translations
  - You can run a rake task with your locale e.g for Slovenian:
  ``rake translate:lost_in_translation LOCALE=sl``

# Todos required for 1.0.0 release

* All tests much pass
* Test and perfect everything.
* Organise a party and media