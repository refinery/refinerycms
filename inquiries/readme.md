# Inquiries

![Refinery Inquiries](http://refinerycms.com/system/images/0000/0626/inquiries.png)

## About

__Refinery gives you a simple contact form that notifies you and the customer when an inquiry is made.__

In summary you can:

* Collect and manage inquiries
* Specify who is notified when a new inquiry comes in
* Customise an auto responder email that is sent to the person making the inquiry

When inquiries come in, you and the customer are notified. The inquiry will now show up as an "open" inquiry. The idea is to deal with the inquiry and then "close" it so you know it's been sorted.

## How do I get Notified?

Go into your 'Inquiries' tab in the Refinery admin area and click on "Update who gets notified"

## How do I Edit the Automatic Confirmation Email

Go into your 'Inquiries' tab in the Refinery admin area and click on "Edit confirmation email"

## But I don't want a Contact Form how do I kill it?

Your contact form loads because you have a page in your site that is told to not just render a normal page, but load the contact form instead.

By default this page is called "Contact". Go to your "Pages" tab in the Refinery admin area and click the edit icon on "Contact". Now click on "Hide/Show Advanced Options" and you'll see that a "Custom URL" is set to ``/contact``. Simply change this to nothing, or delete the contact us page.

You might also want to remove the Inquiries plugin from your backend view. To do that, you go to the "Users" tab in the Refinery admin area, edit your user, uncheck "Inquiries" from the list of plugins you can access.