if Refinery::Page.where(menu_match: "^/$").empty?
  home_page = Refinery::Page.create!(
    title: "Home",
    deletable: false,
    link_url: "/",
    menu_match: "^/$"
  )
  home_page.parts.create(
    title: "Body",
    body: "<p>Welcome to our site. This is just a place holder page while we gather our content.</p>",
    position: 0
  )
  home_page.parts.create(
    title: "Side Body",
    body: "<p>This is another block of content over here.</p>",
    position: 1
  )

  home_page_position = -1
  page_not_found_page = home_page.children.create(
    title: "Page not found",
    menu_match: "^/404$",
    show_in_menu: false,
    deletable: false
  )
  page_not_found_page.parts.create(
    title: "Body",
    body: '<h2>Sorry, there was a problem...</h2><p>The page you requested was not found.</p><p><a href="/">Return to the home page</a></p>',
    position: 0
  )

  if Refinery::Page.by_title("About").empty?
    about_us_page = ::Refinery::Page.create title: "About"
    about_us_page.parts.create(
      title: "Body",
      body: "<p>This is just a standard text page example. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin metus dolor, hendrerit sit amet, aliquet nec, posuere sed, purus. Nullam et velit iaculis odio sagittis placerat. Duis metus tellus, pellentesque ut, luctus id, egestas a, lorem. Praesent vitae mauris. Aliquam sed nulla. Sed id nunc vitae leo suscipit viverra. Proin at leo ut lacus consequat rhoncus. In hac habitasse platea dictumst. Nunc quis tortor sed libero hendrerit dapibus.\n\nInteger interdum purus id erat. Duis nec velit vitae dolor mattis euismod. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Suspendisse pellentesque dignissim lacus. Nulla semper euismod arcu. Suspendisse egestas, erat a consectetur dapibus, felis orci cursus eros, et sollicitudin purus urna et metus. Integer eget est sed nunc euismod vestibulum. Integer nulla dui, tristique in, euismod et, interdum imperdiet, enim. Mauris at lectus. Sed egestas tortor nec mi.</p>",
      position: 0
    )
    about_us_page.parts.create(
      title: "Side Body",
      body: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus fringilla nisi a elit. Duis ultricies orci ut arcu. Ut ac nibh. Duis blandit rhoncus magna. Pellentesque semper risus ut magna. Etiam pulvinar tellus eget diam. Morbi blandit. Donec pulvinar mauris at ligula. Sed pellentesque, ipsum id congue molestie, lectus risus egestas pede, ac viverra diam lacus ac urna. Aenean elit.</p>",
      position: 1
    )
  end
end

Refinery::I18n.frontend_locales.each do |lang|
  I18n.locale = lang
  {'home' => "Home",
   'page-not-found' => 'Page not found',
   'about' => 'About'
  }.each do |slug, title|
    Refinery::Page.by_title(title).each do |page|
      page.update_attributes slug: slug
    end
  end
end

I18n.locale = ::Refinery::I18n.default_locale
