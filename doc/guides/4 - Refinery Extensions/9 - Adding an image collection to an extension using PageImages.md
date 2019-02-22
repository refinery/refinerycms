# Adding Multiple Images to your Model

Refinery offers a generator which allows an engine/model to have fields which are single images. It doesn't supply anything out-of-the-box to allow a model to have a collection of images.

However Refinery has a plugin `refinerycms-page-images` which implements an image collection for the `Refinery::Page` model.

It is relatively straight-forward to use this plugin to add an image collection to your model.

*Thanks to [Prokop Simek](:https://github.com/prokopsimek) who detailed this method [here](:https://github.com/refinery/refinerycms-page-images/issues/111).*

## What you get

When you have completed these steps your model/engine you will be able to add and remove images from an instance of your model using the same tabbed interface used by `Refinery::Pages`.

In a view you will have access to a collection of images (`@model.images`).

## Pre-requisites

* Refinerycms
* Refinerycms-page-images
* an engine or extension to work with (the examples will use `Shows`)

## Configure refinerycms-page-images

Edit the config file `app/config/initializers/refinery/page/images.rb`:

```ruby
Refinery::PageImages.configure do |config|
  config.captions = true

  config.enable_for = [
    { model: "Refinery::Page", tab: "Refinery::Pages::Tab" },
    { model: "Refinery::Show", tab: "Refinery::Shows::Tab" }
  ]

  config.wysiwyg = true
end
```

## Add page-images to your model

Add `has_many_page_images` line to the model in `vendor/extensions/shows/app/models/refinery/shows/show.rb`.

## Define Tabs

Create the tab class in `vendor/extensions/shows/lib/refinery/shows/tabs.rb`:

```ruby
module Refinery
  module Shows
    class Tab
      attr_accessor :name, :partial

      def self.register(&block)
        tab = self.new

        yield tab

        raise "A tab MUST have a name!: #{tab.inspect}" if tab.name.blank?
        raise "A tab MUST have a partial!: #{tab.inspect}" if tab.partial.blank?
      end

      protected

      def initialize
        ::Refinery::Shows.tabs << self # add me to the collection of registered tabs
      end
    end
  end
end
```

## Load and Initialize Tabs

Edit the file `vendor/extensions/shows/lib/refinery/shows.rb`:

```ruby
require 'refinerycms-core'

module Refinery
  autoload :ShowsGenerator, 'generators/refinery/shows_generator'

  module Shows
    require 'refinery/shows/engine'

    autoload :Tab, 'refinery/shows/tabs'

    class << self
      attr_writer :root
      attr_writer :tabs

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def tabs
        @tabs ||= []
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end
```

## Modify the admin view

__TIP__: You may add custom fields like `blurb` and add the support inside the `form_part` partial.

Add a new field to the form in `vendor/extensions/shows/app/views/refinery/admin/_form.html.erb`:

```erb
<div class='field'>
  <div id='page-tabs' class='clearfix ui-tabs ui-widget ui-widget-content ui-corner-all'>
    <ul id='page_parts'>
      <li class='ui-state-default ui-state-active'>
        <%= link_to t('blurb', :scope => 'activerecord.attributes.refinery/shows/show'), "#page_part_blurb" %>
      </li>

      <% Refinery::Shows.tabs.each_with_index do |tab, tab_index| %>
        <li class='ui-state-default' id="custom_<%= tab.name %>_tab">
          <%= link_to tab.name.titleize, "#custom_tab_#{tab_index}" %>
        </li>
      <% end %>
    </ul>

    <div id='page_part_editors'>
      <% part_index = -1 %>
      <%= render 'form_part', :f => f, :part_index => (part_index += 1) -%>

      <% Refinery::Shows.tabs.each_with_index do |tab, tab_index| %>
        <div class='page_part' id='<%= "custom_tab_#{tab_index}" %>'>
          <%= render tab.partial, :f => f %>
        </div>
      <% end %>
    </div>
  </div>
</div>
```

Create the `form_part` partial in `vendor/extensions/shows/app/views/refinery/admin/_form_part.html.erb`:

```erb
<div class='page_part' id='page_part_blurb'>
  <%= f.text_area :blurb, :rows => 20, :class => 'visual_editor widest' -%>
</div>
```

## Add strong parameters for the new fields

### Write a decorator

Create the decorator in `vendor/extensions/shows/app/decorators/controllers/refinery/admin/shows_controller_decorator.rb`:

```ruby
Refinery::Shows::Admin::ShowsController.prepend(
  Module.new do
    def permitted_show_params
      super << [images_attributes: [:id, :caption, :image_page_id]]
    end
  end
)
```

### Tell the Controller to Permit the new parameters it must handle

__TIP__: It doesn't change the controller itself, but makes it easier to extend the initial list of permitted fields. Later versions of Refinery may generate this automatically.

Edit the controller `vendor/extensions/shows/app/controllers/refinery/shows/admin/shows_controller.rb`:

```ruby
module Refinery
  module Shows
    module Admin
      class ShowsController < ::Refinery::AdminController

        crudify :'refinery/shows/show'

        private

        def show_params
          params.require(:show).permit(permitted_show_params)
        end

        # Only allow a trusted parameter "permit list" through.
        def permitted_show_params
          [:title, :blurb]
        end

      end
    end
  end
end
```

## Add captions

Create the model decorator and define images collection with captions in `vendor/extensions/shows/app/decorators/models/refinery/show_decorator.rb`:

```ruby
require 'ostruct'

Refinery::Shows::Show.class_eval do
  attr_accessor :images_with_captions

  def images_with_captions
    @images_with_captions = image_pages.map do |ref|
      OpenStruct.new(
        {
          image: Refinery::Image.find(ref.image_id),
          caption: ref.caption || ''
        }
      )
    end
  end
end
```

__TIP__: See further usage [here](https://github.com/refinery/refinerycms-page-images#usage).
