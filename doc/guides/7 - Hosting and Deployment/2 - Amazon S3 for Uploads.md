Using Amazon S3 for Uploads
---------------------------

Hosting your site’s files on Amazon S3 is a popular option for many,
especially\
if you’re using a read only file system like
[Heroku](http://heroku.com).\
This guide will show you how to:

-   Enable and configure Refinery to store files and images on Amazon S3

endprologue.

NOTE: If you are using S3 in combination with Heroku please refer to the
[Heroku guide](/guides/heroku) for more information.

### Setting Up

If you want to use Refinery’s image and resource support on S3 instead
of the local\
file system, you’ll need an additional gem. Create a bucket called
“my\_app\_production”\
and add this line in your Gemfile:

<ruby>\
group :production do\
 gem ‘dragonfly-s3\_data\_store’\
end\
</ruby>

### Telling Refinery to use S3

Refinery will use S3 for storage if it finds the *S3\_KEY*,
*S3\_SECRET*, and *S3\_BUCKET* environment variables.

There are a number of ways to set these with your credentials, including
unix variables\
or settings them manually through Ruby using ENV.

#### Unix variables

pre. \$ export S3\_KEY=‘fill\_in\_your\_key\_here’\
\$ export S3\_SECRET=‘fill\_in\_your\_secret\_key\_here’\
\$ export S3\_BUCKET=‘fill\_in\_your\_bucket\_name\_here’\
\$ export S3\_REGION=‘fill\_in\_your\_buckets\_region\_here’\
\$ …

On the last line, fill in your preferred way of starting your Rails
server.\
S3\_REGION is only needed if you have created your bucket in a region
other than the default ‘us-east-1’.

#### Using Ruby ENV

You can put the environment keys literally in any of the Rails config
files like\
*config/application.rb* or *config/environments/production.rb*:

<ruby>\
ENV\[‘S3\_KEY’\]=‘fill\_in\_your\_key\_here’\
ENV\[‘S3\_SECRET’\]=‘fill\_in\_your\_secret\_key\_here’\
ENV\[‘S3\_BUCKET’\]=‘fill\_in\_your\_bucket\_name\_here’\
</ruby>

(Note: For Heroku, you should use [config vars to set your environment
variables](http://refinerycms.com/guides/heroku))

Another option, especially if you experience
\`Dragonfly::DataStorage::S3DataStore\` exceptions, is to configure your
Amazon S3 credentials in *config/initializers/refinery/core.rb* using
the following syntax:

<ruby>\
Refinery::Core.configure do |config|\
 config.s3\_backend = true\
 config.s3\_access\_key\_id = ‘fill\_in\_your\_key\_here’\
 config.s3\_secret\_access\_key = ‘fill\_in\_your\_secret\_key\_here’\
 config.s3\_bucket\_name = ‘fill\_in\_your\_bucket\_name\_here’\
 config.s3\_region = ‘fill\_in\_your\_buckets\_region\_here’ \# this
one’s not always required, default is ‘us-east-1’\
end\
</ruby>

### Turning S3 on and off

S3 should automatically sense that it is enabled based on these ENV
variables\
but if it is not you can add this code to the *end* of the appropriate
environment file, for\
example with the production environment
*config/environments/production.rb*:

<ruby>\
Refinery::Core.config.s3\_backend = true\
</ruby>

There are some cases where you have these three variables set but do not
want to use S3.\
You can always manually set S3 to either false or true in the
environment you are using.\
For example, forcing S3 to always be off in development is as simple as
adding the\
following line to the *end* of *config/environments/development.rb*:

<ruby>\
Refinery::Core.config.s3\_backend = false\
</ruby>
