# Images

![Refinery Images](http://refinerycms.com/system/images/0000/0616/images.png)

## About

All Refinery's images are stored in one place, the images plugin. You can customise what sized thumbnails are generated when an image is uploaded.

Images and other file uploads are handled using [attachment_fu](http://github.com/technoweenie/attachment_fu)

## Generating Thumbnails

Refinery lets you generate a range of thumbnails when an image is uploaded so you can output this on a page in an appropriate size.

To specify the sizes of your thumbnails edit the "Image Thumbnails" setting.

This setting is stored as a serialized hash and is directly passed to [attachment_fu](http://github.com/technoweenie/attachment_fu)

Here's what the default looks like

    ---
    :dialog_thumb: c106x106
    :preview: c96x96
    :medium: 225x255>
    :large: 450x450>
    :small: 110x110>
    :grid: c135x135

Refinery requires some of these, so you won't want to delete any, but add new ones to meet your design needs. Each thumbnail is not just a size guide but a [RMagick geometry string](http://www.imagemagick.org/RMagick/doc/imusage.html#geometry) that allows you to define min and max size too.

Refinery also extends the [geometry string](http://www.imagemagick.org/RMagick/doc/imusage.html#geometry) support to allow cropping. Here's some examples

    :grid: c135x135

This will crop (_that's what the "c" stands for_) the grid thumbnail down to ``135x135`` exactly, without stretching the image.

_Note: you will have to restart your web server after changing this setting for the changes to take effect._

## Using a Thumbnail Size in Your Theme or View

Take the default thumbnails above to use the ``:large`` thumbnail I would collect that image out of the database and apply it like this in my view:

    <%= image_fu @image, :large %>

``image_fu`` is a command we have created that automatically adds width and height attributes to the generated image so that web browsers render your pages more smoothly as they know in advance how big an image is going to be before it is fully downloaded.

If I wanted to replace all the images inside a content section without the user having to resize images in the editor then I would use the built in ``content_fu`` command like this in my view:

    <%= content_fu @page[:body], :large %>

``content_fu`` is a command we have created that automatically changes all images with the url /system/images to use a particular thumbnail size. This makes it easy to protect your pages from having gigantic images inserted into them that blow out the design.

## Related Settings

### "Preferred Image View"

Set to ``"grid"`` to get your images to display as a grid of thumbnails
Set to ``"list"`` to get your images to display as a list with image titles.