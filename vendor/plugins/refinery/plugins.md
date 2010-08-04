# Extending Refinery with Plugins

## Introduction

__Refinery is designed to be easily extended so you can quickly customise your Refinery site to manage new areas you want to add to your site. If you see something you want to customise, the chances are you can customise it.__

The main way of extending Refinery is through adding new plugins to your app. By default you can edit pages in Refinery's backend, but how do you add a new section to manage like products?

## The Refinery Generator

The Refinery generator is a standard Rails generator that functions just like the scaffold generator. It allows you to quickly add new managed sections to the Refinery backend and get the front end views for free.

To see how to use the generator run

    ruby script/generate refinery_plugin

Usage instructions should appear.

## Example of Using the Generator

Let's say you have a client who has a range of products they want to show on their website. You've considered using a few pages to manage the products but you've decided it would be much nicer if there was a separate place that had forms dedicated to managing products.

First decide what fields they need to manage. In our case, the client is going to want to edit the title and description of each product. They would also like a little "facts panel" to show on the right of the page.

So go to the root of your project and run

    ruby script/generate refinery_plugin

This will output the help on how to use the generator. To generate the new section we want to manage products we run:

    ruby script/generate refinery_plugin product title:string description:text image:image brochure:resource

The generator will output a list of files it generated. You'll notice there is a new plugin that has been added in ``vendor/plugins/products``. This is where both the backend and front end files are held for this new products area.

A new database migration has been added to add the products table in so run:

    rake db:migrate

Start up your app by running ``ruby script/server`` go to [http://localhost:3000](http://localhost:3000) and you'll see instantly a new menu item called "products". Click on that and you'll see there are no products yet.

Now go to the backend of your site by visiting [http://localhost:3000/refinery](http://localhost:3000/refinery) and logging in. You'll see a new tab called "Products", click on that and then click "Add a new product", fill the form and add an example product. Now go back to the front end and you'll see your product is showing up in the products part of your site.

Now you have a fully managed products section in Refinery, nice.

If you want to modify your generated plugin you need to understand the basic structure of how they work.

## The Structure of a Plugin

Think of a plugin in Refinery as a small Rails app or an "engine". Plugins have a structure that is extremely similar to a Rails app. Here's an example of Refinery's pages plugin (located in Refinery's ``vendor/plugins/pages/`` folder)

    pages
      |- app
      |   |- controllers
      |   |   |- admin
      |   |   |    |- pages_dialogs_controller.rb
      |   |   |    |- page_parts_controller.rb
      |   |   |    |- pages_controller.rb
      |   |   |- pages_controller.rb
      |   |- helpers
      |   |   |- pages_helper.rb
      |   |- models
      |   |   |- page.rb
      |   |- views
      |       |- pages
      |       |   |- home.html.erb
      |       |   |- show.html.erb
      |       |- admin
      |           |- pages
      |               |- _form.html.erb
      |               |- edit.html.erb
      |               |- index.html.erb
      |               |- new.html.erb
      |- config
      |   |- routes.rb
      |- rails
          |- init.rb


### app/controllers

In this example you see one "public" controller ``app/controllers/pages_controller`` that is responsible for managing the front end when I view a page.

### app/controllers/admin

This bit is important. It's where all the controllers are held to manage pages in the Refinery back end in this example. You can ignore the ``pages_dialogs_controller.rb`` and ``page_parts_controller.rb`` for now and let's just focus on the ``admin/pages_controller.rb`` file. Here's what that looks like inside at a basic level:

    class Admin::PagesController < Admin::BaseController

      crudify :page, :conditions => "parent_id IS NULL",
                     :order => "position ASC", :paging => false

    end

This single controller allows us to create, read, update and delete pages in the backend. With a little bit of Refinery magic we utilise the [crudify mixin](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery/crud.md) which gives us all of these regular features out of the box.

How crudify works is an entire topic of it's own. Checkout the [crudify documentation](http://github.com/resolve/refinerycms/blob/master/vendor/plugins/refinery/crud.md) to get an insight into how that works.

### app/views and app/helpers

Works exactly the same as ``app/views`` and ``app/helpers`` in a normal Rails app. You just put the views and helpers related to this plugin in here instead of in your actual main app directory.

### config/routes.rb

Works exactly the same as ``config/routes.rb`` in your app except this routes file only loads the routes for this plugin.

### rails/init.rb

This file runs when your site is started up. All is does is registers this plugin with Refinery so it knows that it exists, how to handle it in the Refinery admin menu and how to render recent activity on the Dashboard (see "Getting your Plugin to Report Activity in the Dashboard")

    Refinery::Plugin.register do |plugin|
      plugin.title = "Pages"
      plugin.description = "Manage content pages"
      plugin.version = 1.0
      plugin.menu_match = /(refinery|admin)\/page(_dialog|part)?s$/
      plugin.activity = {
        :class => Page,
        :url_prefix => "edit_",
        :title => "title",
        :created_image => "page_add.png",
        :updated_image => "page_edit.png"
      }
    end

## Getting your Plugin to Report Activity in the Dashboard

Recent activity reporting is built right in, so all you need to do is follow the convention below and your plugin will start showing up in the recent activity list of the Dashboard.

In our example above we showed the use of ``plugin.activity`` for the pages plugin.

    Refinery::Plugin.register do |plugin|
      plugin.title = "Pages"
      plugin.description = "Manage content pages"
      plugin.version = 1.0
      plugin.menu_match = /(refinery|admin)\/page(_dialog|part)?s$/
      plugin.activity = {
        :class => Page,
        :url_prefix => "edit_",
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
    # Just use "edit_" if you're not sure how this works.
    #
    # When it says "'About' page was updated about 4 hours ago", the page title "About"
    # is linked to that page in a way we specify.  So by setting "_edit" as a :url_prefix what
    # we're doing is making it link to the page that allows us to edit this page.
    # So the next result is edit_admin_page_url(page)

    :title
    # which attribute on the :class should be in the activty message. In our case it's "title"
    # because we want it to run something like this "#{page.title} was updated about ...."

### Optional

    :created_image and :updated_image
    # the activity monitor knows if something is created or updated and shows a different icon
    # depending on how you want that to look. You can specify the filename to any image you
    # want in the public/images/refinery/icons/ directory.

## Search Engine Optimisation: Improving the default URLs

In our example above we extended Refinery to manage a products area. The problem is when I look at a product on the front end I get a URL like [http://localhost:3000/products/1](http://localhost:3000/products/1) but I would really like it to be something like [http://localhost:3000/products/my-product](http://localhost:3000/products/my-product)

To achieve this all you need to do is open up the product model (found in ``/vendor/plugins/products/app/models/product.rb``) and add the following line inside your class:

    has_friendly_id :title, :use_slug => true

Note you want to change ``:title`` to the field which you want to show up in the URL.

This will work just fine for new products added from this point, but you'll want to migrate any existing products you have to use this new URL format. All you have to do is save each product you have in the database to make it create a nice URL for you.

    ruby script/console
    >> Product.all.each {|p| p.save };nil

Now all the products in your database will have nice URLs.

## How to get a WYSIWYG editor to show on your form fields

Refinery uses a standards compliant visual editor called [WYMeditor](http://www.wymeditor.org/)

_Note: When using the Refinery generator, if you apply a field type of "text" to any of your fields, they automatically load as a WYMEditor._

The WYSIWYG editor can only be applied to a ``textarea``. All you need to do is add a class of "wymeditor widest" to a ``textarea`` in your form and a WYSIWYG WYMEditor will load right in place.

### Example

Again going back to our product plugin example if you had this in your ``vendor/plugins/products/app/views/admin/products/_form.html.erb`` file:

    <%= f.text_area :description %>

Just change that to:

    <%= f.text_area :description, :class => "wymeditor widest" %>

Refresh and you're done.