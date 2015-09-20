Relating Resources in an Extension
----------------------------------

This guide will show you how to:

-   Properly relate two models in a Refinery Extension that you have
    created
-   Create a drop-down select box in one Refinery Page that relates to
    data in another Refinery engine model

endprologue.

WARNING: This only works on Refinery versions 2.0.0 and greater.\
WARNING: This guide assumes you have followed the “Multiple Resources in
an Extension” guide

#### Generate your extension

Follow the instructions in “Multiple Resources in an Extension” guide to
create your own extension.

At this point we will assume that you have created the “events” engine
which contains an Event model and a Places model.

Now, what if you wanted to add an “Event Type” model, and you wanted to
have an event type drop-down on the “edit event” page? Let’s set that up
properly.

To add your EventType model, run the following command.

<shell>\
 \$ rails g refinery:engine event\_type name:string —extension events
—namespace events\
</shell>

TIP: You can additionally specify *—pretend* to simulate generation, so
you may inspect the outcome without actually modifying anything.

Notice the last arguments (*—extension <extension_name> —namespace
<extension_name>*). This is how Refinery knows which extension to insert
your new code. The *—namespace* argument is necessary because Refinery
will create a namespace for your extension by default. If you don’t
specify one, it’s the name of the first scaffold you created. In this
case, the namespace is *events*.

Running this command will produce the following output:

<shell>\
 identical vendor/extensions/events/Gemfile\
 identical vendor/extensions/events/Guardfile\
 identical vendor/extensions/events/Rakefile\
 create
vendor/extensions/events/app/controllers/refinery/events/admin/event\_types\_controller.rb\
 create
vendor/extensions/events/app/controllers/refinery/events/event\_types\_controller.rb\
 create
vendor/extensions/events/app/models/refinery/events/event\_type.rb\
 create
vendor/extensions/events/app/views/refinery/events/admin/event\_types/\_actions.html.erb\
 create
vendor/extensions/events/app/views/refinery/events/admin/event\_types/\_form.html.erb\
 create
vendor/extensions/events/app/views/refinery/events/admin/event\_types/\_event\_types.html.erb\
 create
vendor/extensions/events/app/views/refinery/events/admin/event\_types/\_records.html.erb\
 create
vendor/extensions/events/app/views/refinery/events/admin/event\_types/\_event\_type.html.erb\
 create
vendor/extensions/events/app/views/refinery/events/admin/event\_types/\_sortable\_list.html.erb\
 create
vendor/extensions/events/app/views/refinery/events/admin/event\_types/edit.html.erb\
 create
vendor/extensions/events/app/views/refinery/events/admin/event\_types/index.html.erb\
 create
vendor/extensions/events/app/views/refinery/events/admin/event\_types/new.html.erb\
 create
vendor/extensions/events/app/views/refinery/events/event\_types/index.html.erb\
 create
vendor/extensions/events/app/views/refinery/events/event\_types/show.html.erb\
 create vendor/extensions/events/config/locales/tmp/en.yml\
 create vendor/extensions/events/config/locales/tmp/es.yml\
 create vendor/extensions/events/config/locales/tmp/fr.yml\
 create vendor/extensions/events/config/locales/tmp/nb.yml\
 create vendor/extensions/events/config/locales/tmp/nl.yml\
 create vendor/extensions/events/config/locales/tmp/sk.yml\
 create vendor/extensions/events/config/locales/tmp/zh-CN.yml\
 create vendor/extensions/events/config/tmp/routes.rb\
 create
vendor/extensions/events/db/migrate/3\_create\_events\_event\_types.rb\
 conflict
vendor/extensions/events/lib/generators/refinery/events\_generator.rb\
Overwrite
/Users/cclogicimac/rails\_projects/cclogic\_app/vendor/extensions/events/lib/generators/refinery/events\_generator.rb?
(enter “h” for help) \[Ynaqdh\] n\
 skip
vendor/extensions/events/lib/generators/refinery/events\_generator.rb\
 create vendor/extensions/events/lib/refinery/event\_types/engine.rb\
 create vendor/extensions/events/lib/refinery/event\_types.rb\
 create vendor/extensions/events/lib/tmp/refinerycms-events.rb\
 identical vendor/extensions/events/lib/tasks/refinery/events.rake\
 identical vendor/extensions/events/refinerycms-events.gemspec\
 identical vendor/extensions/events/script/rails\
 create
vendor/extensions/events/spec/models/refinery/events/event\_type\_spec.rb\
 create
vendor/extensions/events/spec/requests/refinery/events/admin/event\_types\_spec.rb\
 identical vendor/extensions/events/spec/spec\_helper.rb\
 create
vendor/extensions/events/spec/support/factories/refinery/event\_types.rb\
 identical vendor/extensions/events/tasks/rspec.rake\
 identical vendor/extensions/events/tasks/testing.rake\
 remove vendor/extensions/events/config/locales/tmp\
 remove vendor/extensions/events/config/tmp\
 remove vendor/extensions/events/lib/tmp\
————————————\
Now run:\
bundle install\
rails generate refinery:events\
rake db:migrate\
rake db:seed\
————————————\
</shell>

WARNING: If you are presented with a conflict in the
*events\_generator.rb* file, say no! This happens at the moment because
Refinery thinks you are generating a Places extension, and this may
cause all kinds of havoc if you agree to it. If you have accidentally
agreed to it, you can revert that file, and check your *db/seeds.rb*
file to see if you have accidentally appended an additional line reading
*Refinery::Events::Engine.load\_seed*.

Run the commands listed above to actually create your files and migrate
the database.

#### Linking Event to EventType in our database

Since we’ve already created the Event model (as part of the “Multiple
Resources…” guide), we’ll have to manually add the event\_type\_id
column to the refinery\_events table:

<shell>\
rails generate migration AddEventTypeToRefineryEvents
event\_type\_id:integer\
</shell>

invoke active\_record\
create
db/migrate/20130409125232\_add\_event\_type\_to\_refinery\_events.rb

<shell>\
rake db:migrate\
</shell>

#### Linking the models in our engine

Now that we have an EventType model, we need to tell Rails how these are
linked:

Open up
*vendor/extensions/events/app/models/refinery/events/event\_type.rb* and
look at its contents:

<ruby>\
module Refinery\
 module Events\
 class EventType < Refinery::Core::BaseModel

     attr_accessible :name, :position

      acts_as_indexed :fields => \[:name\]

validates :name, :presence =&gt; true, :uniqueness =&gt; true\
 end\
 end\
end\
</ruby>

All of the Rails code in the model should be correct, but we need to
tell Rails of the has\_many relationship between an EventType and an
Event. Add the has\_many line so it appears as:

<ruby>\
module Refinery\
 module Events\
 class EventType < Refinery::Core::BaseModel
      attr_accessible :name, :position

      acts_as_indexed :fields => \[:name\]

validates :name, :presence =&gt; true, :uniqueness =&gt; true

has\_many :events\
 end\
 end\
end\
</ruby>

Naturally, there is also a belongs\_to relationship between an Event and
an EventType (an Event belongs\_to an EventType). We also need to ensure
that event\_type\_id is in the list of attr\_accessible fields,
otherwise it will get ignored during the update.

Open up *vendor/extensions/events/app/models/refinery/events/event.rb*
and look at its contents:

<ruby>\
module Refinery\
 module Events\
 class Event < Refinery::Core::BaseModel
      self.table_name = 'refinery_events'

      attr_accessible :title, :date, :photo_id, :blurb, :position

      acts_as_indexed :fields => \[:title, :blurb\]

validates :title, :presence =&gt; true, :uniqueness =&gt; true

belongs\_to :photo, :class\_name =&gt; ‘::Refinery::Image’\
 end\
 end\
end\
</ruby>

Add the belongs\_to line, and update the attr\_accessible list so the
code appears as:

<ruby>\
module Refinery\
 module Events\
 class Event < Refinery::Core::BaseModel
      self.table_name = 'refinery_events'

      attr_accessible :title, :date, :photo_id, :blurb, :position, :event_type_id

      acts_as_indexed :fields => \[:title, :blurb\]

validates :title, :presence =&gt; true, :uniqueness =&gt; true

belongs\_to :photo, :class\_name =&gt; ‘::Refinery::Image’\
 belongs\_to :event\_type\
 end\
 end\
end\
</ruby>

#### Modifying the Controller to gather information for our sub-table

Ultimately, we will need some collection of “event types” in our Events
view… that collection is what we’ll use to create the select box. So, to
make that happen, the best (and most proper) way is to modify the Events
controller so that it automatically creates an @event\_types variable
that we’ll use in the view.

Open up
*vendor/extensions/events/app/controllers/refinery/events/admin/events\_controller.rb*
and look at its contents:

WARNING: Be sure you are looking at the /events/admin/events\_controller
not the /events/events\_controller!

<ruby>\
module Refinery\
 module Events\
 module Admin\
 class EventsController < ::Refinery::AdminController

        crudify :'refinery/events/event', :xhr_paging => true

end\
 end\
 end\
end\
</ruby>

Now, add a function to “find\_all\_event\_types”, and call that function
in a before\_action. The @event\_types variable will be needed in all
actions that utilize the
*vendor/extensions/events/app/views/refinery/events/admin/events/\_form.rb*
partial (all actions except :show and :destroy). Your controller should
look like this when you are done:

<ruby>\
module Refinery\
 module Events\
 module Admin\
 class EventsController < ::Refinery::AdminController

        before_action :find_all_event_types, :except => \[:show,
:destroy\]

crudify :‘refinery/events/event’, :xhr\_paging =&gt; true

protected

def find\_all\_event\_types\
 @event\_types = Refinery::Events::EventType.all\
 end

end\
 end\
 end\
end\
</ruby>

#### Modifying the View to display and store the sub-table select box

You are almost done! Just have to put the code in your view that will
display the select box. This is the easiest part:

Open up
*vendor/extensions/events/app/views/refinery/events/admin/events/\_form.rb*.
In that file, wherever you want your select box to appear, simply add
this rails code below (we added ours between the :title and :date
sections):

<ruby>

<div class="field">
<%= f.label :event_type -%>\

<%= f.select(:event_type_id, @event_types.collect { |d| [d.name, d.id] })%>

</div>
</ruby>

That should be all you need. Try it out: Login to refinery and first add
some event types. Then go to the Events edit page and you should see the
Event Type select box and it should be populated with the event types
you have defined. Choose an event type, save your record, and
double-check that your selection is persisted in the database.
