Using Refinery with an Existing Rails App
-----------------------------------------

This guide covers integration with Refinery CMS. After reading it, you
should be familiar with:

-   Attaching Refinery CMS to an existing Rails application

endprologue.

WARNING. This guide is based on Refinery CMS 3.0.0. Much of the code
shown here will not work in earlier versions of Refinery.

### Guide Assumptions

This guide is designed for those who want to attach Refinery CMS to an
existing Rails application. It assumes you have at least introductory
knowledge of Refinery CMS.

### Steps to add Refinery CMS to your application

Refinery now comes as a mountable Rails extension. This is a change from
previous versions, where Refinery would have to modify files in your
application. Now, Refinery is completely namespaced and isolated from
your existing application.

#### Add Refinery CMS as a dependency in your Gemfile

Open up your Gemfile and add the latest version (a later version than
the one shown [may
exist](https://rubygems.org/gems/refinerycms/versions)):

<ruby>\
 gem ‘refinerycms’, ‘\~&gt; 3.0.0’\
</ruby>

Refinery doesn’t ship with authentication by default, but you will need
to add it\
unless you want every visitor to be automatically logged in.

If you want to use the default authentication system:

<ruby>\
 gem ‘refinerycms-authentication-devise’, ‘\~&gt; 1.0’\
</ruby>

Now, to install the gems, run:

<shell>\
 bundle install\
</shell>

#### Generate support files and migrations, and prepare the database

WARNING. Doing this will overwrite any tables that you have of the same
name; please backup first. Refinery table names begin with *refinery\_*,
so the likelihood of a collision occurring is low, but it is
nevertheless recommended you keep backups of your database and your
code.

Generating Refinery on top of an existing application is marginally more
complicated than it was before, but it’s still quite simple:

<shell>\
 rails generate refinery:cms —fresh-installation\
</shell>

This does a couple of things:

-   creates *config/initializers/refinery/* and copies over all the
    required initializers from Refinery
-   copies all Refinery migrations to your apps migration folder and
    runs these migrations, and adds the seed data to your database
-   injects Refinery’s mounting line into your *config/routes.rb* file
-   inserts *require refinery/formatting* and *require refinery/theme*
    lines in your apps application.css file

After this, you should be all set. Don’t forget to revisit the
initializers in *config/initializers/refinery/* to customize your
experience.

### Mounting to a directory other than root

It is possible to mount Refinery to a subfolder. To do this, simply
change the following setting in *config/initializers/refinery/core.rb*:

<ruby>\
 config.mounted\_path = “/subfolder”\
</ruby>

After starting your rails server and navigating to
*localhost:3000/subfolder*, you should see a dummy home page.

You can create the initial admin user by visiting
*localhost:3000/subfolder/refinery*.

### Getting Help

As this is a relatively new process, if you need help with any of these
steps we would love to [hear about it](/guides/how-to-get-help/).
