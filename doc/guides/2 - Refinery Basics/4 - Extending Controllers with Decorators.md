Extending Controllers with Decorators
-------------------------------------

The default behavior of Refinery or a Refinery extension and its
controllers may not be exactly what you are looking for. This guide will
show you how to:

-   Extend a Controller to add new behavior

endprologue.

### Why extend instead of override?

When designing pages for Refinery, a commonly performed task is to
override views with something similar to:

<shell>\
 \$ rake refinery:override view=refinery/pages/show\
</shell>

The same can be done for Refinery’s controllers or models, but it could
make troubleshooting Refinery and upgrading to future versions more
difficult. Often you’ll want a controller or model to act exactly as it
has already been defined, but you’ll want to add some additional
behavior or modify only a small bit of pre-existing behavior.

### Extending a Controller

Often you’ll want to perform some additional controller logic that is
not defined by Refinery already. An example for this is when you are
building a homepage that contains a listing of blog articles. By default
the ‘home’ action on the *PagesController* will not find all of the
published blog articles. You could perform this logic at the top of your
view but you would be violating the rules of MVC. What you really want
to do is to have the controller populate an instance variable for you to
render in your view.

We start out by creating
*app/decorators/controllers/refinery/pages\_controller\_decorator.rb*
unless it already exists:

<ruby>\
 Refinery::PagesController.class\_eval do\
 \# your controller logic goes here\
 end\
</ruby>

The code within the *class\_eval* block in any decorator can be written
as if you are writing in the class definition of the class it is
extending. In this case we’re extending a ActionController and we want
it to find us some blog posts:

<ruby>\
 Refinery::PagesController.class\_eval do

before\_action :find\_all\_blog\_posts, :only =&gt; \[:home\]

protected

def find\_all\_blog\_posts\
 @blog\_posts = Refinery::BlogPost.live\
 end

end\
</ruby>

We define the *find\_all\_blog\_posts* method and set it as a
*before\_action* for the *pages\#home* action. This will make the
*@blog\_posts* instance variable available in our views which will
contain all of the live blog posts. Because writing a decorator is just
like extending a class definition, we could even simplify this further
by writing:

<ruby>\
 Refinery::PagesController.class\_eval do

include Refinery::Blog::ControllerHelper\
 helper :‘refinery/blog/posts’\
 before\_action :find\_all\_blog\_posts, :only =&gt; \[:home\]

end\
</ruby>

The Blog extension contains a helper module which already has the
*find\_all\_blog\_posts* method defined for this common case. This will
make the *@posts* instance variable available in our views.

WARNING. If you are following along, make sure that you have the
refinerycms-blog extension in your gem file or you will not have access
to this helper module.
