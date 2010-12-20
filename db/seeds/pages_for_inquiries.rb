page_position = (Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)

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

privacy_policy_page = contact_us_page.children.create(:title => "Privacy Policy",
            :deletable => true,
            :show_in_menu => false,
            :position => (contact_us_page_position += 1))
privacy_policy_page.parts.create({
              :title => "Body",
              :body => "<p>We respect your privacy. We do not market, rent or sell our email list to any outside parties.</p><p>We need your e-mail address so that we can ensure that the people using our forms are bona fide. It also allows us to send you e-mail newsletters and other communications, if you opt-in. Your postal address is required in order to send you information and pricing, if you request it.</p><p>Please call us at 123 456 7890 if you have any questions or concerns.</p>",
              :position => 0
            })
