## 0.9.7.12 [11 August 2010]

* Smoothed the sortable list in the admin UI. [Joe Sak](http://github.com/joemsak)
* Binding link dialogue URL checker to paste action. [Joe Sak](http://github.com/joemsak)
* Kill hidden overflow on dialogues for smaller browser windows. [Joe Sak](http://github.com/joemsak) and [Philip Arndt](http://github.com/parndt)
* Refactored the ``parse_branch`` method to speed up reordering on the server. [Joshua Davey](http://github.com/jgdavey)
* Running ``refinerycms`` with ``-v`` or ``--version`` will now output the version number. [Steven Heidel](http://github.com/stevenheidel)
* Made the core codebase not rely so heavily on ``@page[:body]`` by adding ``Page.default_parts`` and using ``.first`` on that instead. [Philip Arndt](http://github.com/parndt)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.11...0.9.7.12)

## 0.9.7.11 [07 August 2010]

* Removed ``app/controllers/application.rb`` due to its serious deprecation. Fixed deprecations in how we use acts_as_indexed. [Philip Arndt](http://github.com/parndt)
* Added passing cucumber features for search for: [Uģis Ozols](http://github.com/ugisozols)
  - Images
  - Files
  - Inquiries
  - Pages
* Moved HTML5 enabling script to a partial so that IE always runs it first. [Philip Arndt](http://github.com/parndt)
* Fixed some invalid HTML. [Bo Frederiksen](http://github.com/bofrede)
* Added Danish translation for WYMeditor. [Bo Frederiksen](http://github.com/bofrede)
* Fixes for Tooltips [Philip Arndt](http://github.com/parndt)
  - Tooltips were not showing in dialogues, they now are.
  - Tooltips would not position properly above links, they now do.
  - The Tooltips' nibs (the arrow) would not sit properly centered above the element if the tooltip had to move for the browser window size, they now do.
* Lots of fixes for translations. [Uģis Ozols](http://github.com/ugisozols)
* Fix XSS vulnerability on page meta information by escaping the relevant fields properly [David Jones](http://github.com/djones)
* Ensure that the generator script grabs the first attribute that is a string, not just the first attribute, when choosing the field for Dashboard activity. [Joe Sak](http://github.com/joemsak)
* Updated ``json-pure`` to ``1.4.5``, now using the actual gem [Philip Arndt](http://github.com/parndt)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.10...0.9.7.11)


## 0.9.7.10 [02 August 2010]

* Added options to site_bar partial to allow particular components to be disabled (CSS, JS, jQuery or cornering script) so that they don't interfere with these already being included in the theme. [Philip Arndt](http://github.com/parndt)
* Fixed the schema file as it was invalid somehow. [Steven Heidel](http://github.com/stevenheidel)
* Made search more consistent and added it to Spam/Ham. [Uģis Ozols](http://github.com/ugisozols)
* Fixed a bug with adding new resources. [Steven Heidel](http://github.com/stevenheidel)
* Fixed a range of issues with translation keys and grammar between different languages. [Uģis Ozols](http://github.com/ugisozols)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.9...0.9.7.10)

## 0.9.7.9 [30 July 2010]

* Added a theme generator to create the basic file structure of a new theme. [David Jones](http://github.com/djones) and [Levi Cole](http://github.com/levicole)
* Renamed ``script/generate refinery`` to ``script/generate refinery_plugin``. [David Jones](http://github.com/djones)
* Add deprecation notice to ``script/generate refinery``. [David Jones](http://github.com/djones)
* Updated documentation to reflect new generator changes. [David Jones](http://github.com/djones)
* Added tests for both plugin and theme generators. [David Jones](http://github.com/djones) and [Levi Cole](http://github.com/levicole)
* Refactored the ``refinerycms`` & ``refinery-upgrade-097-to-097`` tasks to make better use of Pathname. [Philip Arndt](http://github.com/parndt)
* Added more cucumber features and tagged existing ones. [Philip Arndt](http://github.com/parndt), [James Fiderlick](http://github.com/jamesfid) and [Steven Heidel](http://github.com/stevenheidel)
* Removed mysterious ``page_translations`` table if you had it. [Philip Arndt](http://github.com/parndt)
* Added workaround for tests that involve dialogues. [Uģis Ozols](http://github.com/ugisozols)
* Added as default the ability for forms to know whether they are inside a modal / dialog. [Philip Arndt](http://github.com/parndt)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.8...0.9.7.9)

## 0.9.7.8 [23 July 2010]

* Refactored Amazon S3 and gem installation to make it easier to install on Heroku. [Steven Heidel](http://github.com/stevenheidel)
* Made project more testable. Renamed rake refinery:test_all to rake test:refinery [Philip Arndt](http://github.com/parndt)
* Documentation improved [David Jones](http://github.com/djones), [Philip Arndt](http://github.com/parndt) and [Steven Heidel](http://github.com/stevenheidel)
* Installed spork for use with systems that support forking for performance improvements. Doesn't run on Windows. [Philip Arndt](http://github.com/parndt) and [James Fiderlick](http://github.com/jamesfid)
* Improvements and new translations for Norsk Bokmål localisation. [Ken Paulsen](http://github.com/ken-guru)
* Ensured that RefinerySetting restrictions work properly using a before_save handler. [Joe Sak](http://github.com/joemsak)
* Updated jquery-html5-placeholder-shim to latest version. [Amanda Wagener](http://github.com/awagener)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.7...0.9.7.8)

## 0.9.7.7 [20 July 2010]

* Fixed an issue in the plugin generator that saw locales being created with singular_name not the interpreted version. [Philip Arndt](http://github.com/parndt) and [Joe Sak](http://github.com/joemsak)
* Fixed an issue with non-MySQL databases. [Lee Irving](http://github.com/magpieuk)
* Refactored versioning and .gitignore file so that both are easier to follow and use. [Steven Heidel](http://github.com/stevenheidel)
* Added rake refinery:test_all command to run all tests Refinery has. [Steven Heidel](http://github.com/stevenheidel)
* Fixed deprecation warnings with translate rake tasks. [Steven Heidel](http://github.com/stevenheidel)
* Bugfixes, some IE compatibility. [Philip Arndt](http://github.com/parndt)
* Fix syntax errors in existing resource dialog. [David Jones](http://github.com/djones)
* Identified and fixed a positioning bug in dialogues [Joe Sak](http://github.com/joemsak) and [Philip Arndt](http://github.com/parndt)
* Fixed issue that was causing Refinery to load in rake tasks twice if they lived under ``"#{Rails.root}/vendor/plugins"``. [David Jones](http://github.com/djones) and [Philip Arndt](http://github.com/parndt)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.6...0.9.7.7)

## 0.9.7.6 [15 July 2010]

* Bugfixes, fixed some failing tests. [Philip Arndt](http://github.com/parndt)
* More pt-BR translation keys translated. [Kivanio Barbosa](http://github.com/kivanio)
* Locked gems using ``Gemfile.lock``. [David Jones](http://github.com/djones)
* Changed 'refinery' task to 'refinerycms' as that is our gem's name. [Steven Heidel](http://github.com/stevenheidel)
* Fixed bug where settings were still considered restricted if NULL. [Steven Heidel](http://github.com/stevenheidel)
* Ensures that bundler is available before creating an application from a gem. [Philip Arndt](http://github.com/parndt)
* Application generator (from gem) and application upgrade bin task. (from 0.9.6) is now Ruby 1.9.2 compatible. [Philip Arndt](http://github.com/parndt)
* bin/refinery-upgrade-from-096-to-097 will no longer allow you to run it if Gemfile is present and thus signifying an upgraded app. [Philip Arndt](http://github.com/parndt)
* Cleaned up syntax, changed CSS involving dialogues. [Philip Arndt](http://github.com/parndt)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.5...0.9.7.6)

## 0.9.7.5 [08 July 2010]

* Wrote an upgrade task for migrating from 0.9.6.x releases of RefineryCMS. Just run refinery-update-096-to-097 inside your application's directory. [Philip Arndt](http://github.com/parndt)
* Improved code used to include gem rake tasks and script/generate tasks into the Refinery application to fix issue with these tasks not being found. [Philip Arndt](http://github.com/parndt)
* Fixed a broken migration that would mean pages were missing upon upgrading. [Jesper Hvirring Henriksen](http://github.com/hvirring)
* More pt-BR translation keys translated. [Kivanio Barbosa](http://github.com/kivanio)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.4...0.9.7.5)

## 0.9.7.4 [07 July 2010]

* Fixed critical issue in the i18n routing pattern that was matching prefixes like /news/ as a locale incorrectly. [Philip Arndt](http://github.com/parndt)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.3...0.9.7.4)

## 0.9.7.3 [07 July 2010]

* Falls back to default locale when a translation key can not be located in the current locale, only in production mode. [Philip Arndt](http://github.com/parndt)
* Fixed issue creating a Refinery site using bin/refinery where directory paths contained spaces. [Philip Arndt](http://github.com/parndt)
* Fixed issue when using script/generate refinery surrounding the migration incorrectly using the plugin's title. [Philip Arndt](http://github.com/parndt)
* Added verbose=true option when running rake refinery:update that prints out everything it's doing. [Philip Arndt](http://github.com/parndt)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.2...0.9.7.3)

## 0.9.7.2 [06 July 2010]

* Bugfixes with users and roles. [Philip Arndt](http://github.com/parndt) and [Amanda Wagener](http://github.com/awagener)
* Fixed the rake translate:lost_in_translation LOCALE=en and rake translate:lost_in_translation_all tasks so that they accurately reflect the missing i18n translation keys. [Philip Arndt](http://github.com/parndt)
* Refactored routing of i18n to allow different default frontend and backend locales. [Philip Arndt](http://github.com/parndt)
* Added better grammar support for some i18n. [Halan Pinheiro](http://github.com/halan)
* Improved output of rake refinery:update task and removed bin/refinery-update-core task. [Steven Heidel](http://github.com/stevenheidel)
* Set config.ru to run in production RAILS_ENV by default. [Philip Arndt](http://github.com/parndt)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.1...0.9.7.2)

## 0.9.7.1 [03 July 2010]

* Bugfixes in the gem installation method process. [Philip Arndt](http://github.com/parndt)
* Made installing from gem faster. [Philip Arndt](http://github.com/parndt)
* Provided example files for sqlite3, mysql and postgresql. [Philip Arndt](http://github.com/parndt)
* Created option for specifying a database adapter (sqlite3, mysql or postgresql) when creating from Gem. [Philip Arndt](http://github.com/parndt)
* Other bugfixes including UI consistency around signup. [Philip Arndt](http://github.com/parndt)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.7...0.9.7.1)

## 0.9.7 [02 July 2010]

* Full backend internationalisation (i18n) support and frontend i18n routing. [Maarten Hoogendoorn](http://github.com/moretea) and [Philip Arndt](http://github.com/parndt) and many others
* Marketable URLs, such as "/contact". [Joshua Davey](http://github.com/jgdavey) and [Joe Sak](http://github.com/joemsak).
* Switched to bundler and rack. [Alex Coles](http://github.com/myabc) and [Philip Arndt](http://github.com/parndt)
* Added options to Refinery Settings :restricted, :scoping, :callback_proc_as_string. [Steven Heidel](http://github.com/stevenheidel) and [Philip Arndt](http://github.com/parndt)
* Added caching abilities to frontend and to RefinerySetting to drastically speed up the application under certain conditions. [Philip Arndt](http://github.com/parndt)
* Added spam filtering to contact form. [David Jones](http://github.com/djones)
* Full Refinery UI redesign. [Resolve Digital](http://github.com/resolve)
* User Role support. [Amanda Wagener](http://github.com/awagener) and [Philip Arndt](http://github.com/parndt)
* [See full list](http://github.com/resolve/refinerycms/compare/0.9.6.34...0.9.7)
* [See blog post](http://refinerycms.com/blog/refinery-cms-0-9-7-released)

## 0.9.6.34 [09 May 2010]

* Bugfixes.

## 0.9.6.33 [06 May 2010]

* Bugfixes.

## 0.9.6.32 [05 May 2010]

* Bugfixes.

## 0.9.6.31 [19 April 2010]

* Bugfixes.

## 0.9.6.30 [15 April 2010]

* Bugfixes.

## 0.9.6.29 [14 April 2010]

* Bugfixes.

## 0.9.6.28 [12 April 2010]

* Bugfixes.

## 0.9.6.27 [12 April 2010]

* Bugfixes.

## 0.9.6.26 [07 April 2010]

* Bugfixes.

## 0.9.6.25 [01 April 2010]

* Bugfixes.

## 0.9.6.24 [26 March 2010]

* Bugfixes.

## 0.9.6.23 [26 March 2010]

* Bugfixes.

## 0.9.6.22 [26 March 2010]

* Bugfixes.

## 0.9.6.21 [23 March 2010]

* Bugfixes.

## 0.9.6.19 [03 March 2010]

* Bugfixes.

## 0.9.6.18 [02 March 2010]

* Bugfixes.

## 0.9.6.17 [02 March 2010]

* Bugfixes.

## 0.9.6.16 [02 March 2010]

* Bugfixes.

## 0.9.6.15 [01 March 2010]

* Bugfixes.

## 0.9.6.14 [24 February 2010]

* Bugfixes.

## 0.9.6.13 [23 February 2010]

* Bugfixes.

## 0.9.6.12 [16 February 2010]

* Bugfixes.

## 0.9.6.11 [16 February 2010]

* Bugfixes.

## 0.9.6.10 [15 February 2010]

* Bugfixes.

## 0.9.6.9 [15 February 2010]

* Bugfixes.

## 0.9.6.8 [14 February 2010]

* Bugfixes.

## 0.9.6.7 [10 February 2010]

* Bugfixes.

## 0.9.6.6 [10 February 2010]

* Bugfixes.

## 0.9.6.5 [08 February 2010]

* Bugfixes.

## 0.9.6.4 [07 February 2010]

* Bugfixes.

## 0.9.6.3 [07 February 2010]

* Bugfixes.

## 0.9.6.2 [04 February 2010]

* Bugfixes.

## 0.9.6.1 [04 February 2010]

* Bugfixes.

## 0.9.6 [04 February 2010]

* Minor release.

## 0.9.5.31 [27 January 2010]

* Bugfixes.

## 0.9.5.30 [24 January 2010]

* Bugfixes.

## 0.9.5.29 [23 December 2009]

* Bugfixes.

## 0.9.5.28 [17 December 2009]

* Bugfixes.

## 0.9.5.27 [16 December 2009]

* Bugfixes.

## 0.9.5.26 [13 December 2009]

* Bugfixes.

## 0.9.5.25 [09 December 2009]

* Bugfixes.

## 0.9.5.24 [08 December 2009]

* Bugfixes.

## 0.9.5.23 [07 December 2009]

* Bugfixes.

## 0.9.5.22 [07 December 2009]

* Bugfixes.

## 0.9.5.21 [06 December 2009]

* Bugfixes.

## 0.9.5.20 [03 December 2009]

* Bugfixes.

## 0.9.5.19 [30 November 2009]

* Bugfixes.

## 0.9.5.18 [29 November 2009]

* Bugfixes.

## 0.9.5.16 [26 November 2009]

* Bugfixes.

## 0.9.5.15 [22 November 2009]

* Bugfixes.

## 0.9.5.14 [19 November 2009]

* Bugfixes.

## 0.9.5.13 [18 November 2009]

* Bugfixes.

## 0.9.5.12 [18 November 2009]

* Bugfixes.

## 0.9.5.11 [18 November 2009]

* Bugfixes.

## 0.9.5.10 [17 November 2009]

* Bugfixes.

## 0.9.5.9 [16 November 2009]

* Bugfixes.

## 0.9.5.8 [15 November 2009]

* Bugfixes.

## 0.9.5.7 [09 November 2009]

* Bugfixes.

## 0.9.5.6 [09 November 2009]

* Bugfixes.

## 0.9.5.5 [08 November 2009]

* Bugfixes.

## 0.9.5.4 [04 November 2009]

* Bugfixes.

## 0.9.5.3 [04 November 2009]

* Bugfixes.

## 0.9.5.2 [04 November 2009]

* Bugfixes.

## 0.9.5.1 [03 November 2009]

* Bugfixes.

## 0.9.5 [03 November 2009]

* Minor release.

## 0.9.4.4 [29 October 2009]

* Bugfixes.

## 0.9.4.3 [19 October 2009]

* Bugfixes.

## 0.9.4.2 [19 October 2009]

* Bugfixes.

## 0.9.4 [15 October 2009]

* Minor release.

## 0.9.3 [11 October 2009]

* Optimise loading of WYM Editors.
* Supported more plugins' menu matches.

## 0.9.2.2 [08 October 2009]

* Bugfixes.

## 0.9.2.1 [08 October 2009]

* Fix bug with using instance_methods vs using methods to detect whether friendly_id is present.

## 0.9.2 [08 October 2009]

* Update rails gem requirement to 2.3.4.

## 0.9.1.2 [07 October 2009]

* Updated JS libraries and added lots of convenience methods.

## 0.9.1.1 [05 October 2009]

* HTML & CSS changes.

## 0.9.1 [04 October 2009]

* Bugfixes.
* Renamed project from Refinery to refinerycms and released as a gem.

## 0.9 [29 May 2009]

* Initial public release.
