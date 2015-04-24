# These precompile sets are split for readablity
# scripts
 Rails.application.config.assets.precompile += %w(
  refinery/*.js
  refinery/icons/*
  modernizr-min.js
  admin.js
)
# stylesheets
Rails.application.config.assets.precompile += %w(
  refinery/refinery.css
  refinery/formatting.css
  refinery/site_bar.css
  refinery/theme.css
  refinery/icons/*
)
# images
Rails.application.config.assets.precompile += %w(
  refinery/icons/*
)
# fonts
Rails.application.config.assets.precompile += %w(
  font-awesome/fontawesome-webfont.eot
  font-awesome/fontawesome-webfont.woff2
  font-awesome/fontawesome-webfont.woff
  font-awesome/fontawesome-webfont.ttf
  font-awesome/fontawesome-webfont.svg)
