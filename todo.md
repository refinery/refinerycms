# Todos required for 1.0 release

## Plugin API

* Install process, update process, copying assets to public
* All these things should be made standard so that it is easier for plugin authors
* The refinery_engine generator should create those files necessary for the plugin to be installed elsewhere
* Most plugins should be packaged as gems for ease
* Standardize the naming (refinerycms-[plugin_name]), most do this already but there are a few exceptions

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

# Organise a party and media for 1.0 release