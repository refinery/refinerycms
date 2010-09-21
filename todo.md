# Todos required for 0.9.9 release

## Solid Test Coverage

Responsible person: ``VGoff``, ``hubble``

* Add more Cucumber features for the whole of Refinery.
* Add RSpec for the whole of Refinery, particularly:
  - User, User engine and User mailer
  - Inquiry mailer
  - Refinery settings

## Internet Explorer 7+ Support

Responsible person: ``parndt``

* WYMEditor and the dialogs are the weakest areas right now.

Responsible person: ``stevenheidel``, ``djones``, ``everyone``

* Finding and filing issues found in IE

## I18n support

* Check all the views for missing translations
  - You can run a rake task with your locale e.g for Slovenian:
  ``rake translate:lost_in_translation LOCALE=sl``

# Todos required for 1.0.0 release

* All tests must pass
* Test and perfect everything.
* Organise a party and media