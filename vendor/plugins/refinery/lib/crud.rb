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
      options = {:title_attribute => "title", :order => 'position ASC', :conditions => '', :sortable => true, :searchable => true}
      options.merge!(new_options)

      singular_name = model_name.to_s
      class_name = singular_name.camelize
      plural_name = singular_name.pluralize

      module_eval %(
        before_filter :find_#{singular_name}, :only => [:update, :destroy, :edit]
        before_filter :find_all_#{plural_name}, :only => :reorder
        
        def new
          @#{singular_name} = #{class_name}.new
        end

        def create
          @#{singular_name} = #{class_name}.create(params[:#{singular_name}])
          if @#{singular_name}.valid?
            flash[:notice] = "'\#{@#{singular_name}.#{options[:title_attribute]}}' was successfully created."
            redirect_to :action => 'index'
          else 
            render :action => 'new'
          end
        end
        
        def edit
          @#{singular_name} = #{class_name}.find(params[:id])
        end

        def update
          @#{singular_name}.update_attributes(params[:#{singular_name}])
          if @#{singular_name}.valid?
            flash[:notice] = "'\#{@#{singular_name}.#{options[:title_attribute]}}' was successfully updated."
            redirect_to admin_#{plural_name}_url
          else
            render :action => 'edit'
          end
        end

        def destroy
          if @#{singular_name}.destroy
            flash[:notice] = "'\#{@#{singular_name}.#{options[:title_attribute]}}' was successfully deleted."
          end
          redirect_to admin_#{plural_name}_url
        end

        def find_#{singular_name}
          @#{singular_name} = #{class_name}.find(params[:id])
        end
          
        def find_all_#{plural_name}
          @#{plural_name} = #{class_name}.find(:all, :order => "#{options[:order]}", :conditions => "#{options[:conditions]}")
        end
        
        protected :find_#{singular_name}, :find_all_#{plural_name}
      )
      
      if options[:searchable]
        module_eval %(
          def index
            unless params[:search].blank?
              @#{plural_name} = #{class_name}.paginate_search params[:search], :page => params[:page]
            else
              @#{plural_name} = #{class_name}.paginate :page => params[:page],
                                                       :order => "#{options[:order]}",
                                                       :conditions => "#{options[:conditions]}"
            end
          end
				)
      else
        module_eval %(
          def index
            @#{plural_name} = #{class_name}.paginate :page => params[:page],
                                                     :order => "#{options[:order]}",
                                                     :conditions => "#{options[:conditions]}"
					end
				)
      end
      
      if options[:sortable]
        module_eval %(
          def update_positions
            unless params[:tree] == "true"
              params[:sortable_list].each do |i|
                #{class_name}.find(i).update_attribute(:position, params[:sortable_list].index(i))
              end
            else
              params[:sortable_list].each do |position, id_hash|
              	parse_branch(position, id_hash, nil)
              end
            end

            find_all_#{plural_name}
            render :partial => 'sortable_list', :layout => false
          end
        
          # takes in a single branch and saves the nodes inside it
          def parse_branch(position, id_hash, parent_id)
            id_hash.each do |pos, id|
              parse_branch(pos, id, id_hash["id"]) unless pos == "id"
            end if id_hash.include?('0')

            #{class_name}.update(id_hash["id"], :parent_id => parent_id, :position => position)
          end
          
          protected :parse_branch
        )
      end
      
    end

  end

end