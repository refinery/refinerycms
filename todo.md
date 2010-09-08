# Todos required for 0.9.9 release

## Engine API

Responsible person: ``djones``

rails g refinery_engine does the following things:

- Creates what it does now
- Creates a gemspec with the gem name of "refinerycms-#{engine_name}"
- Puts the gem in the Gemfile
- Copies db files to the vendor/engines/engine_name/db folder ONLY
- Creates a generator in lib/generators which will install the db to the right place
- Creates a public, spec, and features empty folders
- Creates lib/tasks as a template
- Maybe some sort of README on how to release your gem open source

Then the process will be:

### To create a fully releasable engine

    rails g refinery_engine events name:string date:date picture:image

### To install the plugin into your app

    rails g refinerycms_events
    bundle install
    rake db:migrate

And then when it's released all new refinerycms- gems will have the same install process. Yippee!

## Internet Explorer 7+ Support

Responsible person: ``parndt``

* WYMEditor and the dialogs are the weakest areas right now.

Responsible person: ``stevenheidel``, ``djones``

* Finding and filing issues found in IE

## Solid Test Coverage

Responsible person: ``VGoff``

* Add more Cucumber features for the whole of Refinery.
* Add RSpec for the whole of Refinery, particularly:
  - User, User plugin and User mailer
  - Inquiry mailer and Inquiry setting

## I18n support

* Check all the views for missing translations
  - You can run a rake task with your locale e.g for Slovenian:
  ``rake translate:lost_in_translation LOCALE=sl``

# Todos required for 1.0.0 release

* All tests must pass
* Test and perfect everything.
* Organise a party and media