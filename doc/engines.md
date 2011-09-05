# Extending Refinery with Engines

## Introduction

__Refinery is designed to be easily extended so you can quickly customise your
Refinery site to manage new areas you want to add to your site.
If you see something you want to customise, the chances are you can customise it.__

The main way of extending Refinery is through adding new engines to your app.
By default you can edit pages in Refinery's backend, but how do you add a new
section to manage like products?

See: [The Refinery Engine Generator](https://github.com/resolve/refinerycms/blob/master/generators/readme.md)

## The Structure of an Engine

Think of a engine in Refinery as a small Rails app. Engines have a structure that
is extremely similar to a Rails app. Here's an example of Refinery's pages engine
(located in Refinery's ``pages/`` folder (not all files are listed below))

    pages
      |- app
      |   |- controllers
      |   |   |- refinery
      |   |   |   |- admin
      |   |   |   |    |- pages_dialogs_controller.rb
      |   |   |   |    |- page_parts_controller.rb
      |   |   |   |    |- pages_controller.rb
      |   |   |   |- pages_controller.rb
      |   |- helpers
      |   |   |- refinery
      |   |   |   |- pages_helper.rb
      |   |- models
      |   |   |- refinery
      |   |   |   |- page.rb
      |   |   |   |- page_part.rb
      |   |- views
      |   |   |- refinery
      |   |       |- pages
      |   |       |   |- home.html.erb
      |   |       |   |- show.html.erb
      |   |       |- admin
      |   |           |- pages
      |   |               |- _form.html.erb
      |   |               |- edit.html.erb
      |   |               |- index.html.erb
      |   |               |- new.html.erb
      |- config
      |   |- routes.rb
      |   |- locales
      |       |- en.yml


### app/controllers/refinery

In this example you see one "public" controller ``app/controllers/refinery/pages_controller``
that is responsible for managing the front end when I view a page.

### app/controllers/refinery/admin

This bit is important. It's where all the controllers are held to manage pages
in the Refinery back end in this example. You can ignore the ``pages_dialogs_controller.rb``
and ``page_parts_controller.rb`` for now and let's just focus on the ``refinery/admin/pages_controller.rb``
file. Here's what that looks like inside at a basic level:

    module ::Refinery
      module Admin
        class PagesController < ::Refinery::AdminController

          crudify :'refinery/page',
                  :conditions => nil,
                  :order => "lft ASC",
                  :redirect_to_url => :'main_app.refinery_admin_pages_path',
                  :include => [:slugs, :translations, :children],
                  :paging => false

        end
      end
    end

This single controller allows us to create, read, update and delete pages in the backend.
With a little bit of Refinery magic we utilise the [crudify mixin](https://github.com/resolve/refinerycms/blob/master/doc/crud.md)
which gives us all of these regular features out of the box.

How crudify works is an entire topic of it's own.
Check out the [crudify documentation](https://github.com/resolve/refinerycms/blob/master/doc/crud.md)
to get an insight into how that works.

### app/views/refinery and app/helpers/refinery

Works exactly the same as ``app/views`` and ``app/helpers`` in a normal Rails app.
You just put the views and helpers related to this engine in here instead of in your
actual main app directory.

### config/routes.rb

Works exactly the same as ``config/routes.rb`` in your app except this routes file
only loads the routes for this engine.

### engine/lib/refinerycms-engine_name.rb

This file runs when your site is started up. All it does is registers this engine
with Refinery so it knows that it exists, how to handle it in the Refinery admin
menu and how to render recent activity on the Dashboard (see "Getting your Engine
to Report Activity in the Dashboard")

# engine/lib/pages.rb
    initializer "init plugin", :after => :set_routes_reloader do |app|
      ::Refinery::Plugin.register do |plugin|
        plugin.pathname = root
        plugin.name = 'refinery_pages'
        plugin.directory = 'pages'
        plugin.version = %q{2.0.0}
        plugin.menu_match = /refinery\/page(_part)?s(_dialogs)?$/
        plugin.url = app.routes.url_helpers.refinery_admin_pages_path
        plugin.activity = {
          :class => ::Refinery::Page,
          :url_prefix => "edit",
          :title => "title",
          :created_image => "page_add.png",
          :updated_image => "page_edit.png"
        }
      end
    end

# engine/config/locales/en.yml
    en:
      refinery:
        plugins:
          refinery_pages:
            title: Pages
            description: Manage content pages

## Getting your Engine to Report Activity in the Dashboard

Recent activity reporting is built right in, so all you need to do is follow the
convention below and your engine will start showing up in the recent activity
list of the Dashboard.

In our example above we showed the use of ``plugin.activity`` for the pages engine.

    ::Refinery::Plugin.register do |plugin|
      plugin.pathname = root
      plugin.name = 'refinery_pages'
      plugin.directory = 'pages'
      plugin.version = %q{2.0.0}
      plugin.menu_match = /refinery\/page(_part)?s(_dialogs)?$/
      plugin.url = app.routes.url_helpers.refinery_admin_pages_path
      plugin.activity = {
        :class => ::Refinery::Page,
        :url_prefix => "edit",
        :title => "title",
        :created_image => "page_add.png",
        :updated_image => "page_edit.png"
      }
    end

Here's what the different activity options mean:

### Required

    :class
    # the name of the class we're watching.

    :url_prefix
    # Just use "edit" if you're not sure how this works.
    #
    # When it says "'About' page was updated about 4 hours ago", the page title "About"
    # is linked to that page in a way we specify.  So by setting "edit" as a :url_prefix what
    # we're doing is making it link to the page that allows us to edit this page.
    # So the next result is edit_refinery_admin_page_path(page)

    :title
    # which attribute on the :class should be in the activty message. In our case it's "title"
    # because we want it to run something like this "#{page.title} was updated about ...."

### Optional

    :created_image and :updated_image
    # the activity monitor knows if something is created or updated and shows a different icon
    # depending on how you want that to look. You can specify the filename to any image you
    # want in the core/app/assets/images/refinery/icons/ directory.

## Search Engine Optimisation: Improving the default URLs

In our example above we extended Refinery to manage a products area. The problem
is when I look at a product on the front end I get a URL like
[http://localhost:3000/products/1](http://localhost:3000/products/1) but I would
really like it to be something like [http://localhost:3000/products/my-product](http://localhost:3000/products/my-product)

To achieve this all you need to do is open up the product model
(found in ``/vendor/engines/products/app/models/refinery/product.rb``) and add the following
line inside your class:

    has_friendly_id :title, :use_slug => true

Note you want to change ``:title`` to the field which you want to show up in the URL.

This will work just fine for new products added from this point, but you'll want
to migrate any existing products you have to use this new URL format.
All you have to do is save each product you have in the database to make it create
a nice URL for you.

    rails console
    >> Refinery::Product.all.each { |p| p.save }

Now all the products in your database will have nice URLs.

## How to get a WYSIWYG editor to show on your form fields

Refinery uses a standards compliant visual editor called [WYMeditor](http://www.wymeditor.org/)

_Note: When using the Refinery generator, if you apply a field type of "text" to
any of your fields, they automatically load as a WYMEditor._

The WYSIWYG editor can only be applied to a ``textarea``. All you need to do is
add a class of "wymeditor widest" to a ``textarea`` in your form and a WYSIWYG
editor will load right in place.

### Example

Again going back to our product plugin example if you had this in your
``vendor/engines/products/app/views/refinery/admin/products/_form.html.erb`` file:

    <%= f.text_area :description %>

Just change that to:

    <%= f.text_area :description, :class => "wymeditor widest" %>

Refresh and you're done.
