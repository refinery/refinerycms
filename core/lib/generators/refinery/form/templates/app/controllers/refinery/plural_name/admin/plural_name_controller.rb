module Refinery
  module <%= class_name.pluralize %>
    module Admin
      class <%= class_name.pluralize %>Controller < Refinery::AdminController

        crudify :<%= singular_name %>, <% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? %>
                :title_attribute => "<%= title.name %>", <% end %>
                :order => "created_at DESC"
      <% if @includes_spam %>
        before_filter :get_spam_count, :only => [:index, :spam]

        def index
          @<%= plural_name %> = find_all_<%= plural_name %>.ham
          @<%= plural_name %> = @<%= plural_name %>.with_query(params[:search]) if searching?

          @grouped_<%= plural_name %> = group_by_date(@<%= plural_name %>)
        end

        def spam
          @<%= plural_name %> = find_all_<%= plural_name %>.spam
          @<%= plural_name %> = @<%= plural_name %>.with_query(params[:search]) if searching?

          @grouped_<%= plural_name %> = group_by_date(@<%= plural_name %>)
        end

        def toggle_spam
          find_<%= singular_name %>
          @<%= singular_name %>.toggle!(:spam)

          redirect_to :back
        end

      protected

        def get_spam_count
          @spam_count = <%= class_name %>.count(:conditions => {:spam => true})
        end
      <% else %>
        def index
          unless searching?
            find_all_<%= plural_name %>
          else
            search_all_<%= plural_name %>
          end

          @grouped_<%= plural_name %> = group_by_date(@<%= plural_name %>)
        end

      <% end %>

      end
    end
  end
end
