# Themes

![Refinery Dashboard](http://refinerycms.com/system/images/0000/0576/dashboard.png)

## Introduction

__Themes allow you to wrap up the design of your Refinery site into a single folder that is portable.__

Refinery doesn't force you to learn a special templating language, but rather just uses the regular
ERB views you're used to in Rails. This means creating a theme from your existing site is extremely easy.

Think of a theme as your ``app/views`` directory with a few extra things like images, css and javascript.

It's worth noting you don't need to use a theme if you don't want to. Placing files in the ``app/views`` directory like any other Rails app will work just fine. It's only if you want to wrap your design up into a single location that you would use a theme or allow your client to easily change designs.

## The structure of a theme

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

So let's take the ``mytheme`` example theme shown above. This is how the theme is structured:

    mytheme/
       |- images
       |    |- whatever.png
       |    |- foo.jpg
       |- javascripts
       |    |- whatever.js
       |- LICENSE
       |- preview.png
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

Same with javascripts, just what you normally have in ``public/javascripts`` just in this theme directory instead.

### Readme

The ``README`` file is just a description of your theme.

### Views

This is exactly the same as how you lay your views out in app/views/ just instead of putting them in ``app/views/`` you put them into ``themes/mytheme/views/``

### Preview Image

The ``preview.png`` image is used when selecting the theme in the backend. It must be a png and ideally is 135x135 pixels.

## How do I make my own theme?

Create a folder with the name if your theme inside ``/themes`` e.g. ``/themes/mytheme`` and follow the directory structure outlined in 'The structure of a theme'.

## How do I select which theme Refinery should use?

In the admin area of Refinery go to the "Settings" area, locate the setting called "theme" and edit it.

Set the value of that setting to the name of your themes folder. For example if your theme is sitting in:

    themes/my_theme

set it to ``my_theme`` and hit save.

## How do I zip my theme to use it on other sites

If you want to share a theme and install it on another site you have to zip it first.

It's important to note you don't zip the theme's directory itself just the contents.

If I had a theme sitting in:

    themes/mytheme/[theme files here]

The zip file would look like this

    mytheme.zip
      |- [theme files here]

Read 'How do I install someone else's theme?' to take that zip file and install the theme.

## How do I install someone else's theme?

If you have the themes plugin added to your admin user, you should see in the admin area of Refinery a "Themes" tab in the main navigation. Click on that, then click "Upload new theme". Upload the theme zip file and then click on the "star" below the preview image for the theme to activate that theme as the one to use right now.

## How can I convert my current views into a theme?

This should be fairly straightforward just following the directory structure outlined in 'The structure of a theme'. 

But there is one important difference that need to be addressed to convert your current site into a theme.

If you have some CSS which refers to an image or URL:

    #footer {
      background: url('/images/footer_background.png') repeat-x;
    }

You need to update the URL so it requests /images/themes instead of /images. This tells Refinery we need to actually load this image from the theme and not just the public directory.

So the result is simply:

    #footer {
      background: url('/images/theme/footer_background.png') repeat-x;
    }

This is the same with linking to Javascript and Stylesheets in your view. Say our ``application.html.erb`` layout had something like this:

    <%= stylesheet_link_tag 'application' %>

You just need to change that to:

    <%= stylesheet_link_tag 'theme/application' %>