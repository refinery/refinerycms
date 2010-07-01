# Pages

![Refinery Pages](http://refinerycms.com/system/images/0000/0656/pages.png)

## About

One core part of Refinery is Pages. Plugins such as News and Inquiries hook to pages. The menu is rendered based off the structure of your pages.

Pages have one key thing about them that is unique - page parts.

## Page Parts

![Refinery Page Parts](http://refinerycms.com/system/images/0000/0586/editing-page.png)

### What are they?

Think of a page part is a single piece of content on your page. At [Resolve Digital](http://www.resolvedigital.co.nz) we often simply use ``body`` and ``side_body``. One is for the main content and one is for the content which goes on a side bit of the page to display other information.

### Default Page Parts

You can change what the default page parts are called or add more by editing the "Default Page Parts" setting. This is a serialized array of names. The default looks like this

    ---
    - Body
    - Side Body

Edit this setting to suit your taste.

### Adding Page Parts for Specific Pages

You can add extra page parts to your pages by setting the "New Page Parts" to ``true``.

Now do this

* Edit the page you want to add a part to
* Click the little "+" icon up by the page part tabs
* Type the name of your new part and hit add.

_Note: in the user-facing front end we call them "content sections" not "page parts"._

## Page Options

### Draft/Published

You can have draft and published pages. This is controlled by checking and unchecking the "Save as Draft" field on the page form, when editing the page.

### Custom Title

There are three options for how the page title will be rendered on the front end.

* ``None``: will just default to the page title
* ``Text``: allows you to have a different name for the page in the backend to the front end (sometimes good for SEO)
* ``Image``: If your designer is using a custom non-standard web font, this is ideal. Bang the image of your title right in there (_we don't recommend this though! Standard web fonts are always a good idea_)

### Show in Menu

You can hide a page from the navigation if you like by unchecking "show in menu". This is good for extra reference pages or even pages you might want to link someone up to directly but not "advertise" the pages existence on the menu.

### Custom URL

This allows you to make your page not link to a normal page but make it show something else. This could be a donation link to a completely different site or as Refinery uses it, you might want to link to another plugin.

The "contact us" page for example has a Custom URL of ``/contact``, this is because we want it to load the inquiries form from the inquiries plugin instead and we have this ``map.new_inquiry '/contact', :controller => "inquiries", :action => "new"`` in the routes.

### WYMeditor (the visual editor)

Refinery is backed by [WYMeditor](http://www.wymeditor.org/)

It's a standards compliant editor that we've trimmed to only have what we feel is absolutely necessary. When you're editing the content in a page part you're using [WYMeditor](http://www.wymeditor.org/).

We have since modified the source code of WYMeditor to allow for a lot of new features like our custom dialogues however it is all based on the release: WYMeditor 0.5 rc1.

You can also switch to "source" view and edit XHTML manually if the visual editor is not playing nice.

### Custom Selectable Styles in WYMeditor

![Refinery Page Editor Styles](http://refinerycms.com/system/images/0000/0596/editing-page-style.png)

Some sites require a little more than just your standard bold and heading controls. This is where the "css" style drop down comes in handy.

It allows your users to select a style you define. You need to edit/create a CSS file called ``theme.css``.

This file should be located in ``/public/stylesheets/themes.css``

Inside that file you define your styles like this

    .category-name-style-name {
      // apply your CSS rules here
    }

For example, if I wanted to add a style that allowed my users to highlight their text a light yellow colour, I would put this

    .text-highlight-yellow {
      background: LightYellow;
    }

Now edit ``public/javascripts/admin.js``. We're going to need to tell WYMeditor that we have some new styles it should load when the editor is loaded.

Currently your ``admin.js`` file will have something like this

    var custom_wymeditor_boot_options = {

    };

If we open ``public/javascripts/boot_wym.js`` we can see this inside which is the default:

    , classesItems: [
      {name: 'text-align', rules:['left', 'center', 'right', 'justify'], join: '-'}
      , {name: 'image-align', rules:['left', 'right'], join: '-'}
      , {name: 'font-size', rules:['small', 'normal', 'large'], join: '-'}
    ]

Let's just breakdown a single WYMeditor line and understand it:

    {name: 'font-size', rules:['small','normal','large'], join: '-'}

``font-size`` is the name of the category and ``small``, ``normal``, ``large`` are the actual styles. So for this to match up with the styles in my theme.css file the class name has to be:

    .font-size-small { // CSS rules here }
    .font-size-normal { // CSS rules here }
    .font-size-large { // CSS rules here }

So going back to our text highlighting style above, we make the new style show up in the editor by changing our ``admin.js`` file to:

    var custom_wymeditor_boot_options = {
      classesItems: [
        {name: 'text-align', rules:['left', 'center', 'right', 'justify'], join: '-'}
        , {name: 'image-align', rules:['left', 'right'], join: '-'}
        , {name: 'font-size', rules:['small','normal','large'], join: '-'}
        , {name: 'text-highlight', rules:['yellow'], join: '-'}
      ]
    }

### Dialogs that show from WYMeditor

![Refinery Page Editor Link Dialog](http://refinerycms.com/system/images/0000/0636/link-dialog.png)

## Page Link dialog

The link dialog lets you link in several different ways:

* To an internal page
* To an external page
* To an email address
* To a resource you've uploaded in the Resources tab.

## Insert Image dialog

Simply lets you select from an existing image found in the Images tab or upload a new one right within the dialog.

## Refinery Default Pages

Some pages you have to keep in order for Refinery to stay fully functional:

* Page not found - the default 404 page
* Down for maintenance - renders when you're site is being updated.