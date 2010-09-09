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

            def update_positions
              #{class_name}.update_all({
                #{class_name}.acts_as_nested_set_options[:left_column] => nil,
                #{class_name}.acts_as_nested_set_options[:right_column] => nil
              })

              #{class_name}.update_all(:depth => nil) if #{class_name}.column_names.map(&:to_sym).include?(:depth)

              unless params[:tree] == "true"
                params[:sortable_list].sort.each_with_index do |i, index|
                  #{class_name}.find(i).send(:set_default_left_and_right)
                end
              else
                set_root_positions(sortable_tree_from_params(params[:sortable_list]))
              end

              find_all_#{plural_name}
              render :partial => 'sortable_list',
                     :layout => false,
                     :locals => {
                       :continue_reordering => params[:continue_reordering]
                     }
            end

            def set_root_positions(tree)
              left_counter = 0
              tree.each do |root|
                left_counter = set_positions(root, left_counter)
              end
            end

            def set_positions(hash, parent_left = 0, parent_id = nil)
              left_counter = parent_left + 1;
              #{class_name.downcase} = hash[:node]
              #{class_name.downcase}[:lft] = left_counter

              hash[:children].each do |child|
                left_counter = set_positions(child, left_counter, hash[:node].id)
              end

              left_counter += 1
              #{class_name.downcase}[:rgt] = left_counter
              #{class_name.downcase}.save
              #{class_name}.update_all(["parent_id = ?", parent_id], ["id = ?", #{class_name.downcase}.id])

              return left_counter
            end

            def sortable_tree_from_params(sortable_list)
              # Get the list in order
              sortable_list = sortable_list.map{|k, v| [k.to_i, v]}.sort_by{|k,v| k}.map{|k,v| v}

              # Make something meaningful
              sortable_list.collect do |item|
                extract_nodes(item)
              end.compact#.flatten.compact.reject{|v| v == 0}
            end

            def extract_nodes(item)
              if (id = item.collect{|i| i.detect{|j| j != 'id'} if i.first == 'id'}.compact.first).present?
                children = item.reject{|i| i.first == 'id'}
                {:node => #{class_name}.find(id), :children => children.collect { |position, child| extract_nodes(child)}}
              else
                nil
              end
            end

            protected :set_root_positions, :set_positions, :sortable_tree_from_params, :extract_nodes

            # takes in a single branch and saves the nodes inside it
            def parse_branch(position, id_hash, parent_id)
              id_hash.each do |pos, id|
                parse_branch(pos, id, id_hash["id"]) unless pos == "id"
              end if id_hash.include?('0')

              node = #{class_name}.find(id_hash["id"])
              node.parent_id = parent_id
              node.send(:set_default_left_and_right)
              node.save
            end

            protected :parse_branch
          )
        end

      end

    end

  end
end