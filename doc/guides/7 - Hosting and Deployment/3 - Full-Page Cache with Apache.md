# Full-Page Cache with Apache

If you have a simple Page on a slow Server with Apache you can use the Full Page Caching for deliver the most pages directly from Apache (without passenger).

## Activate "Cache Pages Full"

Inside `config/initializers/refinery/pages.rb`, find the line that reads:

```ruby
config.cache_pages_full = false
```

Set it to true, and uncomment the line:

```ruby
config.cache_pages_full = true
```

Then restart your server.

From then on, every page you request from Refinery CMS will be saved at `public/refinery/cache/pages`. For example, after you request `http://your-website/about`, you will find a file named `public/refinery/cache/pages/about.html` inside your application folder.

## Redirect

Now we have to redirect Apache to these generated files.

Add the following to your apache config or create an `.htaccess` file in your project root:

```shell
RewriteEngine On

# Rewrite home to check for static
RewriteRule ^$ home

# Checks cache directory for already cached pages
RewriteCond %{REQUEST_URI} ^/[a-zA-Z0-9\-/]*$
RewriteCond %{DOCUMENT_ROOT}/refinery/cache/pages%{REQUEST_URI}.html -f
RewriteRule ^([^.]+)$ refinery/cache/pages/%{REQUEST_URI}.html [L]

# By default, Rails appends asset timestamps to all asset paths. This allows
# you to set a cache-expiration date for the asset far into the future
ExpiresActive on
ExpiresByType image/gif "access plus 1 year"
ExpiresByType image/png "access plus 1 year"
ExpiresByType image/jpeg "access plus 1 year"
ExpiresByType image/x-icon "access plus 1 year"
ExpiresByType text/css "access plus 1 year"
ExpiresByType application/javascript "access plus 1 year"

# compress static text files
AddOutputFilterByType DEFLATE text/html text/plain text/xml text/javascript text/css application/javascript
```

Now pages are delivered by Apache without touching Passenger.

## Page caching with Rails 4

The built-in page caching has been extracted to a separate gem in Rails 4. You need to add the gem `actionpack-page_caching` to your `Gemfile` if you're using Rails 4+.
