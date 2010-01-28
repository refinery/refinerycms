# Images

![Refinery Images](http://refinerycms.com/system/images/0000/0616/images.png)

## About

All Refinery's images are stored in one place, the images plugin. This plugin: 

* Reports recent activity on all the core plugins
* Provides convenient links to common tasks.

## Generating Thumbnails

Refinery lets you generate a range of thumbnails when an image is uploaded so you can output this on a page in an appropriate size.

To specify the sizes of your thumbnails edit the "Image Thumbnails" setting.

This setting is stored as a serialize hash and is directly passed to attachment_fu

Here's what the default looks like

    --- 
    :grid: c135x135
    :lightbox: 500x500>
    :dialog_thumb: c106x106
    :medium: 225x255
    :preview: c96x96
    :thumb: 50x50
    :side_body: 300x500

Refinery requires some of these so you won't want to delete any, but add new ones to meet your design needs. Each thumbnail is not just a size guide but a RMagick geometry string that allows you to define min and max size too.

Refinery also extends the geometry string support to allow cropping. Here's some examples

    :grid: c135x135
  
This will crop (_that's what the "c" stands for_) the image down to ``135x135`` exactly without stretching the image.

_Note: you will have to restart your web server after changing this setting for the changes to take effect._

## Related Settings

### "Preferred Image View"

Set to ``"grid"`` to get your images to display as a grid of thumbnails
Set to ``"list"`` to get your images to display as a list with image titles.