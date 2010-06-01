# The Magical Mixin: Crudify (create, read, update & delete)

## Introduction

__Most controllers Refinery and other apps do four common things, create, read, update and delete stuff.__ Instead of writing the same logic for these actions over and over again we wrap all this functionality up into what we called ``crudify``.

``crudify`` takes these four basic actions and extends them to allow easy paging, searching and sorting too.

Although this single file is included in Refinery, you could take just this single file and use it in any app you like.

The best part about ``crudify`` is that this gives you a smart default and if there is anything you want to work differently just override that method.

## Where is it located?

``vendor/plugins/refinery/lib/crud.rb``

## How do I use it in my plugins?

All you need to do is call ``crudify`` in your controller.

If you used the Refinery generator you're plugin will already be using ``crudify``.

### Example

    class NewsItemsController < ApplicationController

      crudify :news_item, :order => "created_at DESC"

    end
  
### Complex Example

    class NewsItemsController < ApplicationController

      crudify :news_item, :order => "created_at DESC",
                          :conditions => 'published = true',
                          :sortable => false,
                          :searchable => true,
                          :include => [:author],
                          :paging => true,
                          :search_conditions => ''

    end

## What can you configure with ``crudify``?

### ``:title_attribute``

Default value is ``title``

This is the human readable value you want ``crudify`` to use throughout. Just choose an attribute that is on your model that is short and descriptive to what the model is.

#### Example

On a page model you'd probably use "title" (which is default so you don't need to specify this)

#### Example 2

On a ``team_member`` model you'd probably want to use an attribute like ``name``.

### ``:order``

Default value is ``position ASC``

This is the position that is used when listing out what you're crudifying. If you have ``:sortable`` set to ``true`` you probably want to have your ``:order`` set to ``position ASC`` so it uses the order you have set when sorting.

If you have a news area, it makes more sense to sort by ``posted_at``. So you might set it like this

    :order => "posted_at DESC"

### ``:conditions``

Default value is ``nil``

This will filter down the list of items you have when you're asking for all records.

An example here is say you're crudifying a photos table that uses attachment_fu. Attachment_fu creates several photo records, 1 for the main photo and others for it's "children" thumbnails. Those thumbnails have a parent id set.

So when viewing a list of the images you have you don't want it to show all the thumbnails too, you just want to each see unique image listed so you need to apply some conditions to hide the thumbnails.

You do that like this:

    :conditions => "parent_id IS NULL"

### ``:sortable``

Default value is ``true``

Enabling ``:sortable`` gives you several handy methods which "just work" with sortable JavaScript lists. One of the methods is ``update_positions()`` which handles saving the new position items have been sorted into.

### ``:searchable``

Default value is ``true``

When this option is ``true``, the routes are modified so when you go to the next page of results the search continues on.

### ``:include``

Default value is ``[]``

For performance optimisation, sometimes you might want to eager load other related models to this one. For example a ``news_post`` might below to a ``user`` who wrote the post. But in our index view we're printing out the name of each user.

Instead of having to look up each user for each of the ``news_posts`` we iterate over, the ``:include`` option allows you to load the ``news_post`` and user all at the same time which'll allow you to save on expensive database queries.

Here's an example of that.
  
    class NewsItem
    
      belongs_to :user
  
    end
  
    class NewsItemsController < ApplicationController

      crudify :news_item, :order => "created_at DESC", :include => [:user]

    end

### ``:paging``

Default value is ``true``

The ``:paging`` option tells ``crudify`` you don't just want one big long list but rather to break it out into pages and support paging methods uses [will_paginate](http://wiki.github.com/mislav/will_paginate/).

### ``:search_conditions``

Default value is ``nil``

Similar to the ``:conditions`` options, ``:search_conditions`` just apply these conditions when delivering search results.

## Easy Accessor Methods

``crudify`` automatically writes up finder methods for the model you're crudifying. The easier way to explain this is with an example.

Say we have a pages controller that is going to manage pages.

    class PagesController < ApplicationController

      crudify :page

    end
  
In this controller, automatically I have these methods:

    find_page()
    find_all_pages()
  
So say I wanted to change the way all pages are found, all I do is override the ``find_all_pages`` method.

    class PagesController < ApplicationController

      crudify :page
  
      def find_all_pages
        @pages = Page.find(...) # apply any logic I want here to get all pages.
      end

    end

## Overriding or Extending Crudify

Before overriding anything, the best thing to do is check out how the default works. Read the ``vendor/plugins/refinery/lib/crud.rb`` and see what code it's injecting into your controller.

Pick the method you want to override and then override it in your controller.

Let's go back to the example above with the pages controller.

    class PagesController < ApplicationController

      crudify :page

    end
  
Say every time someone deletes a page I want my ``NotificationMailer`` to email me to say someone just deleted a page.

When I look in the ``crud.rb`` file I see that my controller has this added to it

    def destroy
      flash[:notice] = "'\#{@#{singular_name}.#{options[:title_attribute]}}' was successfully deleted." if @#{singular_name}.destroy
      redirect_to admin_#{plural_name}_url
    end
  
To override this all I would is create my own delete method that works the same but just with my mailer code on it.

    class PagesController < ApplicationController

      crudify :page

      def destroy
        if @page.destroy
          flash[:notice] = "'#{@page.title}' was successfully deleted."
          NotificationMailer.deliver_page_deleted(@page) # sends me an email to say a page was deleted
        end
        redirect_to admin_pages_url
      end

    end
