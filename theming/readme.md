# Themes

## Introduction

__Themes allow you to wrap up the design of your Refinery site into a single folder that is portable.__

Refinery doesn't force you to learn a special templating language, but rather just uses the regular
ERB views you're used to in Rails. This means creating a theme from your existing site is extremely easy.

Think of a theme as your ``app/views`` directory with a few extra things like images, css and javascript.

It's worth noting you don't need to use a theme if you don't want to. Placing files in the ``app/views`` directory like any other Rails app will work just fine. It's only if you want to wrap your design up into a single location that you would use a theme or allow your client to easily change between designs.

## The Structure of a Theme

Themes sit in your Rails app like this

    app/
    config/
    db/
    lib/
    public/
    themes/
      |- mytheme/
      |- othertheme/
    plugins/
    tests/

Let's take the ``mytheme`` example theme shown above. This is how the theme is structured:

    mytheme/
       |- images
       |    |- whatever.png
       |    |- foo.jpg
       |- javascripts
       |    |- whatever.js
       |- LICENSE
       |- README
       |- stylesheets/
       |    |- application.css
       |    |- whatever.css
       |- views
            |- pages
            |    |- show.html.erb
            |    |- index.html.erb
            |- layouts
                 |- application.html.erb

   
### Images

Usually this would be just what you have in ``public/images`` except we move that to the theme instead.

### Javascripts

Same with javascripts, just what you normally have in ``public/javascripts`` but in this theme directory instead.

### Readme

The ``README`` file is just a description of your theme.

### Views

This is exactly the same as how you lay your views out in ``app/views/`` just instead of putting them in ``app/views/`` you put them into ``themes/mytheme/views/``

## How do I make my own Theme?

Simply use the Theme generator to make the basic structure of a new theme.

    ruby script/generate refinery_theme name_of_theme

Don't forget to "activate" this new theme by setting the theme setting to the name of this new theme.

## How do I select which Theme Refinery should use?

In the admin area of Refinery go to the "Settings" area, locate the setting called "theme" and edit it.

Set the value of that setting to the name of your themes folder. For example, if your theme is sitting in:

    themes/my_theme

set it to ``my_theme`` and hit save.

## How do I install someone else's Theme?

Just copy their theme directory into your themes folder and Refinery will see it.

## How can I Convert my Current Views into a Theme?

This should be fairly straightforward, just follow the directory structure outlined in 'The structure of a Theme'. 

But there is one important difference that need to be addressed to convert your current site into a theme.

If you have some CSS which refers to an image or URL:

    #footer {
      background: url('/images/footer_background.png') repeat-x;
    }

You need to update the URL so it requests ``/theme/images/`` instead of just ``/images``. This tells Refinery we need to actually load this image from the theme and not just the public directory.

So the result is simply:

    #footer {
      background: url('/theme/images/footer_background.png') repeat-x;
    }

This is the same with linking to Javascript and Stylesheets in your view. Say our ``application.html.erb`` layout had something like this:

    <%= stylesheet_link_tag 'application' %>

You just need to change that to:

    <%= stylesheet_link_tag 'application', :theme => true %>
    
## I'm Stuck, is there an Example Theme?

Yep, there is an example theme called "demolicious" that comes with Refinery located in ``/themes/demolicious``. If you find yourself getting stuck, just check out that theme and get a feel for how it works.