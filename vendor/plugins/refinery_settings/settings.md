# Settings

![Refinery Settings](http://refinerycms.com/system/images/0000/0666/settings.png)

## About

Refinery comes out of the box with a full settings area that is populated with smart defaults to avoid configuration.

## Settings of Interest

Here's an overview of what comes out of the box

### Google Analytics

Just edit the setting called "Analytics Page Code" and enter just your account number. It will look something like this

    UA-XXXXXX-X
    
Save this and Refinery will automatically note you have set the page code up and start rendering it on the front end so tracking can begin.

### Firebug Lite Support

[Firebug lite](http://getfirebug.com/lite) is fantastic for debugging your site in Internet Explorer.

Set the 'Show Firebug Lite' setting to ``true`` and you'll be able to debug your views in Internet Explorer in no time.

_Note: you'll want to turn this off once your site is live_

### Use Google Ajax Libraries

This setting will automatically change your AJAX libraries to use the ones delivered by Google's CDN (Content Delivery Network) which means your Javascript will be cached and delivery as quickly as possible.

## How do I Make my Own Settings?

Settings can be really useful, especially when you have custom display logic or new plugins that need to behave in different ways.

To best explain how settings work let's use an example.  Say you have a client who has a display in a local trade show every year and 2 months before the trade show they want to display a little banner in the header of all pages.

But once the trade show is finsihed, the client needs to be able to hide it again until next year. This is what my ``application.html.erb`` file might look like:

    ...
    <div id='header'>
      <h1>My Company</h1>
      
      <% if RefinerySetting.find_or_set(:show_trade_show_banner, false) %> 
        <%= image_tag ('trade-show-banner.jpg') %>
      <% end %>
    </div>
    ...
    
The following will automatically create a new Refinery setting called "show_trade_show_banner" and default it to ``false``. If that setting already exists, it just reads in what the current value is.

So as you can see this is quite clever because you can quickly define new settings and their defaults right from the view as you need them.

This setting would then show up in the backend in the 'Settings' area where the client could change the value as their trade show approaches. Easy as pie!