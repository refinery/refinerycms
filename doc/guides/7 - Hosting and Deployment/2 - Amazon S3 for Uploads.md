# Using Amazon S3 for Uploads

Hosting your app's files on Amazon S3 is a popular option for many, especially if you're using a read-only filesystem like
[Heroku](https://heroku.com). This guide will show you how to:

* Enable and configure Refinery to store files and images on Amazon S3

__NOTE__: If you are using S3 in combination with Heroku please refer to the [Heroku guide](/guides/heroku) for more information.

## Preparation

If you want to configure Refinery images and/or resources engine to use Amazon's S3 datastore instead of the local
filesystem, you'll need the `dragonfly-s3_data_store` gem. Add it in your `Gemfile` for the environments where you plan to use it:  

```ruby
group :production do
 gem 'dragonfly-s3_data_store'
end
```
In Amazon AWS, create an S3 bucket with a descriptive name, for example `myapp-production`. Create an Access Control List (ACL) for your bucket that allows anyone to read files (it's called "list objects" in S3). Without read permissions uploads may result in 403 Forbidden error. 

It is recommended to create a separate, so-called IAM user for interacting with only S3, and to disable the security credentials of the AWS root user. 

## Configuration for S3

Refinery will use S3 for storage if `Refinery::Dragonfly.s3_datastore` evaluates as true. In addition, you need four S3 parameters. You can set them by using environment variables and/or adding literal definitions in your app. 

There are three methods of setting the four S3 parameters: 

1. Use enviroment variables with names that Refinery will recognize automatically,
2. Use environment variables with any names, and in your app pass their values to Dragonfly config variables
3. Define the parameters directly as Dragonfly config variables with string literal values

The advantage of using environment variables is that the credentials will not be hard-coded anywhere in your app, which enhances security. Also the environment variables make it easy to use different buckets or different credentials in development and production. 

### Environment variables

Environment variables are typically set in a `.bash_profile` file in the user directory. 

Refinery will automatically recognize environment variables `S3_KEY`, `S3_SECRET`, `S3_BUCKET`, and `S3_REGION`. Define the variables in your profile file like this: 

```bash
export S3_KEY='your_aws_key_goes_here'
export S3_SECRET='fill_in_your_very_very_long_aws_secret_key_here'
export S3_BUCKET='your_bucket_name_goes_here'
export S3_REGION='your_region_here'
```

Alternatively you can define environment variables in your app. This solution is less secure, as the values will be hard-coded in your app source. You can put the var definitions literally in any of the Rails config files, like
`config/application.rb` or `config/environments/production.rb`:

```ruby
ENV['S3_KEY']='your_aws_key_goes_here'
ENV['S3_SECRET']='fill_in_your_very_very_long_aws_secret_key_here'
(...)
```

__Note__: `S3_REGION` is not needed if your bucket resides in the default AWS region, `us-east-1`.

__Note__: For Heroku, you should set your environment variables by [Heroku's config vars](/guides/heroku)).

If you decide not to use the standard environment variable names that Refinery recognizes automatically, you will have to manually pass the values to Dragonfly config vars (method 2 above). For this you can use the Dragonfly initializer file. 

### The Dragonfly initializer file

In old Refinery versions, the S3 variables were defined in `Refinery::Core`. In Refinery 4 they are defined in `Refinery::Dragonfly`instead. The Dragonfly initializer file can be found at `config/initializers/refinery/dragonfly.rb`. If there is no such file, generate it by running `rails generate refinery:dragonfly` at your app root. 

The important parts in the file are the four S3 parameters, plus the `config.s3_datastore` variable, for which you only need to check that it will evaluate as true. 

To define the four S3 variables, you will either use environment variables, if you have set them, or string literals, like `config.s3_region = 'eu-north-1'`. Here is an example with environment variables: 

```ruby
Refinery::Dragonfly.configure do |config|
  config.s3_access_key_id = ENV['AWS_ACCESS_KEY_ID']
  config.s3_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY]
  config.s3_bucket_name = ENV['S3_BUCKET_NAME']
  config.s3_region = ENV['S3_REGION'] # not required for the default region 'us-east-1'
  config.s3_datastore = config.s3_access_key_id.present? || config.s3_secret_access_key.present?
end
```

### Images initializer

If you have set the four S3 parameters using any of the methods mentioned above, then in the images initializer it is only necessary to switch on the S3 datastore. Also you can set a root path to keep your S3 bucket organized. In this example the images will be saved in an `images` folder in your S3 bucket: 

```ruby
config.s3_datastore = Refinery::Dragonfly.s3_datastore  # will evaluate as true
config.s3_root_path = 'images'
```

## Turning S3 on and off

If you don't want to use S3, simply set `config.s3_datastore = false` in the initializer file for Dragonfly, images, and/or resources. You can also set it in an environment configuration file. For example add this to the __end__ of `config/environments/development.rb`:

```ruby
Refinery::Dragonfly.config.s3_datastore = false
```

## Debugging

If you have set the S3 datastore as specified above, but the images still appear in your local datastore (typically `public/system`), or if you face any errors on upload, debugging can be tricky. First ensure that the Dragonfly variables are properly set. In development environment it should be safe to simply print the var values in your views, for example with `<%= Refinery::Dragonfly.s3_bucket_name %>`. Be careful not to reveal your secrets to the public. 

If all looks good and the uploads still fail, you can use the aws command-line tool to try uploading, and also to check your bucket permissions: `aws2 s3api get-bucket-acl --bucket my-bucket-name`. Check that the public has read permissions. 

You can switch on logging in your S3 bucket. This may give you some information about what's going on. 

If you get system errors, use the [byebug](https://github.com/deivid-rodriguez/byebug) gem, write the word `byebug` somewhere in the various functions mentioned in the error stack, and when byebug then interrupts serving the request, try to use any available commands to read whatever variables are available at each point. 
