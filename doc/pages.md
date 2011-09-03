# Pages

![Refinery Pages](http://refinerycms.com/system/images/0000/0656/pages.png)

## About

One core part of Refinery is Pages. Plugins such as News and Inquiries hook to pages.
The menu is rendered based off the structure of your pages.

Pages have one key thing about them that is unique - page parts.

## Page Parts

![Refinery Page Parts](http://refinerycms.com/system/images/0000/0586/editing-page.png)

### What are they?

Think of a page part is a single piece of content on your page. At [Resolve Digital](http://www.resolvedigital.com) we often simply use ``body`` and ``side_body``. One is for the main content and one is for the content which goes on a side bit of the page to display other information.

### Default Page Parts

You can change what the default page parts are called or add more by editing the
"Default Page Parts" setting. This is a serialized array of names. The defaults look like:

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

You can have draft and published pages. This is controlled by checking and unchecking
the "Save as Draft" field on the page form, when editing the page.

### Custom Title

There are two options for how the page title will be rendered on the front end.

* ``None``: will just default to the page title
* ``Text``: allows you to have a different name for the page in the backend to the front end (sometimes good for SEO)

### Show in Menu

You can hide a page from the navigation if you like by unchecking "show in menu".
This is good for extra reference pages or even pages you might want to link someone
up to directly but not "advertise" the pages existence on the menu.

### Custom URL

This allows you to make your page not link to a normal page but make it show something else.
This could be a donation link to a completely different site or as Refinery uses it,
you might want to link to another plugin.

The "contact us" page for example has a Custom URL of ``/contact``, this is
because we want it to load the inquiries form from the inquiries plugin instead
and we have this ``match '/contact', :to => 'inquiries#new', :as => 'new_inquiry'``
in the routes.

### WYMeditor (the visual editor)

Refinery is backed by [WYMeditor](http://www.wymeditor.org/).

You can read about how this is integrated in our [WYMeditor documentation](../doc/wymeditor.md)

## Refinery Default Pages

Some pages you have to keep in order for Refinery to stay fully functional:

* Home page - the page that has ``link_url`` to ``root_url`` (normally /)
* Page not found - the default 404 page
