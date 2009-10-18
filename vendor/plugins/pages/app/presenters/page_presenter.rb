class PagePresenter < BasePresenter
  delegate DEFAULT_FIELDS.keys :to => :model
end
