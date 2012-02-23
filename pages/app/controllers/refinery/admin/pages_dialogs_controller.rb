require 'net/http'

module ::Refinery
  module Admin
    class PagesDialogsController < ::Refinery::Admin::DialogsController

      def link_to
        # Get the switch_local variable to determine the locale we're currently editing
        # Set up Globalize with our current locale
        if ::Refinery.i18n_enabled?
          Thread.current[:globalize_locale] = params[:switch_locale] || Refinery::I18n.default_locale
        end

        @pages = ::Refinery::Page.roots.paginate(:page => params[:page], :per_page => ::Refinery::Page.per_page(true))

        @pages = @pages.with_globalize if ::Refinery.i18n_enabled?

        if ::Refinery::Plugins.registered.names.include?('refinery_files')
            @resources = Resource.paginate(:page => params[:resource_page], :per_page => Resource.per_page(true)).
                                  order('created_at DESC')

          # resource link
          if params[:current_link].present?
           is_resource_link = params[:current_link].include?("/system/resources")
          end
        end

        # web address link
        @web_address_text = "http://"
        @web_address_text = params[:current_link] if params[:current_link].to_s =~ /^http:\/\//
        @web_address_target_blank = (params[:target_blank] == "true")

        # mailto link
        if params[:current_link].present?
          if params[:current_link] =~ /^mailto:/
            @email_address_text = params[:current_link].split("mailto:")[1].split('?')[0]
          end
          @email_default_subject_text = params[:current_link].split('?subject=')[1] || params[:subject]
          @email_default_body_text = params[:current_link].split('?body=')[1] || params[:body]
        end

        if params[:paginating].present?
          @page_area_selected = (params[:paginating] == "your_page")
          @resource_area_selected = (params[:paginating] == "resource_file")
        else
          @page_area_selected = (!is_resource_link and @web_address_text == "http://" and @email_address_text.blank?)
          @web_address_area_selected = (@web_address_text != "http://")
          @email_address_area_selected = @email_address_text.present?
          @resource_area_selected = is_resource_link
        end
      end

      def test_url
        begin
          timeout(5) do
            unless params[:url].blank?
              url = URI.parse(params[:url])
              if url.host.nil? && params[:url].start_with?('/')
                url.host = URI.parse(request.url).host
              end

              result = case Net::HTTP.get_response(url)
                when Net::HTTPSuccess, Net::HTTPRedirection
                  'success'
                else
                  'failure'
                end

              render :json => {:result => result}
            end
          end
        rescue
          render :json => {:result => 'failure'}
        end
      end

      def test_email
        if params[:email].present?
          valid = params[:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

          render :json => if valid
            {:result => 'success'}
          else
            {:result => 'failure'}
          end
        end
      end

    end
  end
end
