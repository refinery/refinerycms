# Troubleshooting Refinery CMS and Dragonfly

Refinery uses the [Dragonfly gem](https://github.com/markevans/dragonfly) for file (images and resources) storage and handling.

Dragonfly stores an image once and produces image variations (thumbnails, formats and enhancements) on-the-fly. As this is not the usual way of handling images troubleshooting image problems can be confusing at first.

## Imagemagick

Dragonfly depends on [Imagemagick](http://www.imagemagick.org/) to do graphics processing. Imagemagick is a standalone application which `must` be installed on the application server.

If images are not working double-check that Imagemagick is installed.

## URLs

Dragonfly urls contain the information dragonfly needs to produce an image of the appropriate size and format. This is a dragonfly url:

```ruby
/system/images/W1siZiIsIjIwMTUvMDQvMjEvNjRlZ2d5MjJzcl9CdWxsd2lua2xlLmpwZyJdLFsicCIsInRodW1iIiwiMjI1eDI1NVx1MDAzZSJdXQ/Bullwinkle.jpg?sha=6ce3368c333342ff
```

The long string is a base64 encoded string. I used [base64decode.com](https://www.base64decode.org/) to translate "W1....dXQ" into

```ruby
[["f","2015/04/21/64eggy22sr_Bullwinkle.jpg"],["p","thumb","225x255\u003e"]]
```

[which tells dragonfly to supply the image `Bullwinkle.jpg` as a `225x255px` thumbnail, but not to increase the size of a smaller image.][1] [][2]

Decode the base64-encoded url to see what dragonfly should be doing

## Where are the images?

If you are using the default Refinery/Dragonfly configuration your images will be stored in `public/system/refinery/images`.

The file we used as an example is stored at `public/system/refinery/images/2015/04/21/64eggy22sr_Bullwinkle.jpg` and
I could navigate down the directories and find it.

Dragonfly stores the images using a scheme to ensure that image URLs are unique. There are ways in which you can change the scheme - read the [really good Dragonfly documentation](http://markevans.github.io/dragonfly/) to find out more if this is what you need.

Check that the file is still where Dragonfly saved it.

## Other Stores

Refinery/Dragonfly allow you to use stores like Amazon S3, Couch and Mongo, or to write your own.

Refer to Refinery's Guide [Amazon S3 for Uploads](/guides/amazon-s3-for-uploads) or to
Dragonfly's [Data Store document](http://markevans.github.io/dragonfly/data-stores/).

## Dragonfly.log

Dragonfly writes a log file to your application's root directory. Look in there if you suspect that dragonfly is failing. Here is the log entry for a successful resize of the image.

```shell
D, [2015-04-29T12:41:22.505590 #23697] DEBUG -- : DRAGONFLY: shell command: 'convert' '/Applications/MAMP/www/rockythemoose/public/system/refinery/images/2015/04/21/64eggy22sr_Bullwinkle.jpg' '-resize' '225x255>' '/var/folders/xp/c9lbr76s6qs78fp4fxnxntrh0000gn/T/dragonfly20150429-23697-1hglgc2.jpg'
```

If the base image doesn't exist, the geometry is unrecognized or imagemagick is not installed it should be reflected in this file.

[1]: U003E is the unicode for "&gt;".
[2]: "&gt;" is the Imagemagick geometry flag for "only shrink larger"
