module Refinery
  module <%= class_name.pluralize %>
    class <%= class_name.pluralize %>Controller < ::ApplicationController

      before_filter :find_page, :only => [:create, :new]

      def index
        redirect_to :action => "new"
      end

      def thank_you
        @page = Refinery::Page.find_by_link_url("/<%= plural_name %>/thank_you", :include => [:parts])
      end

      def new
        @<%= singular_name %> = <%= class_name %>.new
      end

      def create
        @<%= singular_name %> = <%= class_name %>.new(params[:<%= singular_name %>])

        if @<%= singular_name %>.save
          begin
            Mailer.notification(@<%= singular_name %>, request).deliver
          rescue
            logger.warn "There was an error delivering an <%= singular_name %> notification.\n#{$!}\n"
          end<% if @includes_spam %> if @<%= singular_name %>.ham?<% end %>
          
          if <%= class_name %>.column_names.map(&:to_s).include?('email')
            begin
              Mailer.confirmation(@<%= singular_name %>, request).deliver
            rescue
              logger.warn "There was an error delivering an foo confirmation:\n#{$!}\n"
            end<% if @includes_spam %> if @<%= singular_name %>.ham?<% end %>
          else
            logger.warn "Please add an 'email' field to <%= class_name %> if you wish to send confirmation emails when forms are submitted."
          end

          redirect_to refinery.thank_you_<%= namespacing.underscore %>_<%= plural_name %>_path
        else
          render :action => 'new'
        end
      end

    protected

      def find_page
        @page = Refinery::Page.find_by_link_url('/<%= plural_name %>/new', :include => [:parts])
      end

    end
  end
end
