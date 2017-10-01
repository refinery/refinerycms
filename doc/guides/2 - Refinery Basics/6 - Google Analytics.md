# Google Analytics

Google Analytics is a great free way to find out how much traffic your site is getting. This guide will show you how to:

* Use the built in Refinery setting and layout to easily add Google Analytics support to your existing Refinery site

Default Refinery layouts have Google Analytics support built in. To start using Google Analytics on your site, all you need to do is edit `config/initializers/refinery/core.rb`.

Uncomment and edit `config.google_analytics_page_code`.

By default, the Analytics code will only be rendered in the layout in production, and if you are not logged into Refinery.