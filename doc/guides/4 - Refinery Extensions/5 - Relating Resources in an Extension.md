# Relating Resources in an Extension

This guide will show you how to:

* Properly relate two models in a Refinery Extension that you have created
* Create a drop-down select box in one Refinery Page that relates to data in another Refinery engine model

__WARNING__: This only works on Refinery versions 3.0.0 and greater.

__WARNING__: This guide assumes you have followed the [Multiple Resources in an Extension](/guides/multiple-resources-in-an-extension/) guide.

## Generate your extension

Follow the instructions in [Multiple Resources in an Extension](/guides/multiple-resources-in-an-extension/) guide to create your own extension.

At this point we will assume that you have created the `events` engine which contains an `Event` model and a `Places` model.

Now, what if you wanted to add an `EventType` model, and you wanted to have an event type drop-down on the __edit event__ page? Let's set that up properly.

To add your `EventType` model, run the following command.

```shell
 $ rails g refinery:engine event_type name:string --extension events --namespace events
```

__TIP__: You can additionally specify `--pretend` to simulate generation, so you may inspect the outcome without actually modifying anything.

Notice the last arguments (`--extension <extension_name> --namespace <extension_name>`). This is how Refinery knows which extension to insert your new code. The `--namespace` argument is necessary because Refinery will create a namespace for your extension by default. If you don't specify one, it's the name of the first scaffold you created. In this
case, the namespace is `events`.

Running this command will produce the following output:

```shell
   identical  vendor/extensions/events/tasks/rspec.rake
   identical  vendor/extensions/events/tasks/testing.rake
      create  vendor/extensions/events/app/models/refinery/events/event_type.rb
      create  vendor/extensions/events/app/controllers/refinery/events/event_types_controller.rb
      create  vendor/extensions/events/app/controllers/refinery/events/admin/event_types_controller.rb
      create  vendor/extensions/events/app/views/refinery/events/admin/event_types/index.html.erb
      create  vendor/extensions/events/app/views/refinery/events/admin/event_types/edit.html.erb
      create  vendor/extensions/events/app/views/refinery/events/admin/event_types/_event_type.html.erb
      create  vendor/extensions/events/app/views/refinery/events/admin/event_types/_records.html.erb
      create  vendor/extensions/events/app/views/refinery/events/admin/event_types/_form.html.erb
      create  vendor/extensions/events/app/views/refinery/events/admin/event_types/new.html.erb
      create  vendor/extensions/events/app/views/refinery/events/admin/event_types/_event_types.html.erb
      create  vendor/extensions/events/app/views/refinery/events/admin/event_types/_sortable_list.html.erb
      create  vendor/extensions/events/app/views/refinery/events/admin/event_types/_actions.html.erb
      create  vendor/extensions/events/app/views/refinery/events/event_types/index.html.erb
      create  vendor/extensions/events/app/views/refinery/events/event_types/show.html.erb
      create  vendor/extensions/events/config/locales/tmp/cs.yml
      create  vendor/extensions/events/config/locales/tmp/nb.yml
      create  vendor/extensions/events/config/locales/tmp/es.yml
      create  vendor/extensions/events/config/locales/tmp/sk.yml
      create  vendor/extensions/events/config/locales/tmp/it.yml
      create  vendor/extensions/events/config/locales/tmp/en.yml
      create  vendor/extensions/events/config/locales/tmp/ru.yml
      create  vendor/extensions/events/config/locales/tmp/fr.yml
      create  vendor/extensions/events/config/locales/tmp/tr.yml
      create  vendor/extensions/events/config/locales/tmp/zh-CN.yml
      create  vendor/extensions/events/config/locales/tmp/nl.yml
      create  vendor/extensions/events/config/tmp/routes.rb
   identical  vendor/extensions/events/spec/spec_helper.rb
      create  vendor/extensions/events/spec/features/refinery/events/admin/event_types_spec.rb
      create  vendor/extensions/events/spec/models/refinery/events/event_type_spec.rb
      create  vendor/extensions/events/spec/support/factories/refinery/event_types.rb
   identical  vendor/extensions/events/refinerycms-events.gemspec
   identical  vendor/extensions/events/script/rails
   identical  vendor/extensions/events/readme.md
   identical  vendor/extensions/events/Rakefile
   identical  vendor/extensions/events/lib/tasks/refinery/events.rake
      create  vendor/extensions/events/lib/tmp/refinerycms-events.rb
      create  vendor/extensions/events/lib/refinery/event_types.rb
      create  vendor/extensions/events/lib/refinery/event_types/engine.rb
   identical  vendor/extensions/events/lib/generators/refinery/events_generator.rb
      create  vendor/extensions/events/db/migrate/3_create_events_event_types.rb
   identical  vendor/extensions/events/Gemfile
------------------------
Now run:
bundle install
rails generate refinery:events
rake db:migrate
rake db:seed
Please restart your rails server.
------------------------
```

__WARNING__: If you are presented with a conflict in the `events_generator.rb` file, say no! This happens at the moment because Refinery thinks you are generating a Places extension, and this may cause all kinds of havoc if you agree to it. If you have accidentally agreed to it, you can revert that file, and check your `db/seeds.rb` file to see if you have accidentally appended an additional line reading `Refinery::Events::Engine.load_seed`.

Run the commands listed above to actually create your files and migrate the database.

## Linking Event to EventType in our database

Since we've already created the `Event` model (as part of the "Multiple Resources..." guide), we'll have to manually add the`event_type_id` column to the `refinery_events` table:

```shell
$ rails generate migration AddEventTypeToRefineryEvents event_type_id:integer
```

invoke active_record create `db/migrate/20130409125232_add_event_type_to_refinery_events.rb`

```shell
$ rake db:migrate
```

## Linking the models in our engine

Now that we have an `EventType` model, we need to tell Rails how these are linked:

Open up `vendor/extensions/events/app/models/refinery/events/event_type.rb` and look at its contents:

```ruby
module Refinery
  module Events
    class EventType < Refinery::Core::BaseModel


      validates :name, :presence => true, :uniqueness => true

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end

```

All of the Rails code in the model should be correct, but we need to tell Rails of the has_many relationship between an `EventType` and an `Event`. Add the `has_many` line so it appears as:

```ruby
module Refinery
  module Events
    class EventType < Refinery::Core::BaseModel


      validates :name, :presence => true, :uniqueness => true

      has_many :events

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
    end
  end
end
```

Naturally, there is also a belongs_to relationship between an `Event` and an `EventType` (an `Event` belongs_to an `EventType`).

Open up `vendor/extensions/events/app/models/refinery/events/event.rb` and look at its contents:

```ruby
module Refinery
  module Events
    class Event < Refinery::Core::BaseModel
      self.table_name = 'refinery_events'


      validates :title, :presence => true, :uniqueness => true

      belongs_to :photo, :class_name => '::Refinery::Image'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
```

Add the `belongs_to` line so the code appears as:

```ruby
module Refinery
  module Events
    class Event < Refinery::Core::BaseModel
      self.table_name = 'refinery_events'


      validates :title, :presence => true, :uniqueness => true

      belongs_to :photo, :class_name => '::Refinery::Image'
      belongs_to :event_type

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
```

## Modifying the Controller to gather information for our sub-table

Ultimately, we will need some collection of "event types" in our `Events` view... that collection is what we'll use to create the select box. So, to make that happen, the best (and most proper) way is to modify the `Events` controller so that it automatically creates an `@event_types` variable that we'll use in the view.

Open up `vendor/extensions/events/app/controllers/refinery/events/admin/events_controller.rb` and look at its contents:

__WARNING__: Be sure you are looking at the `/events/admin/events_controller` not the `/events/events_controller`!

```ruby
module Refinery
  module Events
    module Admin
      class EventsController < ::Refinery::AdminController

        crudify :'refinery/events/event'

        private

        # Only allow a trusted parameter "white list" through.
        def event_params
          params.require(:event).permit(:title, :date, :photo_id, :blurb)
        end
      end
    end
  end
end
```

Now, add a function to `find_all_event_types`, and call that function in a `before_action`. The `@event_types` variable will be needed in all actions that utilize the `vendor/extensions/events/app/views/refinery/events/admin/events/_form.rb`
partial (all actions except `:show` and `:destroy`).

Don't forget to permit the `:event_type_id` in the `event_params` method.

Your controller should look like this when you are done:

```ruby
module Refinery
  module Events
    module Admin
      class EventsController < ::Refinery::AdminController

        before_action :find_all_event_types, except: [:show, :destroy]

        crudify :'refinery/events/event'

        protected

        def find_all_event_types
          @event_types = Refinery::Events::EventType.all
        end

        private

        # Only allow a trusted parameter "white list" through.
        def event_params
          params.require(:event).permit(:title, :date, :photo_id, :blurb, :event_type_id)
        end
      end
    end
  end
end
```

## Modifying the View to display and store the sub-table select box

You are almost done! Just have to put the code in your view that will display the select box. This is the easiest part:

Open up `vendor/extensions/events/app/views/refinery/events/admin/events/_form.rb`. In that file, wherever you want your select box to appear, simply add this rails code below (we added ours between the `:title` and `:date` sections):

```ruby
<div class="field">
  <%= f.label :event_type -%>
  <%= f.select(:event_type_id, @event_types.collect { |d| [d.name, d.id] })%>
</div>
```

That should be all you need.

Try it out: Login to refinery and first add some event types.

Then go to the Events edit page and you should see the Event Type select box and it should be populated with the event types you have defined.

Choose an event type, save your record, and double-check that your selection is persisted in the database.
