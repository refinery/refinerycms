# frozen_string_literal: true

def index_entry
  'li.record.page'
end

def index_item(id)
  [id, '.item'].join(' ')
end

#  various edit actions selectors: there are several in a single index entry
#  1. the page title is wrapped in an edit link
#     <a class="title edit" href="/refinery/pages/.../edit" tooltip="Edit this page">page title</a>
#  2. if there are several locales there is an edit_in_locale link for each locale
#     <a id="es" class="edit locale_icon locale" href="/refinery/pages/.../edit?switch_locale=es" tooltip=page_title></a>
#  3. the actions group has an edit icon with a link to edit the page (equivalent to 1)
#     <a class="edit_icon edit" href="/refinery/pages/.../edit" tooltip="Edit this page"></a>
#
def edit_selector(class_name: nil, locale: nil, slug: nil)
  class_selector = [class_name, 'edit'].compact.join('.')
  query_selector = ("?switch_locale=#{locale}" if locale.present?)
  "a.#{class_selector}[href$='#{slug}/edit#{query_selector}']"
end

def title_link_selector(slug: '')
  edit_selector(slug: slug, class_name: :title)
end

def icon_link_selector(slug: '')
  edit_selector(slug: slug, class_name: :edit_icon)
end

def locale_link_selector(locale:, slug: '')
  edit_selector(slug: slug, class_name: :locale, locale: locale.downcase)
end

def locales
  "span.locales"
end

def locale_picker(locale)
  ".locales ##{locale}"
end
