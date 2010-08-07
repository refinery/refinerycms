# Base methods for CRUD actions
# Simply override any methods in your action controller you want to be customised
# Don't forget to add:
#   map.resources :plural_model_name_here
# to your routes.rb file.
# Full documentation about CRUD and resources go here:
# -> http://caboo.se/doc/classes/ActionController/Resources.html#M003716
# Example (add to your controller):
# crudify :foo, {:title_attribute => 'name'}

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
        before_filter :find_#{singular_name},
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
              render :partial => "/shared/admin/error_messages_for",
                     :locals => {
                       :symbol => :#{singular_name},
                       :object => @#{singular_name}
                     }
            end
          end
        end

        def edit
          @#{singular_name} = #{class_name}.find(params[:id])
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
              render :partial => "/shared/admin/error_messages_for",
                     :locals => {
                       :symbol => :#{singular_name},
                       :object => @#{singular_name}
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
            unless params[:tree] == "true"
              params[:sortable_list].each_with_index do |i, index|
                #{class_name}.find(i).update_attribute(:position, index)
              end
            else
              params[:sortable_list].each do |position, id_hash|
                parse_branch(position, id_hash, nil)
              end
            end

            find_all_#{plural_name}
            render :partial => 'sortable_list',
                   :layout => false,
                   :locals => {
                     :continue_reordering => params[:continue_reordering]
                   }
          end

          # takes in a single branch and saves the nodes inside it
          def parse_branch(position, id_hash, parent_id)
            id_hash.each do |pos, id|
              parse_branch(pos, id, id_hash["id"]) unless pos == "id"
            end if id_hash.include?('0')

            #{class_name}.update_all(["parent_id = ?, position = ?", parent_id, position], ["id = ?", id_hash["id"]])
          end

          protected :parse_branch
        )
      end

    end

  end

end
