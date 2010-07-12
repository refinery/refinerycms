## 0.9.7.6 [unreleased]

- Bugfixes, fixed some failing tests. [Philip Arndt]
- More pt-BR translation keys translated [Kivanio Barbosa]
- Locked gems using Gemfile.lock [David Jones]
- [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.5...0.9.7.6)

## 0.9.7.5 [08 July 2010]

- Wrote an upgrade task for migrating from 0.9.6.x releases of RefineryCMS. Just run refinery-update-096-to-097 inside your application's directory. [Philip Arndt]
- Improved code used to include gem rake tasks and script/generate tasks into the Refinery application to fix issue with these tasks not being found [Philip Arndt]
- Fixed a broken migration that would mean pages were missing upon upgrading [Jesper Hvirring Henriksen]
- More pt-BR translation keys translated [Kivanio Barbosa]
- [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.4...0.9.7.5)

## 0.9.7.4 [07 July 2010]

- Fixed critical issue in the i18n routing pattern that was matching prefixes like /news/ as a locale incorrectly. [Philip Arndt]
- [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.3...0.9.7.4)

## 0.9.7.3 [07 July 2010]

- Falls back to default locale when a translation key can not be located in the current locale, only in production mode. [Philip Arndt]
- Fixed issue creating a Refinery site using bin/refinery where directory paths contained spaces. [Philip Arndt]
- Fixed issue when using script/generate refinery surrounding the migration incorrectly using the plugin's title. [Philip Arndt]
- Added verbose=true option when running rake refinery:update that prints out everything it's doing. [Philip Arndt]
- [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.2...0.9.7.3)

## 0.9.7.2 [06 July 2010]

- Bugfixes with users and roles [Philip Arndt and Amanda Wagener]
- Fixed the rake translate:lost_in_translation LOCALE=en and rake translate:lost_in_translation_all tasks so that they accurately reflect the missing i18n translation keys. [Philip Arndt]
- Refactored routing of i18n to allow different default frontend and backend locales. [Philip Arndt]
- Added better grammar support for some i18n [Halan Pinheiro]
- Improved output of rake refinery:update task and removed bin/refinery-update-core task. [Steven Heidel]
- Set config.ru to run in production RAILS_ENV by default [Philip Arndt]
- [See full list](http://github.com/resolve/refinerycms/compare/0.9.7.1...0.9.7.2)

## 0.9.7.1 [03 July 2010]

- Bugfixes in the gem installation method process. [Philip Arndt]
- Made installing from gem faster. [Philip Arndt]
- Provided example files for sqlite3, mysql and postgresql. [Philip Arndt]
- Created option for specifying a database adapter (sqlite3, mysql or postgresql) when creating from Gem. [Philip Arndt]
- Other bugfixes including UI consistency around signup. [Philip Arndt]
- [See full list](http://github.com/resolve/refinerycms/compare/0.9.7...0.9.7.1)

## 0.9.7 [02 July 2010]

- Full backend internationalisation (i18n) support and frontend i18n routing. [Maarten Hoogendoorn and Philip Arndt and many others]
- Marketable URLs, such as /contact [Joshua Davey and Joe Sak].
- Switched to bundler and rack. [Alex Coles and Philip Arndt]
- Added options to Refinery Settings :restricted, :scoping, :callback_proc_as_string. [Steven Heidel and Philip Arndt]
- Added caching abilities to frontend and to RefinerySetting to drastically speed up the application under certain conditions [Philip Arndt]
- Added spam filtering to contact form. [David Jones]
- Full Refinery UI redesign. [Resolve Digital]
- User Role support. [Amanda Wagener and Philip Arndt]
- [See full list](http://github.com/resolve/refinerycms/compare/0.9.6.34...0.9.7)
- [See blog post](http://refinerycms.com/blog/refinery-cms-0-9-7-released)

## 0.9.6.34 [09 May 2010]

- Bugfixes.

## 0.9.6.33 [06 May 2010]

- Bugfixes.

## 0.9.6.32 [05 May 2010]

- Bugfixes.

## 0.9.6.31 [19 April 2010]

- Bugfixes.

## 0.9.6.30 [15 April 2010]

- Bugfixes.

## 0.9.6.29 [14 April 2010]

- Bugfixes.

## 0.9.6.28 [12 April 2010]

- Bugfixes.

## 0.9.6.27 [12 April 2010]

- Bugfixes.

## 0.9.6.26 [07 April 2010]

- Bugfixes.

## 0.9.6.25 [01 April 2010]

- Bugfixes.

## 0.9.6.24 [26 March 2010]

- Bugfixes.

## 0.9.6.23 [26 March 2010]

- Bugfixes.

## 0.9.6.22 [26 March 2010]

- Bugfixes.

## 0.9.6.21 [23 March 2010]

- Bugfixes.

## 0.9.6.19 [03 March 2010]

- Bugfixes.

## 0.9.6.18 [02 March 2010]

- Bugfixes.

## 0.9.6.17 [02 March 2010]

- Bugfixes.

## 0.9.6.16 [02 March 2010]

- Bugfixes.

## 0.9.6.15 [01 March 2010]

- Bugfixes.

## 0.9.6.14 [24 February 2010]

- Bugfixes.

## 0.9.6.13 [23 February 2010]

- Bugfixes.

## 0.9.6.12 [16 February 2010]

- Bugfixes.

## 0.9.6.11 [16 February 2010]

- Bugfixes.

## 0.9.6.10 [15 February 2010]

- Bugfixes.

## 0.9.6.9 [15 February 2010]

- Bugfixes.

## 0.9.6.8 [14 February 2010]

- Bugfixes.

## 0.9.6.7 [10 February 2010]

- Bugfixes.

## 0.9.6.6 [10 February 2010]

- Bugfixes.

## 0.9.6.5 [08 February 2010]

- Bugfixes.

## 0.9.6.4 [07 February 2010]

- Bugfixes.

## 0.9.6.3 [07 February 2010]

- Bugfixes.

## 0.9.6.2 [04 February 2010]

- Bugfixes.

## 0.9.6.1 [04 February 2010]

- Bugfixes.

## 0.9.6 [04 February 2010]

- Minor release.

## 0.9.5.31 [27 January 2010]

- Bugfixes.

## 0.9.5.30 [24 January 2010]

- Bugfixes.

## 0.9.5.29 [23 December 2009]

- Bugfixes.

## 0.9.5.28 [17 December 2009]

- Bugfixes.

## 0.9.5.27 [16 December 2009]

- Bugfixes.

## 0.9.5.26 [13 December 2009]

- Bugfixes.

## 0.9.5.25 [09 December 2009]

- Bugfixes.

## 0.9.5.24 [08 December 2009]

- Bugfixes.

## 0.9.5.23 [07 December 2009]

- Bugfixes.

## 0.9.5.22 [07 December 2009]

- Bugfixes.

## 0.9.5.21 [06 December 2009]

- Bugfixes.

## 0.9.5.20 [03 December 2009]

- Bugfixes.

## 0.9.5.19 [30 November 2009]

- Bugfixes.

## 0.9.5.18 [29 November 2009]

- Bugfixes.

## 0.9.5.16 [26 November 2009]

- Bugfixes.

## 0.9.5.15 [22 November 2009]

- Bugfixes.

## 0.9.5.14 [19 November 2009]

- Bugfixes.

## 0.9.5.13 [18 November 2009]

- Bugfixes.

## 0.9.5.12 [18 November 2009]

- Bugfixes.

## 0.9.5.11 [18 November 2009]

- Bugfixes.

## 0.9.5.10 [17 November 2009]

- Bugfixes.

## 0.9.5.9 [16 November 2009]

- Bugfixes.

## 0.9.5.8 [15 November 2009]

- Bugfixes.

## 0.9.5.7 [09 November 2009]

- Bugfixes.

## 0.9.5.6 [09 November 2009]

- Bugfixes.

## 0.9.5.5 [08 November 2009]

- Bugfixes.

## 0.9.5.4 [04 November 2009]

- Bugfixes.

## 0.9.5.3 [04 November 2009]

- Bugfixes.

## 0.9.5.2 [04 November 2009]

- Bugfixes.

## 0.9.5.1 [03 November 2009]

- Bugfixes.

## 0.9.5 [03 November 2009]

- Minor release.

## 0.9.4.4 [29 October 2009]

- Bugfixes.

## 0.9.4.3 [19 October 2009]

- Bugfixes.

## 0.9.4.2 [19 October 2009]

- Bugfixes.

## 0.9.4 [15 October 2009]

- Minor release.

## 0.9.3 [11 October 2009]

- Optimise loading of WYM Editors
- Supported more plugins' menu matches

## 0.9.2.2 [08 October 2009]

- Bugfixes.

## 0.9.2.1 [08 October 2009]

- Fix bug with using instance_methods vs using methods to detect whether friendly_id is present.

## 0.9.2 [08 October 2009]

- Update rails gem requirement to 2.3.4.

## 0.9.1.2 [07 October 2009]

- Updated JS libraries and added lots of convenience methods.

## 0.9.1.1 [05 October 2009]

- HTML & CSS changes.

## 0.9.1 [04 October 2009]

- Bugfixes
- Renamed project from Refinery to refinerycms and released as a gem.

## 0.9 [29 May 2009]

- Initial public release.
