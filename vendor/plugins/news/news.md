# News

![Refinery News](http://refinerycms.com/system/images/0000/0646/news.png)

## About

__Refinery's news plugin allows you to post updates to the news section of your website.__

Key features:

* Default news page shows a summary of recent news posts
* Detail view shows the full post and also linked to recent news on the "side bar"

## But I don't want a News Section, how do I kill it?

Your news section loads because you have a page in your site that is told to not just render a normal page, but load the news section instead.

By default this page is called "News". Go to your "Pages" tab in the Refinery admin area and click the edit icon on "News". Now  click on "Hide/Show Advanced Options" and you'll see that a "Custom URL" is set to ``/news``. Simply change this to nothing, or delete the "News" page.

You might also want to remove the News plugin from your backend view. To do that, you go to the "Users" tab in the Refinery admin area, edit your user, uncheck "News" from the list of plugins you can access.