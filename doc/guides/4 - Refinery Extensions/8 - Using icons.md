# Icons

Refinery 3.0 is using icons from [Font Awesome](http://fortawesome.github.io/Font-Awesome/icons/) in its backend screens and will be extending the use of these icons.

You can use the icons in your views too.

## Which icons?

The complete set of FontAwesome icons V 4.3 are included in the font files. If you use the FontAwesome recommended markup you can use these directly in your views. The most simple (if not semantic) usage might be

```html
  <i class="fa fa-camera-retro"></i>
```

which will show a camera icon.

## Using the icons in an extension

### Using icons Refinery has already defined

Refinery's icons are defined in `refinerycms/core/app/assets/stylesheets/refinery/_icons.scss`. This file also includes some icon mixins.

Using the pre-defined icons in an extension's backend is easy.

To add the close icon (actually the fontAwesome icon `times-circle`) give an element the class `close_icon`.

```html
  <a href='#' class='close_icon'>Close</a>
```

Refinery also has some helpers to generate links with icons, labels and tooltips. The action icons seen in refinery - Edit, Delete, Preview and Add/New use these helpers. A typical usage is:

```erb
  <%= action_icon(:preview, page.url, t('.view_live_html')) %>
  <%= action_label :add, insert_link, t('.no_resource_selected'), {id: add_resource_id, class: add_class } %>
```

The calls are

```ruby
action_icon(action, url, title, options)
action_label(action, url, title, options)
```

`options` is a hash which can include class, id and anything else that `link_to` will use.

`title` is used as part of the link in `action_label` but will become a tooltip for `action_icon`.

### Define new icon classes and change icon size and colour

The `icon` mixin (defined in `refinerycms/core/app/assets/stylesheets/refinery/_icons.scss`) can be used to define extra icon_classes or to change the appearance of Refinery icons.

```sass
mixin icon($icon-selector, $color: $icon_default_colour, $padding: 4px, $size: 1.2em, $float: none)
```

__For the frontend__: if you use `application.css` you __will__ need to change it's name to `application.scss`. Move your current css code into a SASS partial. In this example I will assume that your css has been moved into `_main.scss`.

__For the backend__: Your backend css __must__ be in an SCSS (or SASS) file. I will assume your css has been moved into `_main.scss` and that we will be using `refinerycms-gadgets.scss` as the master stylesheet.

__NOTE__: Rails now recommends that stylesheets use a plain `.sass` or `.scss` file type.

__NOTE__: SCSS is a superset of CSS so you can rename your css to scss without changing the content.

The following sass file gives anything with the class of `gadget_icon` the `retro-camera` icon.
The import statements must be at the start of any standalone SASS file that is going to import or define icons.

```sass
// vendor/extensions/refinerycms-gadgets/app/assets/stylesheets/refinery/refinerycms-gadgets.scss
// or... app/assets/stylesheets/application.scss

// these partials will be imported from Refinery
@import 'refinery/mixins';
@import 'refinery/colours';
@import 'font-awesome-sprockets', 'font-awesome';
@import 'refinery/icons';

// local imports
@import 'main';
@import 'iconify';
```

```sass
// _iconify.scss
.gadget_icon {@include icon('camera-retro')}
```

```sass
// _main.scss
ul#gadgets {
 background-color: black;
  li {
    @extend .gadget_icon   // or @include icon('camera-retro')
    a {color: CadetBlue;}
}
```

![](https://raw.githubusercontent.com/refinery/refinerycms/master/doc/guides/4%20-%20Refinery%20Extensions/Gadgets.png)

Dissatisfied with the standard Refinery icon colour (black) and size (1.2em)? Change the icon size and colour.

```sass
.gadget_icon {@include icon('camera-retro', $color: DodgerBlue, $size:1.5em)}

```

![](https://raw.githubusercontent.com/refinery/refinerycms/master/doc/guides/4%20-%20Refinery%20Extensions/GadgetsLargeBlue.png)

## The icons

At initial release the following icons were available:

![](https://raw.githubusercontent.com/refinery/refinerycms/master/doc/guides/4%20-%20Refinery%20Extensions/Icons.png)