Extending Models with Decorators
--------------------------------

Sometimes you will want to graft in extra functionality that requires
extra data to be stored in your model. This guide will show you how to:

-   Extend an existing model in order to add a new field;
-   Modify views through overrides

endprologue.

### Model Decorators

In some situations, you may find it necessary to extend the existing
models that come with Refinery. This will enable you to add additional
functionality without resorting to overriding the model itself (an act
which can break patch-level upgrades) or without resorting to
duplicating the functionality of the existing models.

Model decorators are almost identical to [controller
decorators](/guides/extending-controllers-and-models-with-decorators).
The only difference, in fact, is in the name of the constant on which to
invoke *class\_eval* on. Keep in mind that adding an additional stored
field will require you to create a new migration to update your
database, too. If you are simply adding a convenience method on a model
that doesn’t change the database, this will obviously not apply.

In this example, we will add a background image to the Page model. Our
use case is to allow an administrator to set a different background per
page. To track this data, we will need to generate a migration:

<shell>\
 \$ rails g migration AddBackgroundImageToRefineryPages
background\_image\_id:integer\
</shell>

Open up the file that Rails has created for you, and make sure it looks
something like this:\
<ruby>\
class AddBackgroundImageToRefineryPages < ActiveRecord::Migration
  def change
    add_column :refinery_pages, :background_image_id, :integer
  end
end
</ruby>

The important things to note, above:

1.  *:refinery\_pages* is the actual name of the Page model’s database
    table (you can find this out in Rails console by typing
    *Refinery::Page.table\_name*);
2.  *:background\_image\_id* is the column name under which we store the
    foreign key pointing to a *Refinery::Image*.

Save any changes you need to make to the migration file.

Next, run:

<shell>\
 \$ rake db:migrate\
</shell>

… to update your schema.

### Create a Decorator

Create a new file in the *decorators/models/refinery* directory called
*page\_decorator.rb*:

<ruby>

1.  Open the Refinery::Page model for manipulation\
    Refinery::Page.class\_eval do\
     \# Add an association to the Refinery::Image class, so we\
     \# can take advantage of the magic that the class provides\
     belongs\_to :background\_image, :class\_name =&gt;
    ‘::Refinery::Image’\
    end\
    </ruby>

There is some additional explanation needed for the following line:

<ruby>\
Refinery::Page.class\_eval do … end\
</ruby>

This is what opens the model to manipulation. This essentially tells
Ruby to reopen the model as if you were writing methods inside the class
itself. Anything between the “do” and “end” will change the way the
model works. You can even re-define existing methods and these will take
precedence over the previously-written ones.

After saving, the Page model can now relate to a background image, but
there is no way update or save the *background\_image\_id* yet.

Next, to whitelist the *:background\_image\_id*, we need to ‘permit’ the
param in the controller.

Create a new file in the *decorators/controllers/refinery/admin*
directory called *pages\_controller\_decorator.rb*:

<ruby>

1.  Open the Refinery::Admin::PagesController controller for
    manipulation\
    Refinery::Admin::PagesController.class\_eval do\
     def page\_params\_with\_my\_params\

    page\_params\_without\_my\_params.merge(params.require(:page).permit(:background\_image\_id))\
     end\
     alias\_method\_chain :page\_params, :my\_params\
    end\
    </ruby>

*alias\_method\_chain* will alias the normal *page\_params* method to
our newly defined method *page\_params\_with\_my\_params* and will alias
the old *page\_params* to *page\_params\_without\_my\_params*. This
enables us to add additional params to be permitted without having to
override Refinery’s defined *page\_params* method.

After saving, the admin pages controller can now use the Page model to
store a background image, but there is no way to associate an image
through the administrative interface.

### Adding an Image Picker

In the console, run the following:

<shell>\
\$ rake refinery:override view=refinery/admin/pages/\_form\
</shell>

After a few moments, you should see something that states that
*\_form.html.erb has been copied into app/views/refinery/admin/pages*.

Open that file in your editor of choice. After the existing fields,
insert the following:

<ruby>

<div class="field">
<%= f.label :background_image %>\
 <%= render :partial => “/refinery/admin/image\_picker”, :locals =&gt;
{\
 :f =&gt; f,\
 :field =&gt; :background\_image\_id,\
 :image =&gt; f.object.background\_image,\
 :toggle\_image\_display =&gt; false\
 }\
 %&gt;

</div>
</ruby>

This code simply adds a label for :background\_image, then uses
Refinery’s built-in image picker partial to add the field.\
Note that *:field* must point at the *:background\_image\_id* or
whatever you have named your foreign key, and *:image* points at the
*background\_image* object.

### Adding the Background Image on the User Side

You can save a background image for each Page in your site, but now you
have to display it!

In one of your template partials or layouts, you need to add something
along these lines:

<ruby>\
<% content_for :stylesheets do %>\
 <% if @page.background_image.present? %>

<style type="text/css">
body {\
 background-image: url(<%= @page.background_image.url -%>);\
 }

</style>
<% end %>\
<% end %>\
</ruby>

This is, of course, just one way you could take advantage of model
decoration. It should give you an idea of the flexibility of decorators
in conjunction with the existing Refinery models. To note: it is
considered best practice to use decorators to change Refinery models,
but it is also considered best practice not to use decorators when you
are editing your own engines. Instead, make your modifications inside
*vendor/extensions/<your_engine>*.
