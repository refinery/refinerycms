Additional Menus
----------------

This guide will show you how to:

-   configure and use *Refinery::Pages::MenuPresenter*
-   use a decorator to add custom functionality to *Refinery::Page*
    class
-   use a decorator to allow attributes in
    *Refinery::Admin::PagesController*
-   override Refinery’s view

endprologue.

### Requirements

Let’s start with requirements. I tried to bring them together in the
following steps:

-   We need to add an additional navigation menu in the footer section
    of each page right above Refinery’s copyright notice.
-   Admin should be able to specify which pages appear in the footer
    menu, so we also need to add a checkbox under “Advanced options” in
    the page edit form.
-   Data about whether page shows up in the footer should be persisted
    to the database.

Alright, it’s time to dive deep into the code.

### Adding a *show\_in\_footer* column to the *refinery\_pages* database table

The requirement was to persist the data to the database, so we will
start by creating a migration that a will add *show\_in\_footer* column
to the *refinery\_pages* database table. Open up terminal and type:

<shell>\
rails generate migration add\_show\_in\_footer\_to\_refinery\_pages\
</shell>

This will generate an empty migration. Open it and add the following
code:

<ruby>\
class AddShowInFooterToRefineryPages < ActiveRecord::Migration
  def change
    add_column :refinery_pages, :show_in_footer, :boolean, default: false
  end
end
</ruby>

Run the migration:

<shell>\
rake db:migrate\
</shell>

### Decorating the *Refinery::Page* model

We want to decorate the *Refinery::Page* class. Create a file
*app/decorators/models/refinery/page\_decorator.rb* with this content:

<ruby>\
Refinery::Page.class\_eval do\
 def self.footer\_menu\_pages\
 where show\_in\_footer: true\
 end\
end\
</ruby>

We added *footer\_menu\_pages* class method to abstract away
ActiveRecord query method.

### Allow *show\_in\_footer* attribute in *Refinery::Admin::PagesController*

Before overriding Refinery’s form view, we want to decorate the
*Refinery::Admin::PagesController* class. Create a file
*app/decorators/controllers/refinery/admin/pages\_controller\_decorator.rb*
with this content:

<ruby>\
Refinery::Admin::PagesController.prepend(\
 Module.new do\
 def permitted\_page\_params\
 super << :show_in_footer
    end
  end
)
</ruby>

We added *show\_in\_footer* to the permitted attributes list so that it
doesn’t raise a mass-assignment error each time someone tries to save
the page.

### Overriding the form view

As I previously mentioned, let’s make it so that a “Show in footer”
checkbox appears right after Admin expands the “Advanced options” when
editing a page. To do this, we have to override the file
\[\_form\_extra\_fields\_for\_more\_options.html.erb
partial\](https://github.com/refinery/refinerycms/blob/master/pages/app/views/refinery/admin/pages/\_form\_extra\_fields\_for\_more\_options.html.erb).
Type this in the terminal:

<shell>\
rake refinery:override
view=refinery/admin/pages/\_form\_extra\_fields\_for\_more\_options.html\
</shell>

Now open the *\_form\_extra\_fields\_for\_more\_options.html.erb*
partial and add the following code right after the commented line :

<html>
<div class='field'>
<span class='label_with_help'>\
 <%= f.label :show_in_footer, "Show in footer" %>\
 </span>\
 <%= f.check_box :show_in_footer %> Show this page in the footer menu

</div>
</html>
### Creating and configuring the Presenter

Now let’s focus on the presenter itself. Once instantiated, it is also
possible to configure its CSS/HTML using this instance. We will use a
Rails helper to instantiate a new instance of
*Refinery::Pages::MenuPresenter* and also configure it there. We’re
taking this approach because we don’t want to pollute the view with
configuration code.

Open the ApplicationHelper and add this code:

<ruby>\
def footer\_menu\
 menu\_items = Refinery::Menu.new(Refinery::Page.footer\_menu\_pages)

Refinery::Pages::MenuPresenter.new(menu\_items, self).tap do
|presenter|\
 presenter.dom\_id = “footer\_menu”\
 presenter.css = “footer\_menu”\
 presenter.menu\_tag = :div\
 end\
end\
</ruby>

We create an instance of *Refinery::Menu* by passing a collection of
footer pages (*Refinery::Page.footer\_menu\_pages*) to it. We need it
because it will be the data that will be “presented” by
*Refinery::Pages::MenuPresenter*. We assign this instance to a variable
called *presenter* in order to configure this presenter. I want my
footer menu to be wrapped inside of a *div* tag instead of the default
*nav* tag and I also want it to have a CSS class and an ID of
*footer\_menu* instead of the default *menu* one:

<ruby>\
presenter.dom\_id = “footer\_menu”\
presenter.css = “footer\_menu”\
presenter.menu\_tag = :div\
</ruby>

Now that we have configured the menu presenter we need to return it
because we’ll have to call *.to\_html* on it in the view later on.

### Rendering the Menu in the View

Requirement was for the footer menu to appear just above Refinery’s
copyright notice. To do that we will simply override Refinery’s footer
view:

<shell>\
rake refinery:override view=refinery/\_footer.html\
</shell>

Next, add this code in the footer partial, above the existing code:

<erb>\
<%= footer_menu.to_html %>\
</erb>

### Taking a look at it

Now it’s time to take a look at how everything is working. Edit a couple
of pages and for some of them check the “Show in footer” checkbox
located under “Advanced options”. Now go to the root url of your site
and take a look at the bottom; you should see links for the pages for
which you checked the “Show in footer” checkbox. Also here’s how the
generated HTML should look:

<html>
<div class="footer_menu" id="footer_menu">
<ul>
…

</ul>
</div>
</html>

