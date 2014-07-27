## 3.0.0 [unreleased]

* Deprecated ':format' syntax in Resources dragonfly_url_format. [#2500](https://github.com/refinery/refinerycms/pull/2500). [Josef Šimánek](https://github.com/simi)
* Removed Images trust_file_extensions config. [#2500](https://github.com/refinery/refinerycms/pull/2500). [Josef Šimánek](https://github.com/simi)
* Migrated to Dragonfly ~> 1.0.0. [#2500](https://github.com/refinery/refinerycms/pull/2500). [Josef Šimánek](https://github.com/simi)
* Removed Pages#cache_pages_backend. [#2375](https://github.com/refinery/refinerycms/pull/2375). [Philip Arndt](https://github.com/parndt)
* Updated how `_make_sortable` works to take an options hash, requiring manual file changes. [Philip Arndt](https://github.com/parndt)
* Removed `attr_accessible` in favour of strong parameters. [Philip Arndt](https://github.com/parndt) [#2518](https://github.com/refinery/refinerycms/pull/2518)
* Removed `attr_accessible` in favour of strong parameters. [#2518](https://github.com/refinery/refinerycms/pull/2518). [Philip Arndt](https://github.com/parndt)
* Removed the Dashboard extension, now the left most tab is selected when logging in. [2634](https://github.com/refinery/refinerycms/pull/2634). [Philip Arndt](https://github.com/parndt)

* [See full list](https://github.com/refinery/refinerycms/compare/2-1-stable...master)

## 2.1.3 [5 September 2014]

* Fixed an issue where the seeds in a generated form extension weren't idempotent. [#2674](https://github.com/refinery/refinerycms/pull/2674). [Philip Arndt](https://github.com/parndt)

* [See full list](https://github.com/refinery/refinerycms/compare/2.1.2...2.1.3)

## 2.1.2 [14 March 2014]

* Fixed bug where `load_valid_templates` wasn't called for create action and caused an exception when creating a new page and saving it with a blank title. [#2517](https://github.com/refinery/refinerycms/pull/2517). [Uģis Ozols](https://github.com/ugisozols)
* Fixed bug where adding a link for a translated page via wymeditor it wasn't localised. Also updated the regex for `switch_locale` to match hyphenated language code, e.g. zh-CN or pt-BR. [#2533](https://github.com/refinery/refinerycms/pull/2533). [Daniel Brooker](https://github.com/DanBrooker)
* [See full list](https://github.com/refinery/refinerycms/compare/2.1.1...2.1.2)

## 2.1.1 [26 November 2013]

* Fixed menu reordering bug when `Refinery::Core.backend_route` was set to something different than `refinery`. [#2368](https://github.com/refinery/refinerycms/pull/2368). [xyz](https://github.com/xyz)
* Fixed bug in serializelist.js where we were iterating through object fields instead of the array elements. [#2360](https://github.com/refinery/refinerycms/pull/2360). [Uģis Ozols](https://github.com/ugisozols)
* Bumped `selenium-webdriver` gem dependency version to `~> 2.34.0`.
* Fixed bug which occurred when trying to save a child page with no default translation. [#2379](https://github.com/refinery/refinerycms/pull/2379). [Jess Brown](https://github.com/jess) & [Uģis Ozols](https://github.com/ugisozols)
* Upgraded Globalize dependency to `~> 3.0.1`. [#2462](https://github.com/refinery/refinerycms/pull/2462). [Chris Salzberg](https://github.com/shioyama)
* [See full list](https://github.com/refinery/refinerycms/compare/2.1.0...2.1.1)

## 2.1.0 [5 August 2013]

* Require at least Ruby 1.9.3 and thus drop Ruby 1.8.x support. [#2277](https://github.com/refinery/refinerycms/pull/2277) [Uģis Ozols](https://github.com/ugisozols) & [Philip Arndt](https://github.com/parndt)
* Removed `:before_javascript_libraries`, `:after_javascript_libraries`, and `:javascript_libraries` content blocks. [#1842](https://github.com/refinery/refinerycms/pull/1842). [Rob Yurkowski](https://github.com/robyurkowski)
* Refactored WYSIWYG fields into a partial. [#1796](https://github.com/refinery/refinerycms/pull/1796). [Rob Yurkowski](https://github.com/robyurkowski)
* Shortened all authentication helpers. [#1719](https://github.com/refinery/refinerycms/pull/1719). [Ryan Bigg](https://github.com/radar)
* Added canonical page id to body to allow CSS selectors to target specific pages instead of including special CSS files. [#1700](https://github.com/refinery/refinerycms/pull/1700) & [#1828](https://github.com/refinery/refinerycms/pull/1828). [Philip Arndt](https://github.com/parndt) & [Graham Wagener](https://github.com/gwagener/)
* Improved search functionality by adding cancel search link next to search input, made results_for entry nicer by adding some html to it. [#1922](https://github.com/refinery/refinerycms/pull/1922/). [Marek](https://github.com/keram)
* Added search functionality to users extension. [#1922](https://github.com/refinery/refinerycms/pull/1934/). [Marek](https://github.com/keram)
* Extracted locale picker code into separate partial. [#1936](https://github.com/refinery/refinerycms/pull/1936). [Marek](https://github.com/keram)
* Removed upgrade messages for IE. [#1940](https://github.com/refinery/refinerycms/pull/1940). [Philip Arndt](https://github.com/parndt)
* Added template whitelist for page tabs. [#1943](https://github.com/refinery/refinerycms/pull/1943). [Johan](https://github.com/jokklan)
* Removed DD_belatedPNG since we dropped IE6 support a while ago. (https://github.com/refinery/refinerycms/commit/45367ebeb2fa026a2932d0514db50c8982d2c309)
* Dropped coffee-rails dependency. [#1975](https://github.com/refinery/refinerycms/issues/1975). [Uģis Ozols](https://github.com/ugisozols)
* Added Portuguese translations. [#2007](https://github.com/refinery/refinerycms/pull/2007). [David Silva](https://github.com/davidslvto)
* Added Hungarian translations. [#2010](https://github.com/refinery/refinerycms/pull/2010). [minktom](https://github.com/minktom)
* Extracted search header logic into partial. [#1974](https://github.com/refinery/refinerycms/pull/1974). [Uģis Ozols](https://github.com/ugisozols)
* Images can only be updated when the image being uploaded has the same filename as the original image. [#1866](https://github.com/refinery/refinerycms/pull/1866). [Philip Arndt](https://github.com/parndt) & [Uģis Ozols](https://github.com/ugisozols)
* Rack::Cache should be a soft dependency per rails/rails#7838. Fixes Dragonfly caching when Rack::Cache is present. [#1736](https://github.com/refinery/refinerycms/issues/1736). [Alexander Wenzowski](https://github.com/wenzowski)
* Made `refinerycms-i18n` hard dependency for `refinerycms-core`. This allowed to remove all `Refinery.i18n_enabled?` checks. [#2025](https://github.com/refinery/refinerycms/pull/2025). [Uģis Ozols](https://github.com/ugisozols)
* Fixed issue with `view_template_whitelist` config option when array of symbols was used. [#2030](https://github.com/refinery/refinerycms/pull/2030). [A.S. Lomoff](https://github.com/allomov)
* Removed `source` from block_tags and made it so `wymeditor_whiltelist_tags` don't get added to block_tags. [#2029](https://github.com/refinery/refinerycms/pull/2029). [Sergio Cambra](https://github.com/scambra)
* Removed Array inheritance from `Refinery::Plugins` and included Enumerable module instead. [#2035](https://github.com/refinery/refinerycms/pull/2035). [Uģis Ozols](https://github.com/ugisozols)
* Refactored `Refinery::Page#url` and friends. [#2031](https://github.com/refinery/refinerycms/pull/2031). [Uģis Ozols](https://github.com/ugisozols)
* Removed `store_current_location!` because it was polluting all controllers with Refinery specific instance variable `@page`. [#2032](https://github.com/refinery/refinerycms/issues/2032). [Philip Arndt](https://github.com/parndt) & [Amrit Ayalur](https://github.com/aayalur)
* Removed `meta_keywords` since seo_meta removed keyword support in version 1.4.0. [#2052](https://github.com/refinery/refinerycms/pull/2052), [#2053](https://github.com/refinery/refinerycms/pull/2053). [Jean-Philippe Doyle](https://github.com/j15e) & [Uģis Ozols](https://github.com/ugisozols)
* Changed WYMeditor.REL from `rel` to `data-rel`. [#2019](https://github.com/refinery/refinerycms/pull/2019). [Amrit Ayalur](https://github.com/aayalur)
* Added config option to hide page title in page body. [#2067](https://github.com/refinery/refinerycms/pull/2067). [Andrew Hooker](https://github.com/GeekOnCoffee)
* Added `Refinery::Core.backend_route` config which allows to set backend route to something different than `/refinery`. [#2050](https://github.com/refinery/refinerycms/pull/2050). [Josef Šimánek](https://github.com/simi)
* Fixed issue with page part reordering for new pages. [#2063](https://github.com/refinery/refinerycms/pull/2063). [Uģis Ozols](https://github.com/ugisozols)
* Fixed bug in regex which was wrapping `config.action_mailer` settings in if clause. [#2055](https://github.com/refinery/refinerycms/pull/2055). [Uģis Ozols](https://github.com/ugisozols) & [Philip Arndt](https://github.com/parndt)
* Renamed `force_ssl?` to `force_ssl!` and `refinery_user_required?` to `require_refinery_users!` and moved these methods to `Admin::BaseController`. [#2076](https://github.com/refinery/refinerycms/pull/2076). [Philip Arndt](https://github.com/parndt)
* Fixed issue with page tree not updating after page position update. [#1985](https://github.com/refinery/refinerycms/issues/1985). [Philip Arndt](https://github.com/parndt)
* Replaced menu partials with `MenuPresenter`. [#2068](https://github.com/refinery/refinerycms/pull/2068), [#2069](https://github.com/refinery/refinerycms/pull/2069). [Philip Arndt](https://github.com/parndt)
* Set `Refinery::Core.authenticity_token_on_frontend` to `false` by default. [Philip Arndt](https://github.com/parndt)
* Refactored many internals of pages to centralize page cache expiration. [#2083](https://github.com/refinery/refinerycms/pull/2083). [Philip Arndt](https://github.com/parndt)
* Fixed page saving bug when default locale was set to something different than `en` or when it was changed after creating some pages. [#2088](https://github.com/refinery/refinerycms/pull/2088). [Philip Arndt](https://github.com/parndt)
* Moved page preview functionality to its own controller and made it so that you need to be logged in to use it. [#2089](https://github.com/refinery/refinerycms/pull/2089). [Philip Arndt](https://github.com/parndt)
* Fixed issue which allowed identical slugs to exist after page reordering. [#2092](https://github.com/refinery/refinerycms/pull/2092). [Philip Arndt](https://github.com/parndt)
* Gave crudify's actions the ability to redirect to a particular page of results when `params[:page]` is supplied to the action. [#1861](https://github.com/refinery/refinerycms/issues/1861). [Philip Arndt](https://github.com/parndt)
* ActsAsIndexed is no longer a required dependency. Integration is achieved by [refinerycms-acts-as-indexed](https://github.com/refinery/refinerycms-acts-as-indexed) instead. [#2162](https://github.com/refinery/refinerycms/issues/2162). [Philip Arndt](https://github.com/parndt)
* Added Turkish translation [88f37f2a70c](https://github.com/refinery/refinerycms/commit/88f37f2a70c7504a193987ddd309ae15720f4456) and [c42a909eafa](https://github.com/refinery/refinerycms/commit/c42a909eafac721da5e07b3c796e7a07229231d9). [Aslan Gultekin](https://github.com/whowantstolivefo)
* Allow user-defined geometries in `image#thumbnail_dimensions`. [#2214](https://github.com/refinery/refinerycms/pull/2214). [Javier Saldana](https://github.com/jassa)
* Added Ukrainian translation. [#2259](https://github.com/refinery/refinerycms/pull/2259). [Tima Maslyuchenko](https://github.com/timsly)
* Fixed custom page view template preview. [#2219](https://github.com/refinery/refinerycms/pull/2219). [Jean-Philippe Doyle](https://github.com/j15e)
* Fixed duplicate page part title validation. [#2282](https://github.com/refinery/refinerycms/pull/2282). [David Jones](https://github.com/djones)
* Fixed nil page bug when `marketable_urls` where set to false and only `path` was passed to `find_by_path_or_id`. [#2278](https://github.com/refinery/refinerycms/pull/2278). [René Cienfuegos](https://github.com/renechz) & [Uģis Ozols](https://github.com/ugisozols)
* Fixed bug where user plugin order was reset each time user was updated. [#2281](https://github.com/refinery/refinerycms/pull/2281). [Uģis Ozols](https://github.com/ugisozols)
* Replaced Image#thumbnail geometry parameter with an options hash to support a strip option for reducing thumbnail file size. [#2261](https://github.com/refinery/refinerycms/pull/2261). [Graham Wagener](https://github.com/gwagener/)
* Added ability to turn off page slug scoping. [#2286](https://github.com/refinery/refinerycms/pull/2286). [Matt Olson](https://github.com/mattolson)
* Made Crudify's `xhr_paging` option working again. [#2296](https://github.com/refinery/refinerycms/pull/2296). [Chris Irish](https://github.com/supairish)
* Added draft page support when displaying the home page. [#2298](https://github.com/refinery/refinerycms/pull/2298). [Philip Arndt](https://github.com/parndt)
* Removed `Refinery::WINDOWS` constant. [Philip Arndt](https://github.com/parndt)
* Removed `jquery.corner` library and invocations. [#2328](https://github.com/refinery/refinerycms/pull/2328). [Philip Arndt](https://github.com/parndt)
* Removed `Refinery::Pages.view_template_whitelist` and `Refinery::Pages.use_view_templates` configuration options and enabled setting per page view template to be active by default. [#2331](https://github.com/refinery/refinerycms/pull/2331). [Uģis Ozols](https://github.com/ugisozols)
* Fixed markup corruption in WYMeditor when using `span` with `style` attribute. [#2350](https://github.com/refinery/refinerycms/pull/2350). [wuboy](https://github.com/wuboy0307)
* Require jquery-rails ~> 2.3.0. [Francois Harbec](https://github.com/rounders) and [Sergio Cambra](https://github.com/scambra)
* Unlocked `truncate_html` from 0.5.x as we no longer support Ruby 1.8.x. [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/2-0-stable...2-1-stable)

## 2.0.11 [unreleased]

* Fixed issue where a superfluous `</div>` would be inserted when using `rails g refinery:engine` for WYSIWYG fields. [#2236](https://github.com/refinery/refinerycms/issues/2236) [Philip Arndt](https://github.com/parndt) and [Rob Yurkowski](https://github.com/robyurkowski)
* [See full list](https://github.com/refinery/refinerycms/compare/2.0.10...2-0-stable)

## 2.0.10 [15 March 2013]
* Blocked past insecure Rails versions. [Philip Arndt](https://github.com/parndt)
* Fixed problems with editing pages in different locales. [Philip Arndt](https://github.com/parndt)
* Locked `truncate_html` to 0.5.x to ensure Ruby 1.8.x compatibility. [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/2.0.9...2.0.10)

## 2.0.9 [21 November 2012]
* Allowed extra parameters to be passed when creating image. [#1914](https://github.com/refinery/refinerycms/pull/1914). [tbuyle](https://github.com/tbuyle)
* Added usage instructions to refinerycms executable. [#1931](https://github.com/refinery/refinerycms/pull/1931). [Uģis Ozols](https://github.com/ugisozols) & [Philip Arndt](https://github.com/parndt).
* Disabled page caching when logged in to prevent caching the sitebar. [#1609](https://github.com/refinery/refinerycms/pull/1609). [Johan Frolich](https://github.com/jokklan)
* Fixed problems with `refinery:engine` generator and namespacing. [#1888](https://github.com/refinery/refinerycms/pull/1888). [David J. Brenes](https://github.com/brenes)
* Fixed extension/form generator issue when using --pretend option. [#1916](https://github.com/refinery/refinerycms/issues/1916). [Uģis Ozols](https://github.com/ugisozols)
* Fixed new resource insertion in custom extensions which use resource picker. [#1948](https://github.com/refinery/refinerycms/pull/1948). [Marek](https://github.com/keram)
* Fixed _save and continue_ and _preview_ functionality in pages extension when title was changed. [#1944](https://github.com/refinery/refinerycms/pull/1944). [tsemana](https://github.com/tsemana)
* Fixed html stripping bug when editing pages. [#1891](https://github.com/refinery/refinerycms/issues/1891). [Uģis Ozols](https://github.com/ugisozols)
* Fixed pagination in existing image/resource partial after uploading new image/resource. [#1970](https://github.com/refinery/refinerycms/issues/1970). [Uģis Ozols](https://github.com/ugisozols)
* Added check to extension generator which checks if extension specified by --extension option actually exist. [#1967](https://github.com/refinery/refinerycms/issues/1967). [Uģis Ozols](https://github.com/ugisozols)
* Removed everything that was related to `Refinery::Page#invalidate_cached_urls` because it was redundant and there already is a code that takes care of deleting cache. [#1998](https://github.com/refinery/refinerycms/pull/1998). [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/2.0.8...2.0.9)

## 2.0.8 [17 August 2012]
* Fixes installs broken by the release of jquery-rails 2.1.0 by requiring ~> 2.0.0. [Rob Yurkowski](https://github.com/robyurkowski)
* [See full list](https://github.com/refinery/refinerycms/compare/2.0.7...2.0.8)

## 2.0.7 [16 August 2012]
* Fixed a bug with nested reordering that would shuffle any set with 11 or more entities. [#1882](https://github.com/refinery/refinerycms/pull/1882). [Rob Yurkowski](https://github.com/robyurkowski)

## 2.0.6 [6 August 2012]
* Added Refinery::Page#canonical_slug to allow us to retrieve a consistent slug across multiple translations of a page. Useful for CSS selectors. [#1457](https://github.com/refinery/refinerycms/pull/1457). [Philip Arndt](https://github.com/parndt)
* Fixed bug with 404 page not honoring custom view/layout template. [#1746](https://github.com/refinery/refinerycms/pull/1746). [Uģis Ozols](https://github.com/ugisozols)
* Renamed all templates in generators which contained erb to *.rb.erb. [#1750](https://github.com/refinery/refinerycms/pull/1750). [Uģis Ozols](https://github.com/ugisozols)
* Fixed page reorder issue on Ruby 1.8.x. [#1585](https://github.com/refinery/refinerycms/issues/1585). [Uģis Ozols](https://github.com/ugisozols) & [Philip Arndt](https://github.com/parndt).
* Allowed to override presenters using `rake refinery:override`. [#1790](https://github.com/refinery/refinerycms/pull/1790). [Kevin Bullock](https://github.com/krbullock).
* Fixed issue with saving settings in generated form extension by completely rewriting settings controller. [#1817](https://github.com/refinery/refinerycms/issues/1817). [Uģis Ozols](https://github.com/ugisozols)
* Removed Refinery::Page#title_with_meta in favour of view helpers. [#1847](https://github.com/refinery/refinerycms/pull/1847). [Philip Arndt](https://github.com/parndt)

## 2.0.5 [11 June 2012]
* Now extension/form generators will add all attributes to attr_accessible. [#1613](https://github.com/refinery/refinerycms/pull/1613). [Uģis Ozols](https://github.com/ugisozols)
* Fixed a bug where `refinerycms-images` was trying to load `refinerycms-resources`. [#1651](https://github.com/refinery/refinerycms/issues/1651). [Philip Arndt](https://github.com/parndt)
* Use new page part names (:body, :side_body) when generating extensions. [Uģis Ozols](https://github.com/ugisozols)
* Now extension generator will merge two seeds file in case user generates multiple resources for one extension. [#1532](https://github.com/refinery/refinerycms/issues/1532). [Uģis Ozols](https://github.com/ugisozols)
* Fix refinery:override bug where it won't match js files with more than one extension. [#1685](https://github.com/refinery/refinerycms/issues/1685). [Uģis Ozols](https://github.com/ugisozols) and [Philip Arndt](https://github.com/parndt)
* Now `refinerycms-images` and `refinerycms-resources` will inherit the s3_region configuration from `refinerycms-core`. [#1687](https://github.com/refinery/refinerycms/pull/1687). [Julien Palmas](https://github.com/bartocc)
* Fixed dashboard bug where it wasn't producing proper links for nested pages. [#1696](https://github.com/refinery/refinerycms/pull/1696). [Philip Arndt](https://github.com/parndt)
* Match only &dialog, ?dialog, &width, ?width, &height and ?height in dialog querystrings. [#1397](https://github.com/refinery/refinerycms/issues/1397). [Philip Arndt](https://github.com/parndt)
* Added multiple language support (specified by `Refinery::I18n.frontend_locales`) in `Refinery::Page` seeds file. [#1694](https://github.com/refinery/refinerycms/pull/1694). [Ole Reifschneider](https://github.com/Tranquility)
* Added `Refinery::Page#canonical` support which allows multiple translations to have one canonical version. [Philip Arndt](https://github.com/parndt)
* Usernames are validated case insensitively to ensure true uniqueness. [#1703](https://github.com/refinery/refinerycms/issues/1703). [Philip Arndt](https://github.com/parndt)
* Fixed bug with template selector for page where it would always default to parents template. [#1710](https://github.com/refinery/refinerycms/issues/1710). [Glenn Hoppe](https://github.com/ghoppe)
* Fixed and added tests for post-authentication redirect bug where a user would always be redirected to the admin root after successful auth. [#1561](https://github.com/refinery/refinerycms/issues/1561). [Alexander Wenzowski](https://github.com/wenzowski)
* Added session key check for unscoped `return_to` variable so that the key set by `Refinery::Admin::BaseController#store_location?` is respected after successful auth. [#1728](https://github.com/refinery/refinerycms/issues/1728). [Alexander Wenzowski](https://github.com/wenzowski)
* Fixed bug where flag icons in page listing couldn't be clicked due to expand/collapse event preventing it. [#1741](https://github.com/refinery/refinerycms/pull/1741). [Uģis Ozols](https://github.com/ugisozols)

## 2.0.4 [14 May 2012]
* IMPORTANT: Fixed a security issue whereby the user could bypass some access restrictions in the backend. [#1636](https://github.com/refinery/refinerycms/pull/1636). [Rob Yurkowski](https://github.com/robyurkowski) and [Uģis Ozols](https://github.com/ugisozols)
* Fixed stack level too deep error in Refinery::Menu#inspect. [#1551](https://github.com/refinery/refinerycms/pull/1551). [Uģis Ozols](https://github.com/ugisozols)
* Fixed spec fails for newly generated engines and bumped gem versions in generated Gemfile. [#1553](https://github.com/refinery/refinerycms/issues/1553). [Uģis Ozols](https://github.com/ugisozols)
* Fixed dialog opening issue when Refinery was mounted at different path than /. [#1555](https://github.com/refinery/refinerycms/issues/1555). [Uģis Ozols](https://github.com/ugisozols)
* Added ability to specify site name in I18n locales too. [#1576](https://github.com/refinery/refinerycms/pull/1576). [Philip Arndt](https://github.com/parndt)
* If parent page has custom view/layout template specified set this template as selected when editing sub page. [#1581](https://github.com/refinery/refinerycms/pull/1581). [xyz](https://github.com/xyz)
* Fixed page ambiguity for different pages with the same slug in find_by_path. [#1586](https://github.com/refinery/refinerycms/pull/1586). [Nicholas Schultz-Møller](https://github.com/nicholassm)
* Added Refinery::Core.force_ssl config option. [#1540](https://github.com/refinery/refinerycms/pull/1540). [Philip Arndt](https://github.com/parndt)
* Fixed bugs with page sweeper. [#1615](https://github.com/refinery/refinerycms/pull/1615). [f3ng3r](https://github.com/f3ng3r)
* Fixed image toggler show/hide bug. [#1587](https://github.com/refinery/refinerycms/issues/1587). [Gabriel Paladino](https://github.com/gabpaladino) & [Uģis Ozols](https://github.com/ugisozols)
* Fixed site bar caching bug when `cache_pages_full` is enabled and user is logged in. [#1609](https://github.com/refinery/refinerycms/pull/1609). [TheMaster](https://github.com/TheMaster)
* Made sure plugin params are set before checking exclusion, and removed unused variable. [#1602](https://github.com/refinery/refinerycms/pull/1602). [Rob Yurkowski](https://github.com/robyurkowski)
* Fixed link addition bug in the backend when switching locale. [#1583](https://github.com/refinery/refinerycms/pull/1583). [Vít Krchov](https://github.com/vita)
* Fixed bug with invalidating cached urls for all frontend locales. [#1479](https://github.com/refinery/refinerycms/pull/1479), [#1534](https://github.com/refinery/refinerycms/pull/1534). [Vít Krchov](https://github.com/vita), [Rob Yurkowski](https://github.com/robyurkowski) & [Uģis Ozols](https://github.com/ugisozols)
* Fixed image picker bug in Firefox 11 where content of the page was blank until you move the popup. [#1637](https://github.com/refinery/refinerycms/pull/1637). [Nelly Natalí](https://github.com/nnatali)
* Modified `Refinery.route_for_model` to fix a bug with the refinerycms-search plugin. [#1661](https://github.com/refinery/refinerycms/pull/1661). [Philip Arndt](https://github.com/parndt)
* Fixed engine generator for when you don't have a title field. [#1619](https://github.com/refinery/refinerycms/pull/1619). [Jean-Philippe Boily](https://github.com/jipiboily)
* Fixed `content_fu`. [#1628](https://github.com/refinery/refinerycms/issues/1628) [Philip Arndt](https://github.com/parndt)
* Added Russian translations for the preview button. [Vasiliy Ermolovich](https://github.com/nashby)
* Manually loaded translations associations to avoid N+1 queries in the pages backend. [#1633](https://github.com/refinery/refinerycms/pull/1633). [thedarkone](https://github.com/thedarkone)

## 2.0.3 [2 April 2012]
* Fixed missing authentication initializer. [Uģis Ozols](https://github.com/ugisozols)
* Fixed Heroku and sqlite3 related errors. [Philip Arndt](https://github.com/parndt)
* Replaced label_tag with label in pages advanced options form. [Johannes Edelstam](https://github.com/jede)
* Added missing `refinerycms-settings` require in generated refinery form extension. [Philip Arndt](https://github.com/parndt)
* Added JS runtime check in templates. [Philip Arndt](https://github.com/parndt) & [Josef Šimánek](https://github.com/simi)
* Fixed user role assignment issue. [Uģis Ozols](https://github.com/ugisozols)
* Added image type whitelisting configuration option. [Rob Yurkowski](https://github.com/robyurkowski)
* Removed global hash of menu instances. [Pete Higgins](https://github.com/phiggins)
* Fixed save & continue issue. [Philip Arndt](https://github.com/parndt)
* Fixed issue with Heroku option for CMS generator. [Philip Arndt](https://github.com/parndt)
* Fixed asset compilation in production mode. [Philip Arndt](https://github.com/parndt)
* Add label style for admin Page tree [Nic Aitch](https://github.com/nicinabox)
* Fixed page part hiding [Rob Yurkowski](https://github.com/robyurkowski)
* Fixed missing page part CSS classes (i.e. `no_side_body`) [Rob Yurkowski](https://github.com/robyurkowski)
* Deprecated `body_content_left` and `body_content_right` [Rob Yurkowski](https://github.com/robyurkowski)
* Reorganizes documentation [Rob Yurkowski](https://github.com/robyurkowski)

## 2.0.2 [15 March 2012]

* Removed dependencies from refinerycms-testing that were just opinions and not necessary. [Pete Higgins](https://github.com/phiggins)
* Fixed missing `Refinery::PagePart` positions in seeds. [Mark Stuart](https://github.com/markstuart)
* Fixed issue with Rakefile template that gets generated into extensions. [Uģis Ozols](https://github.com/ugisozols)
* Fixed issue where new page parts could not be added to a page. [Uģis Ozols](https://github.com/ugisozols)
* Added missing initializer for the Authentication extension. [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/2.0.1...2.0.2)

## 2.0.1 [6 March 2012]

* Updated `plugin.url` code to support Rails 3.2.2. [Philip Arndt](https://github.com/parndt)
* Added guard-spork '0.5.2' dependency to refinerycms-testing. [Joe Sak](https://github.com/joemsak)
* Added support for '.' in usernames. [Philip Arndt](https://github.com/parndt)
* Now includes application.js by default. [Nick Romanowski](https://github.com/nodabs)
* [See full list](https://github.com/refinery/refinerycms/compare/2.0.0...2.0.1)

## 2.0.0 [29 February 2012]

* Remove jquery_include_tags helper in favor of using jquery from jquery-rails gem. [Uģis Ozols](https://github.com/ugisozols)
* Finally removed `Page#[]` in favour of `Page#content_for` so instead of `@page[:body]` it's `@page.content_for(:body)`. [Philip Arndt](https://github.com/parndt)
* Moved everything under Refinery namespace. [wakeless](https://github.com/wakeless)
* Renamed `RefinerySetting` to `Refinery::Setting`. [Philip Arndt](https://github.com/parndt)
* Added `rails g refinery:form` generator for form textensions. [Philip Arndt](https://github.com/parndt)
* Moved `/shared/*` to `/refinery/*` instead, including `/shared/admin/*` to `/refinery/admin/*` as it makes more sense. [Philip Arndt](https://github.com/parndt)
* `vendor/engines` is now `vendor/extensions`. [Philip Arndt](https://github.com/parndt)
* Extensions are now generated with testing support built in via a dummy refinery installation. [Jamie Winsor](https://github.com/reset)
* Refinery is now mountable at a custom path. [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/1.0.9...master) if you dare.
* [See explanation of changes](https://github.com/refinery/refinerycms/wiki/Changelog).

## 1.0.9 [5 November 2011]

* `guard` testing strategy ported from edge for testing refinery from its own directory without a dummy app. [Jamie Winsor](https://github.com/resetexistence) & [Joe Sak](https://github.com/joemsak)
* WYMEditor bug fixes [Nic Haynes](https://github.com/nicinabox)
* Bulgarian translations added. [Miroslav Rachev](https://github.com/mirosr)
* Fixed --heroku command. [Garrett Heinlen](https://github.com/gogogarrett)
* Refactored plugins code to add Ruby 1.9.3 support. [Amanda Wagener](https://github.com/awagener)
* [See full list](https://github.com/refinery/refinerycms/compare/1.0.8...1.0.9)

## 1.0.8 [1 September 2011]

* `refinerycms-core` now depends on rails so that users of 1.0.x can be confident of the entire stack being present as before. [Philip Arndt](https://github.com/parndt)
* No longer requiring autotest as a dependency of `refinerycms-testing`. [Philip Arndt](https://github.com/parndt)
* Improved 'wrong rails version' error message on install with a more helpful guide on how to specify a rails version. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/1.0.7...1.0.8)

## 1.0.7 [31 August 2011]

* No change, just fixing corruption in the 1.0.6 gem caused by Syck. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/1.0.6...1.0.7)

## 1.0.6 [31 August 2011]

* Added support for Devise `~> 1.4.3`. [Philip Arndt](https://github.com/parndt)
* Removed dependency on Rails but added dependencies to its components, like activerecord, where they are used. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/1.0.5...1.0.6)

## 1.0.5 [31 August 2011]

* jQuery UI updated to `1.8.15` from `1.8.9`. [Uģis Ozols](https://github.com/ugisozols)
* Removed Duostack hosting option from the installer because the platform isn't online anymore. [Philip Arndt](https://github.com/parndt)
* Fixed non raw output into noscript section of the backend. [Philip Arndt](https://github.com/parndt)
* `will_paginate` updated to `~> 3.0.0` now that it has gone final. [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/1.0.4...1.0.5)

## 1.0.4 [11 August 2011]

* Added support for figuring out dimensions in resized images to `image_fu`. [Philip Arndt](https://github.com/parndt) and [Joe Sak](https://github.com/joemsak)
* Fixed issues installing Refinery due to lack of permissions to the gem directories. [Philip Arndt](https://github.com/parndt)
* Added ability to specify a different database host in the `bin/refinerycms` installer. [Philip Arndt](https://github.com/parndt)
* Lock `will_paginate` to `3.0.pre2` in core gemspec. [Kris Forbes](https://github.com/krisf) and [Uģis Ozols](https://github.com/ugisozols)
* Patch required_label helper so it would pick up I18n model attribute translations. [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/1.0.3...1.0.4)

## 1.0.3 [23 June 2011]

* Fixes corruption in the 1.0.2 gem. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/1.0.2...1.0.3)

## 1.0.2 [23 June 2011]

* Ensure that `refinerycms-testing` is not enabled by default when installing an application. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/1.0.1...1.0.2)

## 1.0.1 [21 June 2011]

* Added `-t` / `--testing` option to `bin/refinerycms` which adds `refinerycms-testing` support by default when installing. [Philip Arndt](https://github.com/parndt)
* Set rails dependency to `~> 3.0.9`. [Philip Arndt](https://github.com/parndt)
* Re-enabled the magic `s3_backend` setting controlled by `ENV` variables. [Philip Arndt](https://github.com/parndt)
* `bin/refinerycms` installer now generates rails using `bundle exec` so that you can have multiple Rails versions installed and they won't clash. [Philip Arndt](https://github.com/parndt)
* Fixed problems with `rcov` and `simplecov` in Ruby 1.9.2. [Joe Sak](https://github.com/joemsak)
* Make the catch-all pages route for marketable URLs be controlled by the configuration switch. [Kyle Wilkinson](https://github.com/wikyd)
* [See full list](https://github.com/refinery/refinerycms/compare/1.0.0...1.0.1)

## 1.0.0 [28 May 2011]

* New `::Refinery::Menu` API implemented which speeds up menu generation by many times. [Philip Arndt](https://github.com/parndt)
* Removed caching from menu because it's so much faster now. Probably in future it will be added to `::Refinery::Menu` itself in a transparent manner. [Philip Arndt](https://github.com/parndt)
* Deprecated `Page#[]` in favour of `Page#content_for` e.g. instead of `@page[:body]` use `@page.content_for(:body)`. [Philip Arndt](https://github.com/parndt)
* Noisily deprecated many other features that still function in 1.0.0 but won't be present in 1.1.0. [Philip Arndt](https://github.com/parndt)
* A hidden page can no longer mark the ancestor pages as selected in the menu. [Philip Arndt](https://github.com/parndt)
* Rcov added to `refinerycms-testing` gem. [Rodrigo Dominguez](https://github.com/rorra)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.22...1.0.0)

## 0.9.9.22 [22 May 2011]

* Fixed issue introduced with `rake 0.9.0`. [Philip Arndt](https://github.com/parndt)
* Improved menu performance again including update to `awesome_nested_set 2.0`. [Philip Arndt](https://github.com/parndt) and [Mark Haylock](https://github.com/mhaylock)
* Supporting the new Google Analytics 'site speed' feature. [David Jones](https://github.com/djones)
* Implemented `:translator` role which allows a particular user access only to translate pages. [Philip Arndt](https://github.com/parndt)
* Added support for `Dragonfly 0.9.0` which uses the 'fog' gem. [Jesper Hvirring Henriksen](https://github.com/hvirring)
* Updated all `refinery/admin.js` functions to make use of 'initialised'. [Mark Haylock](https://github.com/mhaylock)
* Using SEO form from `seo_meta` inside pages' advanced options rather than having it duplicated in the Refinery CMS codebase too. [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.21...0.9.9.22)

## 0.9.9.21 [03 May 2011]

* Fixed issue with MySQL2 gem complaining about us being on Rails 3 by specifying `'~> 0.2.7'` in the Gemfile of a generated application. [Philip Arndt](https://github.com/parndt)
* `/registrations` is now `/users`. [Philip Arndt](https://github.com/parndt)
* Added Finnish translation. [Veeti Paananen](https://github.com/veeti)
* Allowed `data` and `data-` attributes in WYMeditor tags using HTML view. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.20...0.9.9.21)

## 0.9.9.20 [28 April 2011]

* Improved performance of the menu rendering. [Philip Arndt](https://github.com/parndt)
* Fixed UI to allow for how different languages display on the login screen. [Marian André](https://github.com/bitflut)
* Vastly improved specs & spec coverage. [Uģis Ozols](https://github.com/ugisozols)
* Upgraded to `jQuery 1.5.2` and `Dragonfly 0.8.4`. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.19...0.9.9.20)

## 0.9.9.19 [22 April 2011]

* Removed `rdoc` dependency. [Philip Arndt](https://github.com/parndt)
* Migrate to stable Rails 3.0.7. [Josef Šimánek](https://github.com/simi)
* Use `let()` in rspec specs. [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.18...0.9.9.19)

## 0.9.9.18 [16 April 2011]

* Fixed a backward incompatibility. [Josef Šimánek](https://github.com/simi)
* Reduced calls to `SHOW TABLES` by updating `friendly_id_globalize3`. [Philip Arndt](https://github.com/parndt)
* Switched `/shared/_menu.html.erb` and `/shared/_menu_branch.html.erb` away from `render :partial` with `:collection`, speeding up menu 12~15%. [Philip Arndt](https://github.com/parndt)
* Fixed Refinery.root, Fixed generator templates, Added refinerycms-i18n generator to refinerycms generator if i18n is included. [Mark Haylock](https://github.com/mhaylock)
* Bumped Rails dependency to `~> 3.0.7.rc2`. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.17...0.9.9.18)

## 0.9.9.17 [15 April 2011]

* Mass assignment protection implemented. [Andreas König](https://github.com/koa)
* Removed deprecated code to prepare for `1.0.0`. [Uģis Ozols](https://github.com/ugisozols)
* Added `Strip Non Ascii` preference to `has_friendly_id`. [Marc Argent](https://github.com/lurcio)
* Bumped Rails dependency to `~> 3.0.7.rc1`. [Philip Arndt](https://github.com/parndt)
* Better support for models in modules for uncrudify. [Josef Šimánek](https://github.com/simi)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.16...0.9.9.17)

## 0.9.9.16 [7 April 2011]

* Improved resource picker. [Will Marshall](https://github.com/willrjmarshall)
* Improved robustness of `Page#expire_page_caching` for both `ActiveSupport::Cache::FileStore` and `ActiveSupport::Cache::MemoryStore`. [Jeff Hall](https://github.com/zenchicken)
* Optimised index sizes on MySQL. [Ruslan Doroshenko](https://github.com/rdoroshenko)
* Changed default cache store to `:memory_store`. [Philip Arndt](https://github.com/parndt)
* `rake db:migrate` and `rake db:rollback` now works consistently when migrations from other engines are in the mix. [Vaughn Draughon](https://github.com/rocksolidwebdesign)
* Re-enable cache when logged in, this avoids slowdown of site when admin logged in. [Mark Haylock](https://github.com/mhaylock)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.15...0.9.9.16)

## 0.9.9.15 [1 April 2011]

* Fixed asset caching of files in `public/stylesheets/`. [Sergio Cambra](https://github.com/scambra)
* All dependencies now have an absolute version dependency (e.g. '= 0.9.9.15' rather than '~> 0.9.9.15') to prevent Refinery auto-updating. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.14...0.9.9.15)

## 0.9.9.14 [31 March 2011]

* Added `refinery.before_inclusion` for running extra functionality just before Refinery attaches to Rails. [Philip Arndt](https://github.com/parndt)
* Renamed `refinery.after_inclusion` to `refinery.after_inclusion` to match `refinery.before_inclusion`. [Philip Arndt](https://github.com/parndt)
* Moved meta tag responsibility to `seo_meta` library. [Philip Arndt](https://github.com/parndt)
* Added HTML5 tag support to WYMeditor. [Philip Arndt](https://github.com/parndt) and [Nick Hammond](https://github.com/nickhammond)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.13...0.9.9.14)

## 0.9.9.13 [28 March 2011]

* Forcing password reset when migrating from older versions of Devise (sigh). [Philip Arndt](https://github.com/parndt)
* Updated to `refinerycms-i18n 0.9.9.16` - please run `rails generate refinerycms_i18n`. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.12...0.9.9.13)

## 0.9.9.12 [27 March 2011]

* Removed `password_salt` field from users table and comment out `config.encryptor` in `config/initializers/devise.rb` to handle update to devise 1.2.0. [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.11...0.9.9.12)

## 0.9.9.11 [24 March 2011]

* Translated WYMeditor texts to Japanese. [Hiro Asari](https://github.com/BanzaiMan)
* Supporting `cucumber-rails 0.4.0`. [Philip Arndt](https://github.com/parndt)
* Added an option to link in the `page_title` enabling easier breadcrumbs. [Sergio Cambra](https://github.com/scambra)
* Fixed support for `asset_file_path` in upcoming Rails 3.1. [Philip Arndt](https://github.com/parndt)
* Updated copyright notice to include the current year. [David Jones](https://github.com/djones)
* Fixed site bar switch link. [Philip Arndt](https://github.com/parndt)
* Added support for translating Javascript strings. [Philip Arndt](https://github.com/parndt)
* Added `refinery.on_attach` for running extra functionality just after Refinery attaches to Rails. Functions similarly to `config.to_prepare`. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.10...0.9.9.11)

## 0.9.9.10 [17 March 2011]

* Excluded caching option for menus when logged in. [Philip Arndt](https://github.com/parndt)
* Fixed site bar translation logic. [Philip Arndt](https://github.com/parndt)
* Removed `config/settings.rb` file. [Philip Arndt](https://github.com/parndt)
* Added a default `features/support/paths.rb` file in the `Rails.root` for your paths. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.9...0.9.9.10)

## 0.9.9.9 [15 March 2011]

* Added Japanese translation. [Hiro Asari](https://github.com/BanzaiMan)
* Improved menu rendering performance. [Philip Arndt](https://github.com/parndt)
* Added caching to site menu and pages backend (DISABLED by default). [Philip Arndt](https://github.com/parndt)
* Added `Page#by_title` to filter pages results by title using `Page::Translation`. [Philip Arndt](https://github.com/parndt)
* Added migration to remove already translated fields from the pages table. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.8...0.9.9.9)

## 0.9.9.8 [11 March 2011]

* Fixed several user interface bugs reported by Patrick Morrow. [Philip Arndt](https://github.com/parndt)
* Looser dependency on `moretea-awesome_nested_set` (now `~> 1.4`). [Philip Arndt](https://github.com/parndt)
* Corrected `ajax-loader.gif` path. [Maurizio](https://github.com/ProGNOMmers)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.7...0.9.9.8)

## 0.9.9.7 [10 March 2011]

* Added `:per_page` option to `crudify` for overriding the number of items to display per page with will_paginate. [Josef Šimánek](https://github.com/simi)
* Deprecated `rake refinery:update` in favour of rails `generate refinerycms --update`. [Philip Arndt](https://github.com/parndt)
* Added `--skip-db` option to `bin/refinerycms` installer which doesn't automate any database creation/migration and skips the `rails generate refinerycms` generator. [Philip Arndt](https:/github.com/parndt)
* Exchanged (help) links for the information.png 'refinery icon'. This will happen automatically if you used `refinery_help_tag`. [Philip Arndt](https://github.com/parndt)
* Added `xhr_paging` as an option in crudify which handles the server-side usage of the HTML5 History API. [Philip Arndt](https://github.com/parndt)
* Looser Bundler dependency (now `~> 1.0`). [Terence Lee](https://github.com/hone)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.6...0.9.9.7)

## 0.9.9.6 [7 March 2011]

* Fixed an issue that caused the installer to fail on some systems. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.5...0.9.9.6)

## 0.9.9.5 [7 March 2011]

* Added `<div class='inner'>` to `_content_page` for better control over CSS for each section. Please see [086abfcae2c83330346e28d1e40004cff8a27720](https://github.com/refinery/refinerycms/commit/086abfcae2c83330346e28d1e40004cff8a27720) for what changed if this affects you. [Stefan Mielke](https://github.com/caplod)
* Menu performance improvements. [David Reese](https://github.com/whatcould)
* Removed `--update` from `bin/refinerycms` because it's no longer relevant. [Philip Arndt](https://github.com/parndt)
* Added support for --ident in the installation task which uses ident authentication at the database level by commenting out the username and password credentials. [Philip Arndt](https://github.com/parndt)
* Changed the default `cache_store` to `:file_store` for better thread safety with passenger. [Philip Arndt](https://github.com/parndt)
* WYMeditor Internet Explorer improvements. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.4...0.9.9.5)

## 0.9.9.4 [24 February 2011]

* Added `doc/guides` for textile based guides that power [the guides at refinerycms.com/guides](http://refinerycms.com/guides). [Steven Heidel](https://github.com/stevenheidel) and [Philip Arndt](https://github.com/parndt)
* Allowed multiple resource pickers on one form. [Phil Spitler](https://github.com/philspitler)
* Solved YAML parsing issues introduced by change to Psych. [Aaron Patterson](https://github.com/tenderlove) and [Uģis Ozols](https://github.com/ugisozols)
* Updated page to use a localized cache key if frontend translations are enabled. [Bryan Mahoney](https://github.com/DynamoMTL)
* Upgraded modernizr to version 1.7. [Jon Roberts](https://github.com/emptyflask)
* Fixed an issue with the 'add page parts' functionality inserting new parts in the wrong place. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.3...0.9.9.4)

## 0.9.9.3 [17 February 2011]

* Fixed faulty require statement that tried to load rack/cache before dragonfly. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.2...0.9.9.3)

## 0.9.9.2 [17 February 2011]

* Removed `activesupport` requirement from `bin/refinerycms`. [Philip Arndt](https://github.com/parndt)
* Fixed an issue in some browsers with a particular jQuery selector. [Philip Arndt](https://github.com/parndt)
* Modified some existing migrations to behave better when creating new applications. [Philip Arndt](https://github.com/parndt)
* Fixed `-u` and `-p` support for `bin/refinerycms`. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9.1...0.9.9.2)

## 0.9.9.1 [15 February 2011]

* Fixed Firefox issue with WYMeditor. [Amanda Wagener](https:/github.com/awagener)
* Gracefully exit `bin/refinerycms` on error. [Alexandre Girard](https://github.com/alx) and [Brian Stevens](https://github.com/bdstevens) and [Philip Arndt](https://github.com/parndt)
* Added basic single table inheritance support to crudify. [Ken Nordquist](https://github.com/kenphused)
* Removed most of the 0.9.8.9 specific `--update` logic in `bin/refinerycms`. [Philip Arndt](https://github.com/parndt)
* Added `refinerycms-testing` engine which reduces the main Gemfile complexity. [Philip Arndt](https://github.com/parndt)
* Split the project into 10 separately released gems that include their own dependencies. [Philip Arndt](https://github.com/parndt)
* New Vietnamese translation files added. [Alex Nguyen](https://github.com/tiendung) and Stefan N and Mario Nguyen
* Improved JRuby support as well as the way that commands run in any ruby implementation. [Hiro Asari](https://github.com/BanzaiMan)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.9...0.9.9.1)

## 0.9.9 [27 January 2011]

* Better, more semantic HTML5. [Joe Sak](https://github.com/joemsak)
* Added `role` selection for `admin/users#edit`. [Hez Ronningen](https://github.com/hez)
* Fixed WYMeditor bug regarding adding links, helped with persistent testing by [Marko Hriberšek](https://github.com/markoh). [Philip Arndt](https://github.com/parndt)
* Better `RSpec` coverage [Joe Sak](https://github.com/joemsak) and [Philip Arndt](https://github.com/parndt) and [Uģis Ozols](https://github.com/ugisozols) and [PeRo ICT Solutions](https://github.com/pero-ict)
* Superusers now get access to all backend tabs by default. [Philip Arndt](https://github.com/parndt)
* Introduced LOLcat translation (yes, seriously) as an easter egg. [Steven Heidel](https://github.com/stevenheidel)
* Fixed several missing translations. [Johan Bruning](https://github.com/GidoGeek)
* Solved several i18n inconsistencies. [Jonas Hartmann](https://github.com/ionas)
* Made `UserPlugin` dependent on `User` which solves a data redundancy proble.m [Maarten Hoogendoorn](https://github.com/moretea)
* Fixed issue with finding where engines are located on the disk using `Plugin::pathname`. [Lele](https://github.com/leleintercom)
* Add `rescue_not_found` option to turn on/off 404 rendering. [Ryan Bigg](https://github.com/radar)
* Full review of the French translations. [Jérémie Horhant](https://github.com/Titinux)
* Now using `mail()` to send emails. [J. Edward Dewyea](https://github.com/commuter)
* Refactored backend HTML & CSS, reduced complexity and added a loading animation when you click Save on forms. [Philip Arndt](https://github.com/parndt)
* Improved the speed of the menu especially related to scaling through reusing collections rather then revisiting the database. [Amanda Wagener](https://github.com/awagener)
* Implemented an API for the `pages` form's tabs. [David Jones](https://github.com/djones)
* Use the rails naming convention for translations that contain html markup. Escaping translations not marked as `html_safe` in the `refinery_help_tag` helper. [Jérémie Horhant](https://github.com/Titinux)
* Full review of the Italian translations. [Mirco Veltri](https://github.com/indaco)
* Deprecated `/admin` in favour of `/refinery` and put in a message to display to the user when they use it. [Philip Arndt](https://github.com/parndt)
* Full review of the Russian translations as well as work with articles / genders in grammar. [Semyon Perepelitsa](https://github.com/semaperepelitsa)
* Full review of routes and the Latvian translations. [Uģis Ozols](https://github.com/ugisozols)
* Implemented better support for `rails.js`, using standard `:method` and `:confirm` `link_to` options. [Semyon Perepelitsa](https://github.com/semaperepelitsa)
* Locked jQuery to 1.4.2 and jQuery UI to 1.8.5, fixed errors with dialogues and tested. [Philip Arndt](https://github.com/parndt) and [Phillip Miller](https://github.com/philmill) and [Sam Beam](https://github.com/sbeam)
* Added multiple file upload for images and resources using HTML5. [Philip Arndt](https://github.com/parndt)
* Deprecated `content_for :head` in favour of `content_for :meta`, `content_for :stylesheets` and `content_for :javascripts`. [Philip Arndt](https://github.com/parndt)
* Improved client-side responsiveness of backend and frontend. [Philip Arndt](https://github.com/parndt)
* No more RMagick dependency [Philip Arndt](https://github.com/parndt)
* Added `rake refinery:override stylesheet=somefile` and `rake refinery:override javascript=somefile` commands to override stylesheets and javascripts. [Oliver Ponder](https://github.com/oponder)
* Restructed the project to remove `vendor/refinerycms` and put all engines in the application root. [Kamil K. Lemański](https://github.com/kml)
* Force no resource caching on non-writable file systems (like Heroku). [Philip Arndt](https://github.com/parndt)
* Refinery can now attach itself to a Rails application simply by including the refinerycms gem in the `Gemfile`. [Philip Arndt](https://github.com/parndt)
* Added core support for `globalize3` so that pages can be translated into multiple languages. [Philip Arndt](https://github.com/parndt) and [Maarten Hoogendoorn](https://github.com/moretea)
* Refactored `group_by_date` into a helper method which is called in the view layer and not in the controller because it is entirely presentation. [Philip Arndt](https://github.com/parndt)
* Applied HTML5 history pagination to all core engines. [Philip Arndt](https://github.com/parndt)
* Converted translate calls to use `:scope`. [Uģis Ozols](https://github.com/ugisozols)
* Fixed issues where errors would only show up in English for some models and updated Russian translations. [Semyon Perepelitsa](https://github.com/semaperepelitsa)
* Converted to devise for authentication, requiring password resets. [Philip Arndt](https://github.com/parndt) and [Uģis Ozols](https://github.com/ugisozols)
* Sped up WYMeditor load times. [Philip Arndt](https://github.com/parndt)
* Fixed several issues for Internet Explorer. [Josef Šimánek](https://github.com/simi)
* Added installation option for [Duostack](http://duostack.com) hosting service. [Philip Arndt](https://github.com/parndt) and [David E. Chen](https://github.com/dchen)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.8.9...0.9.9)

## 0.9.8.9 [21 December 2010]

* Fixed error in the inquiries engine seeds. [Philip Arndt](https://github.com/parndt)
* Separate each error message into its own `<li>`. [Uģis Ozols](https://github.com/ugisozols)
* Add `rescue_not_found` option to turn on/off 404 rendering. [Ryan Bigg](https://github.com/radar)
* Add `:from` key to `UserMailer` for password reset. [Earle Clubb](https://github.com/eclubb)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.8.8...0.9.8.9)

## 0.9.8.8 [16 December 2010]

* Prevented ::Refinery::Setting from accessing its database table before it is created. [Philip Arndt](https://github.com/parndt)
* Added more options to `bin/refinerycms` like ability to specify database username and password. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.8.7...0.9.8.8)

## 0.9.8.7 [15 December 2010]

* Fixed a problem with migration number clashes. [Philip Arndt](https://github.com/parndt)
* Fixed problems with `db:migrate` for a new app on Postgres. [Jacob Buys](https://github.com/wjbuys)
* Back-ported the changes made to the images dialogue which speed it up significantly. [Philip Arndt](https://github.com/parndt)
* Sort file names in the `refinery_engine` generator so attribute types don't get changed before `_form.html.erb` generation. [Phil Spitler](https://github.com/philspitler)
* Added `approximate_ascii` setting, defaulted to true, for pages so that characters won't appear strangely in the address bar of some web browsers. [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.8.6...0.9.8.7)

## 0.9.8.6 [3 December 2010]

* Backported lots of functionality from 0.9.9 and later like:
* Fixed reordering for trees and non-trees [Philip Arndt](https://github.com/parndt)
* Better `RSpec` coverage [Joe Sak](https://github.com/joemsak) and [Philip Arndt](https://github.com/parndt) and [Uģis Ozols](https://github.com/ugisozols) and [PeRo ICT Solutions](https://github.com/pero-ict)
* Fixed issue with finding where engines are located on the disk using `Plugin::pathname`. [Lele](https://github.com/leleintercom)
* Improved the speed of the menu especially related to scaling through reusing collections rather then revisiting the database. [Amanda Wagener](https://github.com/awagener)
* No more RMagick dependency [Philip Arndt](https://github.com/parndt)
* Added helper methods to expose some of the options in crud. [David Jones](https://github.com/djones)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.8.5...0.9.8.6)

## 0.9.8.5 [21 September 2010](https://github.com/parndt)

* Fixed an issue with the engine generator that was putting a comma in the wrong place breaking the call to `crudify`. [Maarten Hoogendoorn](https://github.com/moretea)
* Made the delete messages consistent. [Uģis Ozols](https://github.com/ugisozols)
* `zh-CN` was overriding en locale in core locale file, fixed. [Philip Arndt](https://github.com/parndt)
* Changed verbiage from created to added, create to add as it describes it better for things like images. [Philip Arndt](https://github.com/parndt)
* `image_fu` no longer gives you the width and height of the image due to performance problems. [Philip Arndt](https://github.com/parndt) and [David Jones](https://github.com/djones)
* Implemented a standardised API for the engine generator. The core now includes a standard engine install generator. Engines generate a readme file explaining how to build an engine as a gem. [David Jones](https://github.com/djones)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.8.4...0.9.8.5)

## 0.9.8.4 [17 September 2010]

* Recursive deletion of page parts. [primerano](https://github.com/primerano)
* Move around the default pages. [Philip Arndt](https://github.com/parndt)
* Extraction of windows check to `Refinery::WINDOWS`. [Steven Heidel](https://github.com/stevenheidel)
* Updated the changelog for several previous releases. [Steven Heidel](https://github.com/stevenheidel)
* Made the menu more flexible so that it can be used in many places in your layout without caching over the top of itself. [Philip Arndt](https://github.com/parndt)
* Added search feature to Refinery Settings. [Matt McMahand](https://github.com/invalidusrname)
* Ensure that in `crudify` that we use `:per_page` properly for `will_paginate`. [Philip Arndt](https://github.com/parndt)
* Reduce the number of routes that we respond to in the `pages` engine as they were unused. [Philip Arndt](https://github.com/parndt)
* Fixed a case where page links weren't generating properly when inside an engine such as the news engine which made use of `params[:id]`. Took a lot of perserverance on the part of Hez - thank you very much Hez! [Hez Ronningen](https://github.com/hez) and [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.8.3...0.9.8.4)

## 0.9.8.3 [14 September 2010]
* German translation improvements. [Andre Lohan](https://github.com/dc5ala)
* Fix bug with `bin/refinerycms` and windows commands. [Philip Arndt](https://github.com/parndt)
* DRY up `crudify` and also switch to ARel. [Philip Arndt](https://github.com/parndt)
* Several fixes to make things much easier on windows. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.8.2...0.9.8.3)

## 0.9.8.2 [13 September 2010]
* Update `readme.md` [David Jones](https://github.com/djones)
* Speed improvements to menu with nested_set. [Maarten Hoogendoorn](https://github.com/moretea)
* More speed improvements by optimising slugs. [Philip Arndt](https://github.com/parndt)
* Fix `-h` flag on `bin/refinerycms` to display the help. [Steven Heidel](https://github.com/stevenheidel)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.8.1...0.9.8.2)

## 0.9.8.1 [9 September 2010]
* Convert to `awesome_nested_set`. [Maarten Hoogendoorn](https://github.com/moretea) and [Philip Arndt](https://github.com/parndt)
* Allow passing `-g` to the bin task for extra gems. [Tomás Senart](https://github.com/tsenart)
* Update documentation for engines, not plugins. [David Jones](https://github.com/djones)
* Several more documentation fixes. [Steven Heidel](https://github.com/stevenheidel)
* Better use of dragonfly resizing. [Philip Arndt](https://github.com/parndt)
* Partial Latvian translation. [Uģis Ozols](https://github.com/ugisozols)
* Review Portugese translation. [Kivanio Barbosa](https://github.com/kivanio)
* Bugfix with wymeditor in the engine generator. [Karmen Blake](https://github.com/kblake)
* Split `application_helper` into smaller, more usable files. [Philip Arndt](https://github.com/parndt)
* Move features and specs to each engine directory. [Philip Arndt](https://github.com/parndt)
* Bugfixes to ensure that reordering works under `awesome_nested_set`. [Maarten Hoogendoorn](https://github.com/moretea) and [Philip Arndt](https://github.com/parndt)
* Update engines to not have a special :require in the Gemfile. [Johan Bruning](https://github.com/GidoGeek)
* Make cache sweepers work. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.8...0.9.8.1)

## 0.9.8 [30 August 2010]

* Rails 3 support!
  - [Philip Arndt](https://github.com/parndt)
  - [Alex Coles](https://github.com/myabc)
  - [Steven Heidel](https://github.com/stevenheidel)
  - [David Jones](https://github.com/djones)
  - [Uģis Ozols](https://github.com/ugisozols)
  - [Maarten Hoogendoorn](https://github.com/moretea)
* [See our blog post](http://refinerycms.com/blog/refinery-cms-supports-rails-3)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.13...0.9.8)

## 0.9.7.13 [23 August 2010]

* Russian language support (RU). [Sun](https://github.com/sunchess)
* We <3 HTML5 (better supported HTML5 semantics) [Joe Sak](https://github.com/joemsak) and [Philip Arndt](https://github.com/parndt)
* Fixed issue with Refinery's 404 page. [Philip Arndt](https://github.com/parndt)
* Fixed recent inquiries display on dashboard when HTML present. [Steven Heidel](https://github.com/stevenheidel)
* Better dutch (NL) translations. [Michael van Rooijen](https://github.com/meskyanichi)
* Fixed for IE and added fixes to WYMeditor from the core project. [Philip Arndt](https://github.com/parndt)
* Added pagination for search results to the plugin generator. [Amanda Wagener](https://github.com/awagener)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.12...0.9.7.13)

## 0.9.7.12 [11 August 2010]

* Smoothed the sortable list in the admin UI. [Joe Sak](https://github.com/joemsak)
* Binding link dialogue URL checker to paste action. [Joe Sak](https://github.com/joemsak)
* Kill hidden overflow on dialogues for smaller browser windows. [Joe Sak](https://github.com/joemsak) and [Philip Arndt](https://github.com/parndt)
* Refactored the `parse_branch` method to speed up reordering on the server. [Joshua Davey](https://github.com/jgdavey)
* Running `refinerycms` with `-v` or `--version` will now output the version number. [Steven Heidel](https://github.com/stevenheidel)
* Made the core codebase not rely so heavily on `@page[:body]` by adding `Page.default_parts` and using `.first` on that instead. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.11...0.9.7.12)

## 0.9.7.11 [07 August 2010]

* Removed `app/controllers/application.rb` due to its serious deprecation. Fixed deprecations in how we use acts_as_indexed. [Philip Arndt](https://github.com/parndt)
* Added passing cucumber features for search for: [Uģis Ozols](https://github.com/ugisozols)
  - Images
  - Files
  - Inquiries
  - Pages
* Moved HTML5 enabling script to a partial so that IE always runs it first. [Philip Arndt](https://github.com/parndt)
* Fixed some invalid HTML. [Bo Frederiksen](https://github.com/bofrede)
* Added Danish translation for WYMeditor. [Bo Frederiksen](https://github.com/bofrede)
* Fixes for Tooltips [Philip Arndt](https://github.com/parndt)
  - Tooltips were not showing in dialogues, they now are.
  - Tooltips would not position properly above links, they now do.
  - The Tooltips' nibs (the arrow) would not sit properly centered above the element if the tooltip had to move for the browser window size, they now do.
* Lots of fixes for translations. [Uģis Ozols](https://github.com/ugisozols)
* Fix XSS vulnerability on page meta information by escaping the relevant fields properly [David Jones](https://github.com/djones)
* Ensure that the generator script grabs the first attribute that is a string, not just the first attribute, when choosing the field for Dashboard activity. [Joe Sak](https://github.com/joemsak)
* Updated `json-pure` to `1.4.5`, now using the actual gem [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.10...0.9.7.11)


## 0.9.7.10 [02 August 2010]

* Added options to site_bar partial to allow particular components to be disabled (CSS, JS, jQuery or cornering script) so that they don't interfere with these already being included in the theme. [Philip Arndt](https://github.com/parndt)
* Fixed the schema file as it was invalid somehow. [Steven Heidel](https://github.com/stevenheidel)
* Made search more consistent and added it to Spam/Ham. [Uģis Ozols](https://github.com/ugisozols)
* Fixed a bug with adding new resources. [Steven Heidel](https://github.com/stevenheidel)
* Fixed a range of issues with translation keys and grammar between different languages. [Uģis Ozols](https://github.com/ugisozols)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.9...0.9.7.10)

## 0.9.7.9 [30 July 2010]

* Added a theme generator to create the basic file structure of a new theme. [David Jones](https://github.com/djones) and [Levi Cole](https://github.com/levicole)
* Renamed `script/generate refinery` to `script/generate refinery_plugin`. [David Jones](https://github.com/djones)
* Add deprecation notice to `script/generate refinery`. [David Jones](https://github.com/djones)
* Updated documentation to reflect new generator changes. [David Jones](https://github.com/djones)
* Added tests for both plugin and theme generators. [David Jones](https://github.com/djones) and [Levi Cole](https://github.com/levicole)
* Refactored the `refinerycms` & `refinery-upgrade-097-to-097` tasks to make better use of Pathname. [Philip Arndt](https://github.com/parndt)
* Added more cucumber features and tagged existing ones. [Philip Arndt](https://github.com/parndt), [James Fiderlick](https://github.com/jamesfid) and [Steven Heidel](https://github.com/stevenheidel)
* Removed mysterious `page_translations` table if you had it. [Philip Arndt](https://github.com/parndt)
* Added workaround for tests that involve dialogues. [Uģis Ozols](https://github.com/ugisozols)
* Added as default the ability for forms to know whether they are inside a modal / dialog. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.8...0.9.7.9)

## 0.9.7.8 [23 July 2010]

* Refactored Amazon S3 and gem installation to make it easier to install on Heroku. [Steven Heidel](https://github.com/stevenheidel)
* Made project more testable. Renamed rake refinery:test_all to rake test:refinery [Philip Arndt](https://github.com/parndt)
* Documentation improved [David Jones](https://github.com/djones), [Philip Arndt](https://github.com/parndt) and [Steven Heidel](https://github.com/stevenheidel)
* Installed spork for use with systems that support forking for performance improvements. Doesn't run on Windows. [Philip Arndt](https://github.com/parndt) and [James Fiderlick](https://github.com/jamesfid)
* Improvements and new translations for Norsk Bokmål localisation. [Ken Paulsen](https://github.com/ken-guru)
* Ensured that ::Refinery::Setting restrictions work properly using a before_save handler. [Joe Sak](https://github.com/joemsak)
* Updated jquery-html5-placeholder-shim to latest version. [Amanda Wagener](https://github.com/awagener)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.7...0.9.7.8)

## 0.9.7.7 [20 July 2010]

* Fixed an issue in the plugin generator that saw locales being created with singular_name not the interpreted version. [Philip Arndt](https://github.com/parndt) and [Joe Sak](https://github.com/joemsak)
* Fixed an issue with non-MySQL databases. [Lee Irving](https://github.com/magpieuk)
* Refactored versioning and .gitignore file so that both are easier to follow and use. [Steven Heidel](https://github.com/stevenheidel)
* Added rake refinery:test_all command to run all tests Refinery has. [Steven Heidel](https://github.com/stevenheidel)
* Fixed deprecation warnings with translate rake tasks. [Steven Heidel](https://github.com/stevenheidel)
* Bugfixes, some IE compatibility. [Philip Arndt](https://github.com/parndt)
* Fix syntax errors in existing resource dialog. [David Jones](https://github.com/djones)
* Identified and fixed a positioning bug in dialogues [Joe Sak](https://github.com/joemsak) and [Philip Arndt](https://github.com/parndt)
* Fixed issue that was causing Refinery to load in rake tasks twice if they lived under `"#{Rails.root}/vendor/plugins"`. [David Jones](https://github.com/djones) and [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.6...0.9.7.7)

## 0.9.7.6 [15 July 2010]

* Bugfixes, fixed some failing tests. [Philip Arndt](https://github.com/parndt)
* More pt-BR translation keys translated. [Kivanio Barbosa](https://github.com/kivanio)
* Locked gems using `Gemfile.lock`. [David Jones](https://github.com/djones)
* Changed 'refinery' task to 'refinerycms' as that is our gem's name. [Steven Heidel](https://github.com/stevenheidel)
* Fixed bug where settings were still considered restricted if NULL. [Steven Heidel](https://github.com/stevenheidel)
* Ensures that bundler is available before creating an application from a gem. [Philip Arndt](https://github.com/parndt)
* Application generator (from gem) and application upgrade bin task. (from 0.9.6) is now Ruby 1.9.2 compatible. [Philip Arndt](https://github.com/parndt)
* bin/refinery-upgrade-from-096-to-097 will no longer allow you to run it if Gemfile is present and thus signifying an upgraded app. [Philip Arndt](https://github.com/parndt)
* Cleaned up syntax, changed CSS involving dialogues. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.5...0.9.7.6)

## 0.9.7.5 [08 July 2010]

* Wrote an upgrade task for migrating from 0.9.6.x releases of Refinery CMS. Just run refinery-update-096-to-097 inside your application's directory. [Philip Arndt](https://github.com/parndt)
* Improved code used to include gem rake tasks and script/generate tasks into the Refinery application to fix issue with these tasks not being found. [Philip Arndt](https://github.com/parndt)
* Fixed a broken migration that would mean pages were missing upon upgrading. [Jesper Hvirring Henriksen](https://github.com/hvirring)
* More pt-BR translation keys translated. [Kivanio Barbosa](https://github.com/kivanio)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.4...0.9.7.5)

## 0.9.7.4 [07 July 2010]

* Fixed critical issue in the i18n routing pattern that was matching prefixes like /news/ as a locale incorrectly. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.3...0.9.7.4)

## 0.9.7.3 [07 July 2010]

* Falls back to default locale when a translation key can not be located in the current locale, only in production mode. [Philip Arndt](https://github.com/parndt)
* Fixed issue creating a Refinery site using bin/refinery where directory paths contained spaces. [Philip Arndt](https://github.com/parndt)
* Fixed issue when using script/generate refinery surrounding the migration incorrectly using the plugin's title. [Philip Arndt](https://github.com/parndt)
* Added verbose=true option when running rake refinery:update that prints out everything it's doing. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.2...0.9.7.3)

## 0.9.7.2 [06 July 2010]

* Bugfixes with users and roles. [Philip Arndt](https://github.com/parndt) and [Amanda Wagener](https://github.com/awagener)
* Fixed the rake translate:lost_in_translation LOCALE=en and rake translate:lost_in_translation_all tasks so that they accurately reflect the missing i18n translation keys. [Philip Arndt](https://github.com/parndt)
* Refactored routing of i18n to allow different default frontend and backend locales. [Philip Arndt](https://github.com/parndt)
* Added better grammar support for some i18n. [Halan Pinheiro](https://github.com/halan)
* Improved output of rake refinery:update task and removed bin/refinery-update-core task. [Steven Heidel](https://github.com/stevenheidel)
* Set config.ru to run in production RAILS_ENV by default. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7.1...0.9.7.2)

## 0.9.7.1 [03 July 2010]

* Bugfixes in the gem installation method process. [Philip Arndt](https://github.com/parndt)
* Made installing from gem faster. [Philip Arndt](https://github.com/parndt)
* Provided example files for sqlite3, mysql and postgresql. [Philip Arndt](https://github.com/parndt)
* Created option for specifying a database adapter (sqlite3, mysql or postgresql) when creating from Gem. [Philip Arndt](https://github.com/parndt)
* Other bugfixes including UI consistency around signup. [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.7...0.9.7.1)

## 0.9.7 [02 July 2010]

* Full backend internationalisation (i18n) support and frontend i18n routing. [Maarten Hoogendoorn](https://github.com/moretea) and [Philip Arndt](https://github.com/parndt) and many others
* Marketable URLs, such as "/contact". [Joshua Davey](https://github.com/jgdavey) and [Joe Sak](https://github.com/joemsak).
* Switched to bundler and rack. [Alex Coles](https://github.com/myabc) and [Philip Arndt](https://github.com/parndt)
* Added options to Refinery Settings :restricted, :scoping, :callback_proc_as_string. [Steven Heidel](https://github.com/stevenheidel) and [Philip Arndt](https://github.com/parndt)
* Added caching abilities to frontend and to ::Refinery::Setting to drastically speed up the application under certain conditions. [Philip Arndt](https://github.com/parndt)
* Added spam filtering to contact form. [David Jones](https://github.com/djones)
* Full Refinery UI redesign. [Resolve Digital](https://github.com/resolve)
* User Role support. [Amanda Wagener](https://github.com/awagener) and [Philip Arndt](https://github.com/parndt)
* [See full list](https://github.com/refinery/refinerycms/compare/0.9.6.34...0.9.7)
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
