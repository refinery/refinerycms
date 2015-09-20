# Additional Menus

This guide will show you how to:

* configure and use `Refinery::Pages::MenuPresenter`
* use a decorator to add custom functionality to `Refinery::Page` class
* use a decorator to allow attributes in `Refinery::Admin::PagesController`
* override Refinery's view

## Requirements

Let's start with requirements. I tried to bring them together in the
following steps:

* We need to add an additional navigation menu in the footer section of each page right above Refinery's copyright notice.
* Admin should be able to specify which pages appear in the footer menu, so we also need to add a checkbox under "Advanced options" in the page edit form.
* Data about whether page shows up in the footer should be persisted to the database.

Alright, it's time to dive deep into the code.

## Adding a `show_in_footer` column to the `refinery_pages` database table

The requirement was to persist the data to the database, so we will start by creating a migration that a will add `refinery_pages` column to the `refinery_pages` database table.

Open up terminal and type:

    rails generate migration add_show_in_footer_to_refinery_pages

This will generate an empty migration. Open it and add the following code:

```ruby
class AddShowInFooterToRefineryPages < ActiveRecord::Migration
  def change
    add_column :refinery_pages, :show_in_footer, :boolean, default: false
  end
end
```

Run the migration:

    rake db:migrate

## Decorating the `Refinery::Page` model

We want to decorate the `Refinery::Page` class.

Create a file `app/decorators/models/refinery/page_decorator.rb` with this content:

```ruby
Refinery::Page.class_eval do
  def self.footer_menu_pages
    where show_in_footer: true
  end
end
```

We added `footer_menu_pages` class method to abstract away ActiveRecord query method.

## Allow `show_in_footer` attribute in `Refinery::Admin::PagesController`

Before overriding Refinery's form view, we want to decorate the `Refinery::Admin::PagesController` class.

Create a file `app/decorators/controllers/refinery/admin/pages_controller_decorator.rb` with this content:

```ruby
Refinery::Admin::PagesController.prepend(
  Module.new do
    def permitted_page_params
      super << :show_in_footer
    end
  end
)
```

We added `show_in_footer` to the permitted attributes list so that it doesn't raise a mass-assignment error each time someone tries to save the page.

## Overriding the form view

As I previously mentioned, let's make it so that a "Show in footer" checkbox appears right after Admin expands the "Advanced options" when editing a page.

To do this, we have to override the file [_form_extra_fields_for_more_options.html.erb partial](https://github.com/refinery/refinerycms/blob/master/pages/app/views/refinery/admin/pages/_form_extra_fields_for_more_options.html.erb).

Type this in the terminal:

    rake refinery:override view=refinery/admin/pages/_form_extra_fields_for_more_options.html

Now open the `_form_extra_fields_for_more_options.html.erb` partial and add the following code right after the commented line:

```html
<div class='field'>
  <span class='label_with_help'>
   <%= f.label :show_in_footer, "Show in footer" %>
   </span>
   <%= f.check_box :show_in_footer %> Show this page in the footer menu
</div>
```

## Creating and configuring the Presenter

Now let's focus on the presenter itself. Once instantiated, it is also possible to configure its CSS/HTML using this instance. We will use a Rails helper to instantiate a new instance of `Refinery::Pages::MenuPresenter` and also configure it there. We're taking this approach because we don't want to pollute the view with configuration code.

Open the `ApplicationHelper` file in `app/helpers/application_helper.rb` and add this code:

```ruby
def footer_menu
  menu_items = Refinery::Menu.new(Refinery::Page.footer_menu_pages)

  Refinery::Pages::MenuPresenter.new(menu_items, self).tap do |presenter|
    presenter.dom_id = "footer_menu"
    presenter.css = "footer_menu"
    presenter.menu_tag = :div
  end
end
```

We create an instance of `Refinery::Menu` by passing a collection of footer pages (`Refinery::Page.footer_menu_pages`) to it. We need it because it will be the data that will be "presented" by `Refinery::Pages::MenuPresenter`. We assign this instance to a variable called `presenter` in order to configure this presenter. I want my footer menu to be wrapped inside of a `div` tag instead of the default `nav` tag and I also want it to have a CSS class and an ID of `footer_menu` instead of the default `menu` one:

```ruby
presenter.dom_id = "footer_menu"
presenter.css = "footer_menu"
presenter.menu_tag = :div
```

Now that we have configured the menu presenter we need to return it because we'll have to call `.to_html` on it in the view later on.

## Rendering the Menu in the View

Requirement was for the footer menu to appear just above Refinery's copyright notice. To do that we will simply override Refinery's footer view:

    rake refinery:override view=refinery/_footer.html

Next, add this code in the footer partial, above the existing code:

```erb
<%= footer_menu.to_html %>
```

## Taking a look at it

Now it's time to take a look at how everything is working. Edit a couple of pages and for some of them check the "Show in footer" checkbox located under "Advanced options". Now go to the root url of your site and take a look at the bottom; you should see links for the pages for which you checked the "Show in footer" checkbox. Also here's how the generated HTML should look:

```html
<div class="footer_menu" id="footer_menu">
  <ul>
    [...]
  </ul>
</div>
```