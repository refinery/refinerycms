Using Custom View or Layout Templates
-------------------------------------

Many Refinery sites have more than one look. Sometimes, the content from
a page\
might have a different container, or the page itself might be laid out\
differently. This guide will:

-   Help you decide whether these techniques are appropriate for your
    site;
-   Guide you as to which technique is the appropriate one to use for
    your\
    situation;
-   Show you how to enable both techniques.

endprologue.

### Take a Second Look

When developing a site, you might stumble into an issue where you need
to change\
the structure of the output page to accommodate a different look or a
necessary\
DOM modification that cannot be achieved through the reordering of page
parts.\
In these cases, it is nice to be able to quickly draft a second template
and\
swap.

Refinery utilises a separate view file for the home page\
(*refinery/pages/home.html.erb*). In all other circumstances, by
default,\
Refinery uses the *show* action of the *Refinery::PagesController* to
render\
page content. That means overriding and editing
*refinery/pages/show.html.erb*\
to change the structure. By default, that template is largely
blank&mdash;it\
contains a reference to the *refinery/\_content\_page* partial, which
utilises a\
complex series of classes beginning with the *ContentPagePresenter*.

This is rather advanced magic, and in some circumstances, this
automatic\
rendering does not serve well — or we might need to wrap content inside
an\
element. In this case, when we are customizing the rendering of only the
page,\
not the header or footer or actual site layout, it is appropriate to
enable\
Refinery’s custom view templates.

Likewise, on some pages, we might prefer to wrap the content of a page
inside a\
different layout, one where the header, footer, or other sections are
laid out\
differently. In this case, it’s appropropriate to enable Refinery’s
custom\
layout templates.

### Using Custom View Templates

This is a straightforward process that enhances Refinery’s capabilities
greatly.

#### Create Template

Create *app/views/refinery/pages/about\_us.html.erb*.

-   Inside of this file, you can either *render
    ’/refinery/content\_page’*, or you\
    can use
    *`page.content_for(:body)+ to output the content of a specific page part.
    NB: Content is not marked as safe by default. To mark it as safe, use: +raw(`page.content\_for(:body))*

#### Set Back-End Select

When editing your page, in the *Advanced Options* section you should see
a\
select box labled *View template*. One of the options, aside from *Home*
and *Show*\
which are there by default, will be *About Us*. It corresponds to the
template\
you added in the previous step. Select it and save your page. Now view
this\
page in the frontend and you should see that it utilises
*about\_us.html.erb*\
template.

### Enabling Custom Layout Templates

This is nearly identical to enabling View Templates, with some
additional steps:

#### Set Initializers

Open *config/initializers/refinery/pages.rb*.

-   Change *config.use\_layout\_templates* to *true*;
-   Change *config.layout\_template\_whitelist* to an array containing
    either string or\
    symbol representations of your new layout’s filename (i.e. if you
    will create a\
    new layout called *customer.html.erb*, set this whitelist to
    *\[:application, :customer\]*). In\
    order for a layout template to be displayed in the back-end, it must
    be present in\
    the whitelist. When you select an option in the back-end
    corresponding to one of\
    these whitelisted templates, it hands the name of the template to
    *render :layout*.
-   Create your new layout inside of *app/views/layouts/*, not in
    */app/views/refinery/pages/*.

#### Set Back-End Select

Then, when editing your page, you should see an option to change the
layout template in\
the *Advanced Options* section.

### When Not to Use Custom View Templates

Do not use your view template to instantiate collections\
(i.e. *<% events = Refinery::Events::Event.all %>*). This is a violation
of MVC\
convention, and in certain circumstances, can cause major issues (such
as when\
your Senior Programmer begins to pummel you with her fists). If you need
to make\
new collections or objects available to your view templates, you have
three\
options before you:

#### Use a Decorator to Add the Collection to Pages\#show

Assuming we need access to a collection of events, create\
*/app/decorators/controllers/refinery/pages/pages\_controller\_decorator.rb*\
containing the following:

<ruby>\
Refinery::PagesController.class\_eval do\
 before\_action :fetch\_events, :only =&gt; \[:show\]

def fetch\_events\
 @events = ::Refinery::Events::Event.all\
 end\
 protected :fetch\_events\
end\
</ruby>

You can also entirely override the *show* method inside this decorator,
too, if\
need be. You can [view the existing method
here](https://github.com/refinery/refinerycms/blob/master/pages/app/controllers/refinery/pages_controller.rb#L23-39)\
for reference.

This method has the advantage of constraining the find to occur only on
pages\
that are not the home page (and not, for example, on any engine pages).
There\
is one major downside, though - it will still perform the find on many
other\
pages, which is not well-contained and has implications for performance.

#### Modify the ApplicationController

You can modify the *ApplicationController* in your host app to run a
before\
filter, but this is even less efficient than the above-listed method. It
is,\
however, the simplest method.

#### Create a Custom Action

This is actually relatively straightforward with one single exception.\
Basically, use a decorator to create an additional method on the\
*PagesController*:

<ruby>

1.  /app/decorators/controllers/refinery/pages/pages\_controller\_decorator.rb\
    Refinery::PagesController.class\_eval do\
     skip\_before\_action :find\_page, :only =&gt; \[:about\_us\]\
     def about\_us\

    `page = ::Refinery::Page.where(:link_url => '/about-us').first || error_404
        `events = ::Refinery::Events::Event.all\
     render\_with\_templates?\
     end\
    end\
    </ruby>

WARNING. You may need to adjust the *where* method if you intend to
rename the page at any point, since *link\_url* is volatile.

You will also need to add a route to this method, or else the page will
remain\
unaccessible. On the very first line of *config/routes.rb*, before
anything\
else, add the following:

<ruby>\
Refinery::Core::Engine.routes.prepend do\
 get ‘/about-us’, :to =&gt; ‘pages\#about\_us’, :as =&gt; :about\_us\
end

1.  Your route file resumes here\
    </ruby>

Then this will use the *app/views/refinery/pages/about\_us.html.erb*
template by\
default.

There is one huge advantage to this method: the additional find is\
well-constrained to just a single page. There are, however, two
downsides:

1.  This removes some of the flexibility afforded to you by Refinery,
    since you\
    must be able to locate the Refinery::Page entry for the method to
    work;
2.  This requires you to prepend to routes, which is not a common idiom
    in Rails,\
    and might be confusing to newcomers if you do not document properly.

When possible, you should prefer either of the two previous methods, but
this\
last method is made available for completeness.
