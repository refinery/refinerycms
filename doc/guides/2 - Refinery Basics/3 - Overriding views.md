# Overriding views

The default HTML Refinery generates on the front-end is sometimes not suitable for your design. This guide will show you how to:

* Override a front-end view in Refinery and replace it with your own version

## Overriding your first view

If you want to override one of the views Refinery comes built with (for example, to add a phone number to the footer), you'll need to override the view Refinery is providing. Refinery will then use your local version, rather than its original copy.

It's easy to get a copy of this file to modify locally. For example, for the footer, run the following command in the terminal:

```shell
$ rake refinery:override view=refinery/_footer.html
```

## Common Examples

These are files we often override when creating a Refinery site.

```shell
$ rake refinery:override view=refinery/pages/show
$ rake refinery:override view=refinery/pages/home
```

## Tips and Tricks

* Trim the `.html.erb` from the end of the view file name
* Only override when you really need to, as it makes upgrading to future versions of Refinery trickier
* You only need the path to the view from inside the `views` folder, regardless of which extension the file is in
* This will also work to override views in extensions you've created locally