# WYMeditor (the visual editor)

Refinery is backed by [WYMeditor](http://www.wymeditor.org/)

It's a standards compliant editor that we've trimmed to only have what we feel
is absolutely necessary. When you're editing the content in a page part you're
using [WYMeditor](http://www.wymeditor.org/).

We have since modified the source code of WYMeditor to allow for a lot of new
features like our custom dialogues however it is all based on the release: WYMeditor 0.5 rc1.

You can also switch to "source" view and edit HTML manually if the visual editor is not playing nice.

## Custom Selectable Styles in WYMeditor

![Refinery Page Editor Styles](http://refinerycms.com/system/images/0000/0596/editing-page-style.png)

Some sites require a little more than just your standard bold and heading controls.
This is where the "css" style drop down comes in handy.

It allows your users to select a style you define. You need to edit/create a CSS
file called ``theme.css``.

This file should be located in ``/public/stylesheets/themes.css``

Inside that file you define your styles like this

    .category-name-style-name {
      // apply your CSS rules here
    }

For example, if I wanted to add a style that allowed my users to highlight their
text a light yellow colour, I would put this

    .text-highlight-yellow {
      background: LightYellow;
    }

Now edit ``public/javascripts/admin.js``. We're going to need to tell WYMeditor
that we have some new styles it should load when the editor is loaded.

Currently your ``admin.js`` file will have something like this

    var custom_wymeditor_boot_options = {

    };

If we open ``public/javascripts/boot_wym.js`` we might see the default inside:

    , classesItems: [
      {name: 'text-align', rules:['left', 'center', 'right', 'justify'], join: '-'}
      , {name: 'image-align', rules:['left', 'right'], join: '-'}
      , {name: 'font-size', rules:['small', 'normal', 'large'], join: '-'}
    ]

Let's just breakdown a single WYMeditor line and understand it:

    {name: 'font-size', rules:['small','normal','large'], join: '-'}

``font-size`` is the name of the category and ``small``, ``normal``, ``large``
are the actual styles. So for this to match up with the styles in my theme.css
file the class name has to be:

    .font-size-small { // CSS rules here }
    .font-size-normal { // CSS rules here }
    .font-size-large { // CSS rules here }

So going back to our text highlighting style above, we make the new style show
up in the editor by changing our ``admin.js`` file to:

    var custom_wymeditor_boot_options = {
      classesItems: [
        {name: 'text-align', rules:['left', 'center', 'right', 'justify'], join: '-'}
        , {name: 'image-align', rules:['left', 'right'], join: '-'}
        , {name: 'font-size', rules:['small','normal','large'], join: '-'}
        , {name: 'text-highlight', rules:['yellow'], join: '-'}
      ]
    }

## Dialogs that show from WYMeditor

![Refinery Page Editor Link Dialog](http://refinerycms.com/system/images/0000/0636/link-dialog.png)

### Page Link dialog

The link dialog lets you link in several different ways:

* To an internal page
* To an external page
* To an email address
* To a resource you've uploaded in the Resources tab.

### Insert Image dialog

Simply lets you select from an existing image found in the Images tab or upload
a new one right within the dialog.