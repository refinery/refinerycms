# Base methods for CRUD actions
# Simply override any methods in your action controller you want to be customised
# Don't forget to add:
#   resources :plural_model_name_here
# to your routes.rb file.
# Full documentation about CRUD and resources go here:
# -> http://caboo.se/doc/classes/ActionController/Resources.html#M003716
# Example (add to your controller):
# crudify :foo, {:title_attribute => 'name'}

module Refinery
  module Crud

    def self.default_options(model_name)
      singular_name = model_name.to_s
      class_name = singular_name.camelize
      plural_name = singular_name.pluralize
      this_class = class_name.constantize

      {
        :title_attribute => "title",
        :order => ('position ASC' if this_class.table_exists? and this_class.column_names.include?('position')),
        :conditions => '',
        :sortable => true,
        :searchable => true,
        :include => [],
        :paging => true,
        :search_conditions => '',
        :redirect_to_url => "admin_#{plural_name}_url"
      }
    end

    def self.append_features(base)
      super
      base.extend(ClassMethods)
    end

    module ClassMethods

      def crudify(model_name, options = {})
        options = ::Refinery::Crud.default_options(model_name).merge(options)

        singular_name = model_name.to_s
        class_name = singular_name.camelize
        plural_name = singular_name.pluralize

        module_eval %(
          prepend_before_filter :find_#{singular_name},
                                :only => [:update, :destroy, :edit, :show]

          def new
            @#{singular_name} = #{class_name}.new
          end

          def create
            # if the position field exists, set this object as last object, given the conditions of this class.
            if #{class_name}.column_names.include?("position")
              params[:#{singular_name}].merge!({
                :position => ((#{class_name}.maximum(:position, :conditions => #{options[:conditions].inspect})||-1) + 1)
              })
            end

            if (@#{singular_name} = #{class_name}.create(params[:#{singular_name}])).valid?
              (request.xhr? ? flash.now : flash).notice = t(
                'refinery.crudify.created',
                :what => "'\#{@#{singular_name}.#{options[:title_attribute]}}'"
              )

              unless from_dialog?
                unless params[:continue_editing] =~ /true|on|1/
                  redirect_back_or_default(#{options[:redirect_to_url]})
                else
                  unless request.xhr?
                    redirect_to :back
                  else
                    render :partial => "/shared/message"
                  end
                end
              else
                render :text => "<script>parent.window.location = '\#{#{options[:redirect_to_url]}}';</script>"
              end
            else
              unless request.xhr?
                render :action => 'new'
              else
                render :partial => "/shared/admin/error_messages",
                       :locals => {
                         :object => @#{singular_name},
                         :include_object_name => true
                       }
              end
            end
          end

          def edit
            # object gets found by find_#{singular_name} function
          end

          def update
            if @#{singular_name}.update_attributes(params[:#{singular_name}])
              (request.xhr? ? flash.now : flash).notice = t(
                'refinery.crudify.updated',
                :what => "'\#{@#{singular_name}.#{options[:title_attribute]}}'"
              )

              unless from_dialog?
                unless params[:continue_editing] =~ /true|on|1/
                  redirect_back_or_default(#{options[:redirect_to_url]})
                else
                  unless request.xhr?
                    redirect_to :back
                  else
                    render :partial => "/shared/message"
                  end
                end
              else
                render :text => "<script>parent.window.location = '\#{#{options[:redirect_to_url]}}';</script>"
              end
            else
              unless request.xhr?
                render :action => 'edit'
              else
                render :partial => "/shared/admin/error_messages",
                       :locals => {
                         :object => @#{singular_name},
                         :include_object_name => true
                       }
              end
            end
          end

          def destroy
            # object gets found by find_#{singular_name} function
            title = @#{singular_name}.#{options[:title_attribute]}
            if @#{singular_name}.destroy
              flash.notice = t('refinery.crudify.destroyed', :what => "'\#{title}'")
            end

            redirect_to #{options[:redirect_to_url]}
          end

          # Finds one single result based on the id params.
          def find_#{singular_name}
            @#{singular_name} = #{class_name}.find(params[:id],
                                                   :include => #{options[:include].map(&:to_sym).inspect})
          end

          # Find the collection of @#{plural_name} based on the conditions specified into crudify
          # It will be ordered based on the conditions specified into crudify
          # And eager loading is applied as specified into crudify.
          def find_all_#{plural_name}(conditions = #{options[:conditions].inspect})
            @#{plural_name} = #{class_name}.where(conditions).includes(
                                #{options[:include].map(&:to_sym).inspect}
                              ).order("#{options[:order]}")
          end

          # Paginate a set of @#{plural_name} that may/may not already exist.
          def paginate_all_#{plural_name}
            # If we have already found a set then we don't need to again
            find_all_#{plural_name} if @#{plural_name}.nil?

            paging_options = {:page => params[:page]}

            # Seems will_paginate doesn't always use the implicit method.
            if #{class_name}.methods.map(&:to_sym).include?(:per_page)
              paging_options.update({:per_page => #{class_name}.per_page})
            end

            @#{plural_name} = @#{plural_name}.paginate(paging_options)
          end

          # Returns a weighted set of results based on the query specified by the user.
          def search_all_#{plural_name}
            # First find normal results.
            find_all_#{plural_name}(#{options[:search_conditions].inspect})

            # Now get weighted results by running the query against the results already found.
            @#{plural_name} = @#{plural_name}.with_query(params[:search])
          end

          # Ensure all methods are protected so that they should only be called
          # from within the current controller.
          protected :find_#{singular_name},
                    :find_all_#{plural_name},
                    :paginate_all_#{plural_name},
                    :search_all_#{plural_name}
        )

        # Methods that are only included when this controller is searchable.
        if options[:searchable]
          if options[:paging]
            module_eval %(
              def index
                search_all_#{plural_name} if searching?
                paginate_all_#{plural_name}
              end
            )
          else
            module_eval %(
              def index
                unless searching?
                  find_all_#{plural_name}
                else
                  search_all_#{plural_name}
                end
              end
            )
          end

        else
          if options[:paging]
            module_eval %(
              def index
                paginate_all_#{plural_name}
              end
            )
          else
            module_eval %(
              def index
                find_all_#{plural_name}
              end
            )
          end

        end

        if options[:sortable]
          module_eval %(
            def reorder
              find_all_#{plural_name}
            end

            # Based upon http://github.com/matenia/jQuery-Awesome-Nested-Set-Drag-and-Drop
            def update_positions
              previous = nil
              # The list doesn't come to us in the correct order. Frustration.
              0.upto((newlist ||= params[:ul]).length - 1) do |index|
                hash = newlist[index.to_s]
                moved_item_id = hash['id'].split(/#{singular_name}\\_?/)
                @current_#{singular_name} = #{class_name}.find_by_id(moved_item_id)

                if @current_#{singular_name}.respond_to?(:move_to_root)
                  if previous.present?
                    @current_#{singular_name}.move_to_right_of(#{class_name}.find_by_id(previous))
                  else
                    @current_#{singular_name}.move_to_root
                  end
                else
                  @current_#{singular_name}.update_attribute(:position, index)
                end

                if hash['children'].present?
                  update_child_positions(hash, @current_#{singular_name})
                end

                previous = moved_item_id
              end

              #{class_name}.rebuild! if #{class_name}.respond_to?(:rebuild!)
              render :nothing => true
            end

            def update_child_positions(node, #{singular_name})
              0.upto(node['children'].length - 1) do |child_index|
                child = node['children'][child_index.to_s]
                child_id = child['id'].split(/#{singular_name}\_?/)
                child_#{singular_name} = #{class_name}.find_by_id(child_id)
                child_#{singular_name}.move_to_child_of(#{singular_name})

                if child['children'].present?
                  update_child_positions(child, child_#{singular_name})
                end
              end
            end

          )
        end

        module_eval %(
          def self.sortable?
            #{options[:sortable].to_s}
          end

          def self.searchable?
            #{options[:searchable].to_s}
          end
        )


      end

    end

  end
end
