module Refinery
  module MenuHelper

    # Adds conditional caching
    def cache_if(condition, name = {}, &block)
      if condition
        cache(name, &block)
      else
        yield
      end

      # for <%= style helpers vs <% style
      nil
    end

    # This was extracted from app/views/refinery/_menu_branch.html.erb
    # to remove the complexity of that template by reducing logic in the view.
    def menu_branch_css(local_assigns)
      options = local_assigns.dup
      options.update(:sibling_count => options[:menu_branch].shown_siblings.length) unless options[:sibling_count]

      css = []
      css << Refinery::Core.menu_css[:selected] if selected_page_or_descendant_page_selected?(local_assigns[:menu_branch]) unless Refinery::Core.menu_css[:selected].nil?
      css << Refinery::Core.menu_css[:first] if options[:menu_branch_counter] == 0 unless Refinery::Core.menu_css[:first].nil?
      css << Refinery::Core.menu_css[:last] if options[:menu_branch_counter] == options[:sibling_count] unless Refinery::Core.menu_css[:last].nil?
      css
    end

    # Determines whether any page underneath the supplied page is the current page according to rails.
    # Just calls selected_page? for each descendant of the supplied page
    # unless it first quickly determines that there are no descendants.
    def descendant_page_selected?(page)
      (page.rgt != page.lft + 1) && page.descendants.any? { |descendant| selected_page?(descendant) }
    end

    def selected_page_or_descendant_page_selected?(page)
      selected_page?(page) || descendant_page_selected?(page)
    end

    # Determine whether the supplied page is the currently open page according to Refinery.
    def selected_page?(page)
      path = request.path
      path = path.force_encoding('utf-8') if path.respond_to?(:force_encoding)

      # Ensure we match the path without the locale, if present.
      if path =~ %r{^/#{::I18n.locale}/}
        path = path.split(%r{^/#{::I18n.locale}}).last
        path = "/" if path.blank?
      end

      # First try to match against a "menu match" value, if available.
      return true if page.try(:menu_match).present? && path =~ Regexp.new(page.menu_match)

      # Find the first url that is a string.
      url = [page.url]
      url << ['', page.url[:path]].compact.flatten.join('/') if page.url.respond_to?(:keys)
      url = url.last.match(%r{^/#{::I18n.locale.to_s}(/.*)}) ? $1 : url.detect{|u| u.is_a?(String)}

      # Now use all possible vectors to try to find a valid match
      [path, URI.decode(path)].include?(url) || path == "/#{page.original_id}"
    end

  end
end
