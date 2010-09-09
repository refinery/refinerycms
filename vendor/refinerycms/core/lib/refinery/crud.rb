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
              unless request.xhr?
                flash[:notice] = t('refinery.crudify.created',
                                   :what => "'\#{@#{singular_name}.#{options[:title_attribute]}}'")
              else
                flash.now[:notice] = t('refinery.crudify.created',
                                       :what => "'\#{@#{singular_name}.#{options[:title_attribute]}}'")
              end
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
              unless request.xhr?
                flash[:notice] = t('refinery.crudify.updated',
                                   :what => "'\#{@#{singular_name}.#{options[:title_attribute]}}'")
              else
                flash.now[:notice] = t('refinery.crudify.updated',
                                       :what => "'\#{@#{singular_name}.#{options[:title_attribute]}}'")
              end
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
              newlist = params[:ul]                                     # assign the sorted tree to a variable
              previous = nil                                            # initialize the previous item
              newlist.each_with_index do |array, index|                 #loop through each item in the new list (passed via ajax)
                moved_item_id = array[1][:id].split(/#{singular_name}/) # get the #{singular_name} id of the item being moved
                @current_#{singular_name} = #{class_name}.find_by_id(moved_item_id)  # find the object that is being moved (in database)
                unless previous.nil?                                    # if this is the first item being moved, move it to the root.
                  @previous_item = #{class_name}.find_by_id(previous)
                  @current_#{singular_name}.move_to_right_of(@previous_item)
                else
                   @current_#{singular_name}.move_to_root
                end
                unless array[1][:children].blank?          # then, if this item has children we need to loop through them
                  childstuff(array[1], @current_#{singular_name})  # NOTE: unless there are no children in the array, send it to the recursive children function
                end
                previous = moved_item_id                   # set previous to the last moved item, for the next round
              end
              #{class_name}.rebuild!
              render :nothing => true
            end

            def childstuff(mynode, #{singular_name})
              for child in mynode[:children]                    # loop through it's children
                child_id = child[1][:id].split(/#{singular_name}/)     # get the child id from each child passed into the node (the array)
                child_#{singular_name} = #{class_name}.find_by_id(child_id)  # find the matching category in the database
                child_#{singular_name}.move_to_child_of(#{singular_name})       # move the child to the selected category
                unless child[1][:children].blank?               # loop through the children if any
                  childstuff(child[1], child_#{singular_name})          # if there are children - run them through the same process
                end
              end
            end

          )
        end

      end

    end

  end
end
