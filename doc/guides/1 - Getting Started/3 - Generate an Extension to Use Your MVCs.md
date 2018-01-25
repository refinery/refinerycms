# Generate an Extension to Use Your Own MVCs

This guide explains how to generate and get started with an extension in Refinery. After reading it, you should be familiar with:

* The basic structure of a Refinery extension
* Using the Refinery generator to generate a custom extension
* Extending Refinery's functionality with custom extensions
* Crudify, a CRUD module that Refinery provides

__WARNING__: This guide is based on Refinery CMS 2.1.0 so some of the code shown here may not work in earlier versions of Refinery.

## Guide Assumptions

This guide continues the Rick Rock Star example from the [Getting Started](/guides/getting-started/) guide. You will need to have Refinery installed and running as explained in that guide.

This guide does not assume that you have any prior experience with Refinery beyond what is covered in the [Getting Started](/guides/getting-started/) guide, but it does assume that you are somewhat familiar with Rails. If you are not familiar with Rails, you will still be able to step through the guide but you may not fully understand all of the commands or code. Here are some resources to learn more about Rails:

* [Ruby on Rails](http://rubyonrails.org/)
* [Ruby on Rails Guides for v3.2](http://guides.rubyonrails.org/v3.2.14/) - Note that these are the guides for Rails version `3.2` since that is the version Refinery requires.
* [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html)
* [Rails for Zombies](http://railsforzombies.org)

## The Anatomy of an Extension

Think of a Refinery extension as a miniature Rails application running in your `vendor/extensions` directory. Each extension specifies its own routes in its config directory and has its own views and controllers in its own app directory. In fact, each extension is actually a `Rails engine` Engines can serve up their own images, stylesheets and javascripts by utilizing the asset pipeline, which got introduced in Rails 3.1. You can define your own models, views, and controllers in an extension and they can take full advantage of all of the functionality that Refinery offers.

Since an extension is a kind of engine, it has the same familiar directory structure. You'll see folders for your models, views, controllers, helpers, decorators, config, and so forth. Your code goes in those folders just as it does in a regular Rails application or engine.

## Generating an extension

Refinery ships with an extension generator that makes adding your own functionality a breeze. It works just like the Rails scaffold generator: given information about a model, it will automatically generate the necessary model, view, controller, configuration, and database files for you and will put them into their appropriate directories. Here's the command:

```shell
$ rails generate refinery:engine singular_model_name attribute:type [attribute:type ...]
```
__TIP__: to see all the options supported by the `refinery:engine` generator just run `rails g refinery:engine`.

Here is a list of the most often used field types and what they give you:

```shell
  -------------------- -------------------------------------------------------------------------------------------------------
  **field type**       **description**
  text                 a multiline visual editor
  resource             a link which pops open a dialog which allows the user to select an existing file or upload a new one
  image                a link which pops open a dialog which allows the user to select an existing image or upload a new one
  string and integer   a standard single line text input
  -------------------- -------------------------------------------------------------------------------------------------------
```

If you remember from the [Getting Started](/guides/getting-started/) guide, we told Rick that we'll give him an area to post up events he'll be at. Although we could technically create a new page in Refinery to add the event content there, areas that have special functionality are much better suited as an extension.

Rick is going to want to enter the following information about each event:

* The title
* The date of the event
* A photo
* A little blurb about the event.

Run this command to generate the events extension for Rick:

```shell
$ rails generate refinery:engine event title:string date:datetime photo:image blurb:text
```

This results in the following:

```shell
 create vendor/extensions/events/app/controllers/refinery/admin/events_controller.rb
 create vendor/extensions/events/app/controllers/refinery/events_controller.rb
 create vendor/extensions/events/app/models/refinery/event.rb
 create vendor/extensions/events/app/views/refinery/admin/events/_actions.html.erb
 create vendor/extensions/events/app/views/refinery/admin/events/_form.html.erb
 create vendor/extensions/events/app/views/refinery/admin/events/_events.html.erb
 create vendor/extensions/events/app/views/refinery/admin/events/_records.html.erb
 create vendor/extensions/events/app/views/refinery/admin/events/_event.html.erb
 create vendor/extensions/events/app/views/refinery/admin/events/_sortable_list.html.erb
 create vendor/extensions/events/app/views/refinery/admin/events/edit.html.erb
 create vendor/extensions/events/app/views/refinery/admin/events/index.html.erb
 create vendor/extensions/events/app/views/refinery/admin/events/new.html.erb
 create vendor/extensions/events/app/views/refinery/events/index.html.erb
 create vendor/extensions/events/app/views/refinery/events/show.html.erb
 create vendor/extensions/events/config/locales/en.yml
 create vendor/extensions/events/config/locales/es.yml
 create vendor/extensions/events/config/locales/fr.yml
 create vendor/extensions/events/config/locales/lolcat.yml
 create vendor/extensions/events/config/locales/nb.yml
 create vendor/extensions/events/config/locales/nl.yml
 create vendor/extensions/events/config/routes.rb
 create vendor/extensions/events/db/migrate/20111031210430_create_events.rb
 create vendor/extensions/events/db/seeds.rb
 create vendor/extensions/events/lib/generators/refinery/events_generator.rb
 create vendor/extensions/events/lib/refinerycms-events.rb
 create vendor/extensions/events/lib/tasks/events.rake
 create vendor/extensions/events/readme.md
 create vendor/extensions/events/refinerycms-events.gemspec
 ...
------------------------
Now run:
bundle install
rails generate refinery:events
rake db:migrate
rake db:seed
Please restart your rails server.
------------------------
```

As the output shows, next run these commands:

```shell
$ bundle install
$ rails generate refinery:events
$ rake db:migrate
$ rake db:seed
```

A line for the events extension has been added in the Gemfile of your application. `bundle install` will verify and load the extension. A generator has been created for you that will automatically create the event table and db seed calls for you: `rails generate refinery:events` will generate the migration and db seed files for the extension based on the fields you specified in the `rails generate refinery:engine ...` command. And finally, running `rake db:migrate` and `rake db:seed` will load and run the migration and db:seed files that you just generated for the events extension. .

When you run bundle install, you may see a message that says

```shell
...extensions/events did not have a valid gemspec. This prevents bundler from installing bins or native extensions, but that may not affect its functionality. The validation message from Rubygems was:
   authors may not be empty
```

This is a warning message from RubyGems telling you that no author is specified for this extension. This is only important if you are going to create a gem from this extension. You can safely ignore this message. If you do want to resolve it and get rid of the message, you can edit the [gem specification file](http://guides.rubygems.org/specification-reference/) for the extension `refinerycms-events.gemspec` and put your name in there as the author. Just put this line: `s.author = 'yourname'` in the do block (after the `s.version....` line is fine).

__TIP__: When new extensions are added it's a good idea to restart your server for new changes to be loaded in.

__TIP__: Models in Refinery extensions expect a string field that acts as the title identifier when displayed in lists in the admin pages. If a title field is not included, the first string field found will be used. Models without a usable field for a title will cause the admin to raise an error, so please include a title field or alias when creating models in your extension.

Now go to the backend of your Refinery site ([http://localhost:3000/refinery](http://localhost:3000/refinery)) and
you'll notice a new tab called "Events". Click on "Add new event" and you'll see something like this:

![Adding an event](https://www.refinerycms.com/system/images/W1siZiIsIjIwMTMvMDYvMDkvMjNfNTdfNDRfODYwX2V2ZW50X3BhZ2VfZWRpdC5wbmciXV0/event_page_edit.png?sha=d45dd13cf1a97d8f)

You'll see the entire form has been generated for you based off the field types you specified when generating the events section. The blurb has a visual editor, the date field is a date picker and the photo allows you to pick or upload a new photo from a built-in Refinery dialog.

Add a couple of mock events to your events extension.

Now click on "Switch to your website", and navigate to <http://localhost:3000/events>

You'll notice not only has Refinery generated the backend "Events" tab but also a new menu item called "Events" and two new front-end views,`index.html.erb` and `show.html.erb`, located in `vendor/extensions/events/app/views/refinery/events/` for you to customise.

![Events frontend with undesired ordering](https://www.refinerycms.com/system/images/W1siZiIsIjIwMTAvMTIvMDIvMTRfMjRfNTFfNDE1X2V2ZW50c19lbmdpbmVfc21hbGwucG5nIl1d/events-engine-small.png?sha=d3af41646dd136ba)

As you can see, Refinery makes it really easy to quickly add new extensions to manage various areas of a site.

But I've noticed one problem. The "2011 Music Awards" is showing up in the middle when it makes more sense to order the events with the latest event at the top. To fix this we need to understand what's happening under the hood of a Refinery extension. Let's dive in.

## Testing your extension

There is a separate guide which covers this subject found at [Testing Your Extension](/guides/testing/).

## Crudify: The Backbone of Refinery Engines

Any Refinery extension, even the built-in ones, that focus on Create, Read, Update and Delete are driven by crudify. Crudify is a highly reusable module included with Refinery that gives you all the standard CRUD actions as well as reordering, searching and paging.

Open up `vendor/extensions/events/app/controllers/refinery/events/admin/events_controller.rb` and look at its contents:

```ruby
module Refinery
  module Events
    module Admin
      class EventsController < ::Refinery::AdminController

        crudify :'refinery/events/event', :xhr_paging => true

      end
    end
  end
end
```

Most of the time, crudify's defaults are bang on, but if you need to, you can easily customise how it works.

By default `crudify` assumes your records will be sortable. But events should not be manually sortable; it makes more sense to order them by their event date. Update the contents of the file to this:

```ruby
module Refinery
  module Events
    module Admin
      class EventsController < ::Refinery::AdminController

        crudify :'refinery/events/event', :xhr_paging => true,
                                          :order => "date DESC",
                                          :sortable => false

      end
    end
  end
end
```

This will tell *crudify* to sort by our event date field and to turn off manual sorting by the user.

Finally edit `vendor/extensions/events/app/controllers/refinery/events/events_controller.rb` and replace the `find_all_events` method with this one:

```ruby
module Refinery
  module Events
    class EventsController < ::ApplicationController

      # code

      protected

        def find_all_events
          # Order by event date
          @events = Event.order("date DESC")
        end

        # code

    end
  end
end
```

Now when you look at <http://localhost:3000/events> you'll notice they're now being sorted by the event date.

![Finished events frontend](https://www.refinerycms.com/system/images/W1siZiIsIjIwMTAvMTIvMDIvMTRfMjRfNTFfMzE0X2V2ZW50c19lbmdpbmVfZml4ZWRfc21hbGwucG5nIl1d/events-engine-fixed-small.png?sha=452dcc1cbd2522c3)

## What's Next?

Now that you've made your first Refinery application with a custom events extension, you should feel free to update it and experiment on your own. But you don't have to do everything without help.

If you need assistance getting up and running with Refinery, follow the [How to get help with Refinery Guide](/guides/how-to-get-help/).
