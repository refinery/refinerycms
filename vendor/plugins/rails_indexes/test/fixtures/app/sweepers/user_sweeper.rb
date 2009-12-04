class UserSweeper < ActionController::Caching::Sweeper
  # This sweeper is going to keep an eye on the Product model
  observe User

  # If our sweeper detects that a Product was created call this
  def after_create(product)
    logger.info "Sweeped!"
  end
end