# Todos required for 0.9.9 release

## Solid Test Coverage

Responsible person: ``VGoff``, ``hubble``, ``anyone willing and able``

* Add more Cucumber features for the whole of Refinery.
* Add RSpec for the whole of Refinery, particularly:
  - User, User engine and User mailer
  - Inquiry mailer
  - Refinery settings

## Internet Explorer 7+ Support

Responsible person: ``parndt``, ``anyone willing and able``

* WYMEditor and the dialogs are the weakest areas right now.

Responsible person: ``stevenheidel``, ``djones``, ``anyone willing and able``

* Finding and filing issues found in IE

## I18n support

Responsible person: ``anyone willing and able``

* Check all the views for missing translations
  - You can run a rake task with your locale e.g for Slovenian:
  ``rake translate:lost_in_translation LOCALE=sl``

# Todos required for 1.0.0 release

* All tests must pass
* Test and perfect everything.
* Organise a party and media