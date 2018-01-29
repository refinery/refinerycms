# Using Amazon S3 for Uploads

Hosting your site's files on Amazon S3 is a popular option for many, especially if you're using a read only file system like
[Heroku](https://heroku.com). This guide will show you how to:

* Enable and configure Refinery to store files and images on Amazon S3

__NOTE__: If you are using S3 in combination with Heroku please refer to the [Heroku guide](/guides/heroku) for more information.

## Setting Up

If you want to use Refinery's image and resource support on S3 instead of the local
file system, you'll need an additional gem. Create a S3 bucket called `my_app_production` and add this line in your `Gemfile`:

```ruby
group :production do
 gem 'dragonfly-s3_data_store'
end
```

## Telling Refinery to use S3

Refinery will use S3 for storage if it finds the `S3_KEY`, `S3_SECRET`, and `S3_BUCKET` environment variables.

There are a number of ways to set these with your credentials, including unix variables or settings them manually through Ruby using ENV.

### Unix variables

```bash
$ export S3_KEY='fill_in_your_key_here'
$ export S3_SECRET='fill_in_your_secret_key_here'
$ export S3_BUCKET='fill_in_your_bucket_name_here'
$ export S3_REGION='fill_in_your_buckets_region_here'
```

On the last line, fill in your preferred way of starting your Rails server.

__Note__: `S3_REGION` is only needed if you have created your bucket in a region other than the default `us-east-1`.

### Using Ruby ENV

You can put the environment keys literally in any of the Rails config files like
`config/application.rb` or `config/environments/production.rb`:

```ruby
ENV['S3_KEY']='fill_in_your_key_here'
ENV['S3_SECRET']='fill_in_your_secret_key_here'
ENV['S3_BUCKET']='fill_in_your_bucket_name_here'
```

__Note__: For Heroku, you should use [config vars to set your environment variables](/guides/heroku))

Another option, especially if you experience `Dragonfly::DataStorage::S3DataStore` exceptions, is to configure your
Amazon S3 credentials in `config/initializers/refinery/core.rb` using the following syntax:

```ruby
Refinery::Core.configure do |config|
  config.s3_backend = true
  config.s3_access_key_id = 'fill_in_your_key_here'
  config.s3_secret_access_key = 'fill_in_your_secret_key_here'
  config.s3_bucket_name = 'fill_in_your_bucket_name_here'
  config.s3_region = 'fill_in_your_buckets_region_here' # this one's not always required, default is 'us-east-1'
end
```

## Turning S3 on and off

S3 should automatically sense that it is enabled based on these ENV variables but if it is not you can add this code to the __end__ of the appropriate environment file, for example with the production environment
`config/environments/production.rb`:

```ruby
Refinery::Core.config.s3_backend = true
```

There are some cases where you have these three variables set but do not want to use S3.

 You can always manually set S3 to either `false` or `true` in the environment you are using.

For example, forcing S3 to always be off in development is as simple as adding the following line to the __end__ of `config/environments/development.rb`:

```ruby
Refinery::Core.config.s3_backend = false
```
