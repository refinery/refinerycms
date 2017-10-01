# Changes to extensions in Refinery 3.0

Some of the changes introduced with Refinery 3.0 affect extensions.

## Icons

Refinery 3.0 uses icons from FontAwesome instead of individual icon images. A full discussion of the changes and how to take advantage of them is in Github issues.

## Assets

If the extension has assets that should always be compiled with the Refinery backend add the following code to the file `extension/config/initializers/refinery/core.rb`.

```ruby
  Refinery::Core.configure do |config|
    # Register extra javascripts for backend
    config.register_javascript "refinerycms-extension.js"

    # Register extra stylesheets for backend
    config.register_stylesheet "refinerycms-extension.css"
  end

  Rails.application.config.assets.precompile += %w( refinerycms-extension.css refinerycms-extension.js )
```

__NOTE 1__: you must specify the __targets__ of the precompile rather than the files you are using. If you are using Coffeescript and SASS you must still add `extension.js` and `extension.css` to the precompile array.

__NOTE 2__: it is a good idea to name your extension's asset files with the full name of your extension. There is less chance of a conflict between the extensions assets and an applications assets. So:

__OK__: gadgets.js, gadgets.scss

__Better__: refinerycms-gadgets.js, refinerycms-gadgets.scss

The innocent developer may well write his own `gadgets.css`, but is unlikely to call his stylesheet `refinerycms-gadgets.css`.

## Decorators and Strong Parameters

Rails 4 requires the use of strong parameters.

If your engine adds fields to a page, blog post or other Refinery object you need to add your fields to the Refinery::Page's (BlogPost, etc) list of accepted parameters.

Here is an example that allows a page to be created or updated with extra fields.

```ruby
module RefineryGadgetsPagesControllerDecorator
  def permitted_page_params
    super <<  [:gadget_enabled, :gadget_count, gadgets:[:id, :name]]
  end
end

Refinery::Admin::PagesController.send :prepend, RefineryGadgetsPagesControllerDecorator
```

## Page Decorators

If an extension is producing an object or collection to be displayed on a page you can use decorators to add the object or collection to the page.

```ruby
# app/decorators/models/refinery/gadgets_page_decorator.rb

# Open the Refinery::Page model for manipulation
Refinery::Page.class_eval do
  attr_accessor :gadgets

  def gadgets
    @gadgets = Gadgets.best(gadget_count) if gadget_enabled
  end
end
```

When it comes to writing a view you can now use `page.gadgets` to access the gadgets collection.
