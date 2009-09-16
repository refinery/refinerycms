# WillPaginateSearch
# Copyright (c) 2007 Douglas F Shearer.
# http://douglasfshearer.com

module WillPaginate

  module Finder

    module ClassMethods


      def paginate_search(query, options)

        page, per_page, total_entries = wp_parse_options(options)
        
        total_entries ||= find_with_index(query,{},{:ids_only => true}).size

        returning WillPaginate::Collection.new(page, per_page, total_entries) do |pager|
          options.update :offset => pager.offset, :limit => pager.per_page

          options = options.delete_if {|key, value| [:page, :per_page].include?(key) }

          pager.replace find_with_index(query, options)
        end
      end

    end
  end
end
