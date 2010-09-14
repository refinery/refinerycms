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

    def self.append_features(base)
      super
      base.extend(ClassMethods)
    end

    module ClassMethods

      def crudify(model_name, new_options = {})
        singular_name = model_name.to_s
        class_name = singular_name.camelize
        plural_name = singular_name.pluralize

        options = {
          :title_attribute => "title",
          :order => 'position ASC',
          :conditions => '',
          :sortable => true,
          :searchable => true,
          :include => [],
          :paging => true,
          :search_conditions => '',
          :redirect_to_url => "admin_#{plural_name}_url"
        }.merge!(new_options)

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
                :position => ((#{class_name}.maximum(:position, :conditions => "#{options[:conditions]}")||-1) + 1)
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
                render :text => "<script type='text/javascript'>parent.window.location = '\#{#{options[:redirect_to_url]}}';</script>"
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
                render :text => "<script type='text/javascript'>parent.window.location = '\#{#{options[:redirect_to_url]}}';</script>"
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
            if @#{singular_name}.destroy
              flash[:notice] = t('refinery.crudify.destroyed',
                                 :what => "'\#{@#{singular_name}.#{options[:title_attribute]}}'")
            end
            redirect_to #{options[:redirect_to_url]}
          end

          def find_#{singular_name}
            @#{singular_name} = #{class_name}.find(params[:id],
                                                   :include => %w(#{options[:include].join(' ')}))
          end

          def find_all_#{plural_name}
            @#{plural_name} = #{class_name}.find(
              :all,
              :order => "#{options[:order]}",
              :conditions => "#{options[:conditions]}",
              :include => %w(#{options[:include].join(' ')})
            )
          end

          def paginate_all_#{plural_name}
            @#{plural_name} = #{class_name}.paginate(
              :page => params[:page],
              :order => "#{options[:order]}",
              :conditions => "#{options[:conditions]}",
              :include => %w(#{options[:include].join(' ')})
            )
          end

          def search_all_#{plural_name}
            @#{plural_name} = #{class_name}.with_query(params[:search]).find(
              :all,
              :order => "#{options[:order]}",
              :conditions => "#{options[:search_conditions]}",
              :include => %w(#{options[:include].join(' ')})
            )
          end

          def search_and_paginate_all_#{plural_name}
            @#{plural_name} = #{class_name}.with_query(params[:search]).paginate(
              :page => params[:page],
              :order => "#{options[:order]}",
              :conditions => "#{options[:search_conditions]}",
              :include => %w(#{options[:include].join(' ')})
            )
          end

          protected :find_#{singular_name},
                    :find_all_#{plural_name},
                    :paginate_all_#{plural_name},
                    :search_all_#{plural_name},
                    :search_and_paginate_all_#{plural_name}

        )

        if options[:searchable]
          if options[:paging]
            module_eval %(
              def index
                if searching?
                  search_and_paginate_all_#{plural_name}
                else
                  paginate_all_#{plural_name}
                end
              end
            )
          else
            module_eval %(
              def index
                if searching?
                  search_all_#{plural_name}
                else
                  find_all_#{plural_name}
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
              newlist = params[:ul]
              previous = nil
              # The list doesn't come to us in the correct order. Frustration.
              index = 0
              while index < newlist.length do
                hash = newlist[index.to_s]
                moved_item_id = hash['id'].split(/#{singular_name}/)
                @current_#{singular_name} = #{class_name}.find_by_id(moved_item_id)

                if previous.present?
                  @previous_item = #{class_name}.find_by_id(previous)
                  @current_#{singular_name}.move_to_right_of(@previous_item)
                else
                   @current_#{singular_name}.move_to_root
                end

                if hash['children'].present?
                  update_child_positions(hash, @current_#{singular_name})
                end

                previous = moved_item_id
                index += 1
              end
              #{class_name}.rebuild!
              render :nothing => true
            end

            def update_child_positions(node, #{singular_name})
              child_index = 0
              while child_index < node['children'].length do
                child = node['children'][child_index.to_s]
                child_id = child['id'].split(/#{singular_name}/)
                child_#{singular_name} = #{class_name}.find_by_id(child_id)
                child_#{singular_name}.move_to_child_of(#{singular_name})

                if child['children'].present?
                  update_child_positions(child, child_#{singular_name})
                end

                child_index += 1
              end
            end

          )
        end

      end

    end

  end
end
