Shelly Cloud
------------

[Shelly Cloud](https://shellycloud.com/) is a platform for hosting Ruby
and Rails\
apps. This guide will show you how to:

-   Install and deploy a Refinery application on the Shelly Cloud
    hosting platform

endprologue.

### Prerequisites

Before moving on to Refinery, first make sure you have the required
system tools\
installed:

-   Ruby, version 1.9.3 or higher. On Shelly Cloud the default Ruby
    version\
     is 2.0.0 and it’s generally better to have the same version locally
-   Working compiler (to install gems with native extensions)
    -   on OS X you will need XCode with command line tools
    -   for Ubuntu install at least build-essential and autoconf
        packages
-   PostgreSQL headers
    -   for OS X install postgresql via
        [Postgres.app](http://postgresapp.com/)
    -   for Ubuntu it will be required to have libpq-dev installed

WARNING. Microsoft Windows isn’t supported on Shelly Cloud. It’s
strongly discouraged to try this walkthrough on operating systems
different than OS X or Linux.

As for gems, you will need to install:

-   Shelly
-   Refinery CMS - it’s used to generate drafts of your future
    application
-   ExecJS - it isn’t installed with Refinery gem but [it’s
    required](https://github.com/refinery/refinerycms/issues/2352)

You can do it by executing following command:

<shell>\
gem install shelly execjs refinerycms\
</shell>

### Step by step installation guide

#### Step 1: If you don’t have a Shelly Cloud account yet use [sign up page](https://shellycloud.com/sign_up) to create one.

#### Step 2: Login to Shelly Cloud via command line.

<shell>\
\$ shelly login\
Email (you@example.com - default): \[enter your email\]\
Password: \[enter your password\]\
Login successful\
Uploading your public SSH key\
</shell>

#### Step 3: Now, create *refinery-with-shelly* application scaffold.

<shell>\
\$ refinerycms refinery-with-shelly\
…\
= ACTION REQUIRED =\
Now you can launch your webserver using:

cd refinery-with-shelly\
rails server

This will launch the built-in webserver at port 3000.\
You can now see Refinery running in your browser at
http://localhost:3000/refinery

Thanks for installing Refinery CMS, we hope you enjoy crafting your
application!\
————\
</shell>

#### Step 4: Go to *refinery-with-shelly* directory:

<shell>\
\$ cd refinery-with-shelly\
</shell>

#### Step 5: Edit Gemfile and add *:production* group to the end of file.

<ruby>\
group :production do\
 gem “shelly-dependencies”\
 gem “pg”\
end\
</ruby>

Added gems are standard Shelly Cloud
[dependencies](https://shellycloud.com/documentation/requirements#shelly-dependencies)\
for Rails application with PostgreSQL database.

#### Step 6: To have assets working, it’s required to use Shelly Cloud [deployment hook support](https://shellycloud.com/documentation/deployment_hooks)

##### Create hook file which will take care of assets precompilation on remote server.

<shell>

1.  config/deploy/shelly/before\_migrate

set -e

1.  Precompile assets (this happens only on one of the servers)\
    rake assets:precompile\
    </shell>

#### Step 7: Install your Refinery instance dependencies.

<shell>\
\$ bundle install\
</shell>

#### Step 8: Test the application in local environement.

##### Precompile static assets.

<shell>\
\$ rake assets:precompile\
</shell>

##### Add *public/assets* to *.gitignore* file. You don’t want to have all these\
files commited to the repository.

##### Run migrations

<shell>\
\$ RAILS\_ENV=“production” rake db:migrate\
</shell>

##### Run application

<shell>\
\$ rails s -e production\
</shell>

You can see it by entering <http://localhost:3000/refinery>\
in your browser.

NOTE: You can stop your local Rails server using CTRL+C.

#### Step 9: Initialize git repository and add all files to it.

<shell>\
\$ git init\
\$ git add .\
\$ git commit -m “Initial commit of my Refinery instance”\
</shell>

#### Step 10: Create an application on Shelly Cloud (you can respond to all\
questions with the default action).

<shell>\
\$ shelly add\
\$ git add Cloudfile\
\$ git commit -m “Add application to Shelly Cloud”\
\$ git push shelly master\
</shell>

#### Step 11: Start the newly created cloud.

<shell>\
\$ shelly start\
</shell>

#### Step 12: Go to <http://refinery-with-shelly.shellyapp.com/refinery> and create a first account.
