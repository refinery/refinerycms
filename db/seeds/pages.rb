page_position = -1

home_page = Page.create(:title => "Home",
            :deletable => false,
            :link_url => "/",
            :menu_match => "^/$",
            :position => (page_position += 1))
home_page.parts.create({
              :title => "Body",
              :body => "<p>Welcome to our site. This is just a place holder page while we gather our content.</p>",
              :position => 0
            })
home_page.parts.create({
              :title => "Side Body",
              :body => "<p>This is another block of content over here.</p>",
              :position => 1
            })

about_us_page = Page.create(:title => "About",
            :deletable => true,
            :position => (page_position += 1))
about_us_page.parts.create({
              :title => "Body",
              :body => "<p>This is just a standard text page example. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin metus dolor, hendrerit sit amet, aliquet nec, posuere sed, purus. Nullam et velit iaculis odio sagittis placerat. Duis metus tellus, pellentesque ut, luctus id, egestas a, lorem. Praesent vitae mauris. Aliquam sed nulla. Sed id nunc vitae leo suscipit viverra. Proin at leo ut lacus consequat rhoncus. In hac habitasse platea dictumst. Nunc quis tortor sed libero hendrerit dapibus.\n\nInteger interdum purus id erat. Duis nec velit vitae dolor mattis euismod. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Suspendisse pellentesque dignissim lacus. Nulla semper euismod arcu. Suspendisse egestas, erat a consectetur dapibus, felis orci cursus eros, et sollicitudin purus urna et metus. Integer eget est sed nunc euismod vestibulum. Integer nulla dui, tristique in, euismod et, interdum imperdiet, enim. Mauris at lectus. Sed egestas tortor nec mi.</p>",
              :position => 0
            })
about_us_page.parts.create({
              :title => "Side Body",
              :body => "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus fringilla nisi a elit. Duis ultricies orci ut arcu. Ut ac nibh. Duis blandit rhoncus magna. Pellentesque semper risus ut magna. Etiam pulvinar tellus eget diam. Morbi blandit. Donec pulvinar mauris at ligula. Sed pellentesque, ipsum id congue molestie, lectus risus egestas pede, ac viverra diam lacus ac urna. Aenean elit.</p>",
              :position => 1
            })

contact_us_page = Page.create(:title => "Contact",
            :link_url => "/contact",
            :menu_match => "^/(inquiries|contact).*$",
            :deletable => false,
            :position => (page_position += 1))
contact_us_page.parts.create({
              :title => "Body",
              :body => "<p>Get in touch with us. Just use the form below and we'll get back to you as soon as we can.</p>",
              :position => 0
            })
contact_us_page.parts.create({
              :title => "Side Body",
              :body => "<p>163 Evergreen Terrace<br/>Happyville<br/>USA.<br/>Phone: 1-800 CALLUSNOW</p>",
              :position => 1
            })
contact_us_page_position = -1

thank_you_page = contact_us_page.children.create(:title => "Thank You",
            :link_url => "/contact/thank_you",
            :menu_match => "^/(inquiries|contact)/thank_you$",
            :show_in_menu => false,
            :deletable => false,
            :position => (contact_us_page_position += 1))
thank_you_page.parts.create({
              :title => "Body",
              :body => "<p>We've received your inquiry and will get back to you with a response shortly.</p><p><a href='/'>Return to the home page</a></p>",
              :position => 0
            })

privacy_policy_page = Page.create(:title => "Privacy Policy",
            :deletable => true,
            :show_in_menu => false,
            :position => (page_position += 1))
privacy_policy_page.parts.create({
              :title => "Body",
              :body => "<p>We respect your privacy. We do not market, rent or sell our email list to any outside parties.</p><p>We need your e-mail address so that we can ensure that the people using our forms are bona fide. It also allows us to send you e-mail newsletters and other communications, if you opt-in. Your postal address is required in order to send you information and pricing, if you request it.</p><p>Please call us at 123 456 7890 if you have any questions or concerns.</p>",
              :position => 0
            })

page_not_found_page = Page.create(:title => "Page not found",
            :menu_match => "^/404$",
            :show_in_menu => false,
            :deletable => false,
            :position => (page_position += 1))
page_not_found_page.parts.create({
              :title => "Body",
              :body => "<h2>Sorry, there was a problem...</h2><p>The page you requested was not found.</p><p><a href='/'>Return to the home page</a></p>",
              :position => 0
            })
