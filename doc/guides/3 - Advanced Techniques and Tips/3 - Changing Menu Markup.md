Changing Menu Markup with a Menu Presenter
==========================================

Popular web frameworks like [Twitter
Bootstrap](http://getbootstrap.com/) and [Zurb
Foundation](http://foundation.zurb.com/) require specific markup to
implement navigation elements.

Here we will implement a simple navigation bar with markup for
Foundation.

Setup
-----

Override the refinery file which creates the menu, and replace it with
the following code

bc.. rake refinery:override view=refinery/\_header.html

\#/app/views/refinery/shared/\_header.html.erb\
…

<section class="top-bar-section" id="menu">
<%= foundation_menu(refinery_menu_pages, list_tag_css: 'left').to_html %>

<ul class='right'>
<li>
<a href="/contact">Contact Us</a></li>

</ul>
</section>
Next an application helper.

bc..\
 \#app/helpers/ApplicationHelper\
 Module ApplicationHelper\
 \# Creates a dropdown menu with items matching Refinery pages\
 \# and tags/css matching Foundation markup\
 \#\
 \# Options:\
 \# \* *:menu\_tag* - A wrapper for the lists\
 \# \* *:dom\_id* - The dom id for the wrapper\
 \# \* *:css* - The css class for the wrapper\
 \# \* *:list\_dropdown\_css* - The css class of the submenu list\
 \# \* *:list\_item\_dropdown\_css* - The css class of the main menu
item that has a dropdown\
 \# \* *:list\_tag\_css* - The css class of the main menu\
 \# \* *:active\_css* - The css class denoting a active menu item\
 \# \* *:selected\_css* - The css class denoting a current menu item\
 def foundation\_menu(items, options = {})\
 presenter = Refinery::Pages::FoundationMenuPresenter.new(items, self)\
 %w(menu\_tag dom\_id css list\_dropdown\_css list\_item\_dropdown\_css
list\_tag\_css active\_css selected\_css).map(&:to\_sym).each do |k|\
 presenter.send(“\#{k}=”, options\[k\]) if options.has\_key?(k)\
 end\
 presenter\
 end\
end

And finally the menu presenter.

bc..

1.  app/presenters/zurb\_menu\_presenter.rb\
    module Refinery\
     module Pages\
     class FoundationMenuPresenter < MenuPresenter

          config_accessor :list_dropdown_css, :list_item_dropdown_css, :list_tag_css

          self.menu_tag = nil
          self.dom_id = nil
          self.css = nil
          self.list_dropdown_css = 'dropdown'
          self.list_item_dropdown_css = 'has-dropdown'
          self.list_tag_css = nil
          self.active_css = 'active'
          self.selected_css = 'active'

          private

          def render_menu(items)
            if menu_tag
              content_tag(menu_tag, :id => dom\_id, :class =&gt; css)
    do\
     render\_menu\_items(items)\
     end\
     else\
     render\_menu\_items(items)\
     end\
     end

def render\_menu\_items(menu\_items)\
 return if menu\_items.blank?\
 content\_tag(list\_tag, :class =&gt; menu\_items\_css(menu\_items)) do\
 menu\_items.each\_with\_index.inject(ActiveSupport::SafeBuffer.new) do
|buffer, (item, index)|\
 buffer << render_menu_item(item, index)
          end
        end
      end

      def check_for_dropdown_item(menu_item)
        ( menu_item != roots.first ) && ( menu_item_children( menu_item ).count >
0 )\
 end

def menu\_items\_css(menu\_items)\
 css = \[\]

if roots == menu\_items\
 css << list_tag_css
        else
          css << list_dropdown_css
        end

        css.reject(&:blank?).presence
      end

      def menu_item_css(menu_item, index)
        css = []

        css << active_css if descendant_item_selected?(menu_item)
        css << selected_css if selected_item?(menu_item)
        css << list_item_dropdown_css if check_for_dropdown_item(menu_item)
        css << first_css if index == 0
        css << last_css if index == menu_item.shown_siblings.length

        css.reject(&:blank?).presence
      end

      def render_menu_item(menu_item, index)
        content_tag(list_item_tag, :class => menu\_item\_css(menu\_item,
index)) do\
 @cont = context.refinery.url\_for(menu\_item.url)\
 buffer = ActiveSupport::SafeBuffer.new\
 buffer &lt;&lt; link\_to(menu\_item.title,
context.refinery.url\_for(menu\_item.url))\
 buffer &lt;&lt; render\_menu\_items(menu\_item\_children(menu\_item))\
 buffer\
 end\
 end

end\
 end\
end

#### Thanks\
Many thanks to [Moo the blog’s post](http://blog.milkfarmproductions.com/post/73806803072/refinery-cms-and-zurb-foundation-5) which is what I used to get started.
