[{:name => "site_name", :value => "Company Name"},
  {:name => "new_page_parts", :value => false},
  {:name => "activity_show_limit", :value => 18},
  {:name => "preferred_image_view", :value => :grid},
  {:name => "analytics_page_code", :value => "UA-xxxxxx-x"},
	{:name => "theme", :value => "demolicious"},
  {:name => "image_thumbnails", :value => {
    :dialog_thumb => 'c106x106',
    :grid => 'c135x135',
    :thumb => '50x50',
    :medium => '225x255',
    :side_body => '300x500',
    :preview => 'c96x96'
    }
  }].each do |setting|
  RefinerySetting[setting[:name].to_sym] = setting[:value]
  RefinerySetting.find_by_name(setting[:name].to_s).update_attributes({:destroyable => false})
end

InquirySetting.create(:name => "Confirmation Body", :value => "Thank you for your inquiry %name%,\n\nThis email is a receipt to confirm we have received your inquiry and we'll be in touch shortly.\n\nThanks.", :destroyable => false)
InquirySetting.create(:name => "Notification Recipients", :value => "", :destroyable => false)

Page.create(:title => "Home",
            :deletable => false,
            :link_url => "/",
            :menu_match => "^/$",
            :position => 0).parts.create(
            {
              :title => "Body",
              :body => "<p>Welcome to our site. This is just a place holder page while we gather our content.</p>"
            }).page.parts.create(
            {
              :title => "Side Body",
              :body => "<p>This is another block of content over here.</p>"
            })

Page.create(:title => "About Us",
            :deletable => true,
            :position => 1).parts.create(
            {
              :title => "Body",
              :body => "<p>This is just a standard text page example. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin metus dolor, hendrerit sit amet, aliquet nec, posuere sed, purus. Nullam et velit iaculis odio sagittis placerat. Duis metus tellus, pellentesque ut, luctus id, egestas a, lorem. Praesent vitae mauris. Aliquam sed nulla. Sed id nunc vitae leo suscipit viverra. Proin at leo ut lacus consequat rhoncus. In hac habitasse platea dictumst. Nunc quis tortor sed libero hendrerit dapibus.\n\nInteger interdum purus id erat. Duis nec velit vitae dolor mattis euismod. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Suspendisse pellentesque dignissim lacus. Nulla semper euismod arcu. Suspendisse egestas, erat a consectetur dapibus, felis orci cursus eros, et sollicitudin purus urna et metus. Integer eget est sed nunc euismod vestibulum. Integer nulla dui, tristique in, euismod et, interdum imperdiet, enim. Mauris at lectus. Sed egestas tortor nec mi.</p>"
            }).page.parts.create(
            {
              :title => "Side Body",
              :body => "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus fringilla nisi a elit. Duis ultricies orci ut arcu. Ut ac nibh. Duis blandit rhoncus magna. Pellentesque semper risus ut magna. Etiam pulvinar tellus eget diam. Morbi blandit. Donec pulvinar mauris at ligula. Sed pellentesque, ipsum id congue molestie, lectus risus egestas pede, ac viverra diam lacus ac urna. Aenean elit.</p>"
            })

Page.create(:title => "News",
            :link_url => "/news",
            :menu_match => "^/news.*$",
            :deletable => false,
            :position => 3).parts.create(
            {
              :title => "body",
              :body => "<p>Want to know the latest? Here's what has been happening.</p>"
            }).page.parts.create(
            {
              :title => "Side Body",
              :body => "<p>Here we post up the latest about us, along with events and updates you don't want to miss!</p>"
            })

Page.create(:title => "Contact Us",
            :link_url => "/inquiries/new",
            :menu_match => "^/inquiries.*$",
            :deletable => false,
            :position => 4).parts.create(
            {
              :title => "Body",
              :body => "<p>Get in touch with us. Just use the form below and we'll get back to you as soon as we can.</p>"
            }).page.parts.create(
            {
              :title => "Side Body",
              :body => "<p>163 Evergreen Terrace<br/>Happyville<br/>USA.<br/>Phone: 1-800 CALLUSNOW</p>"
            })

Page.create(:title => "Thank You",
            :menu_match => "^/inquiries/thank_you$",
            :show_in_menu => false,
            :deletable => false,
            :position => 0,
            :parent_id => 4).parts.create(
            {
              :title => "Body",
              :body => "<p>We've received your inquiry and will get back to you with a response shortly.</p><p><a href='/'>Return to the home page</a></p>"
            })

Page.create(:title => "Page not found",
            :menu_match => "^/404$",
            :show_in_menu => false,
            :deletable => false,
            :position => 5).parts.create(
            {
              :title => "Body",
              :body => "<h2>Sorry, there was a problem...</h2><p>The page you requested was not found.</p><p><a href='/'>Return to the home page</a></p>"
            })

Page.create(:title => "Privacy Policy",
            :deletable => true,
            :show_in_menu => false,
            :position => 6).parts.create(
            {
              :title => "Body",
              :body => "<p><strong>We respect your privacy. We do not market, rent or sell our email list to any outside parties.</p><p>We need your e-mail address so that we can ensure that the people using our forms are bona fide. It also allows us to send you e-mail newsletters and other communications, if you opt-in. Your postal address is required in order to send you information and pricing, if you request it.</p><p>Please call us at 123 456 7890 if you have any questions or concerns.</p>"
            }).page.parts.create(
            {
              :title => "Side Body",
              :body => ""
            })

Page.create(:title => "Down for maintenance",
            :menu_match => "^/maintenance$",
            :show_in_menu => false,
            :position => 7).parts.create(
            {
              :title => "Body",
              :body => "<p>Our site is currently down for maintenance. Please try back later.</p>"
            })

# Install default themes.
FileUtils::mkdir File.join(%W(#{RAILS_ROOT} themes)) unless File.directory? File.join(%W(#{RAILS_ROOT} themes))
Dir[File.join(%W(#{REFINERY_ROOT} themes *.zip))].each do |theme|
  Theme.create(:uploaded_data => {
    "size" => File.size(theme),
    "content_type" => "application/zip",
    "filename" => theme.split('/').last,
    'tempfile' => File.open(theme)
  }).read_theme
end