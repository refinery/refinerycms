# Images

![Refinery Images](http://refinerycms.com/system/images/0000/0616/images.png)

## About

All Refinery's images are stored in one place, the images plugin.

Images and other file uploads are handled using [Dragonfly](http://github.com/markevans/dragonfly)

## Using a Thumbnail Size in Your View

Say I want to have a thumbnail of size 400x300 I would collect that image out of
the database and apply it like this in my view:

    <%= image_fu @image, '400x300' %>

``image_fu`` is a command we have created that automatically adds width and
height attributes to the generated image so that web browsers render your pages
more smoothly as they know in advance how big an image is going to be before it
is fully downloaded.

If I wanted to replace all the images inside a content section without the user
having to resize images in the editor then I would use the built in ``content_fu``
command like this in my view:

    <%= content_fu @page[:body], '400x300' %>

``content_fu`` is a command we have created that automatically changes all images
with the url /system/images to use a particular size.
This makes it easy to protect your pages from having gigantic images inserted into
them that blow out the design.

## Related Settings

### "Preferred Image View"

Set to ``"grid"`` to get your images to display as a grid of thumbnails
Set to ``"list"`` to get your images to display as a list with image titles.
