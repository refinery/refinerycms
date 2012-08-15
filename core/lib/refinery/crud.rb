# Base methods for CRUD actions
# Simply override any methods in your action controller you want to be customised
# Don't forget to add:
#   resources :plural_model_name_here
# or for scoped:
#   scope(:as => 'module_module', :module => 'module_name') do
#      resources :plural_model_name_here
#    end
# to your routes.rb file.
# Full documentation about CRUD and resources go here:
# -> http://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Resources.html#method-i-resources
# Example (add to your controller):
# crudify :foo, :title_attribute => 'name' for CRUD on Foo model
# crudify :'foo/bar', :title_attribute => 'name' for CRUD on Foo::Bar model
# Note: @singular_name will result in @foo for :foo and @bar for :'foo/bar'

module Refinery
  module Crud

    def self.default_options(model_name)
      class_name = "#{model_name.to_s.camelize.gsub('/', '::')}".gsub('::::', '::')
      this_class = class_name.constantize.base_class
      singular_name = ActiveModel::Naming.param_key(this_class)
      plural_name = singular_name.pluralize

      {
        :conditions => '',
        :include => [],
        :order => ('position ASC' if this_class.table_exists? && this_class.column_names.include?('position')),
        :paging => true,
        :per_page => false,
        :redirect_to_url => "refinery.#{Refinery.route_for_model(class_name.constantize, :plural => true)}",
        :searchable => true,
        :search_conditions => '',
        :sortable => true,
        :title_attribute => "title",
        :xhr_paging => false,
        :class_name => class_name,
        :singular_name => singular_name,
        :plural_name => plural_name
      }
    end

    def self.append_features(base)
      super
      base.extend(ClassMethods)
    end

    module ClassMethods

      def crudify(model_name, options = {})
        options = ::Refinery::Crud.default_options(model_name).merge(options)
        class_name = options[:class_name]
        singular_name = options[:singular_name]
        plural_name = options[:plural_name]

        module_eval %(
          def self.crudify_options
            #{options.inspect}
          end

          prepend_before_filter :find_#{singular_name},
                                :only => [:update, :destroy, :edit, :show]

          def new
            @#{singular_name} = #{class_name}.new
          end

          def create
            # if the position field exists, set this object as last object, given the conditions of this class.
            if #{class_name}.column_names.include?("position") && params[:#{singular_name}][:position].nil?
              params[:#{singular_name}].merge!({
                :position => ((#{class_name}.maximum(:position, :conditions => #{options[:conditions].inspect})||-1) + 1)
              })
            end

            if (@#{singular_name} = #{class_name}.create(params[:#{singular_name}])).valid?
              flash.notice = t(
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
                    render :partial => '/refinery/message'
                  end
                end
              else
                self.index
                @dialog_successful = true
                render :index
              end
            else
              unless request.xhr?
                render :action => 'new'
              else
                render :partial => '/refinery/admin/error_messages', :locals => {
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
              flash.notice = t(
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
                    render :partial => '/refinery/message'
                  end
                end
              else
                self.index
                @dialog_successful = true
                render :index
              end
            else
              unless request.xhr?
                render :action => 'edit'
              else
                render :partial => '/refinery/admin/error_messages', :locals => {
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
              flash.notice = t('destroyed', :scope => 'refinery.crudify', :what => "'\#{title}'")
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

            per_page = if #{options[:per_page].present?.inspect}
              #{options[:per_page].inspect}
            elsif #{class_name}.methods.map(&:to_sym).include?(:per_page)
              #{class_name}.per_page
            end

            @#{plural_name} = @#{plural_name}.paginate(:page => params[:page], :per_page => per_page)
          end

          # If the controller is being accessed via an ajax request
          # then render only the collection of items.
          def render_partial_response?
            if request.xhr?
              render :text => render_to_string(:partial => '#{plural_name}', :layout => false).html_safe,
                     :layout => 'refinery/flash' and return false
            end
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
                    :render_partial_response?,
                    :search_all_#{plural_name}
        )

        # Methods that are only included when this controller is searchable.
        if options[:searchable]
          if options[:paging]
            module_eval %(
              def index
                search_all_#{plural_name} if searching?
                paginate_all_#{plural_name}

                render_partial_response?
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

                render_partial_response?
              end
            )
          end

        else
          if options[:paging]
            module_eval %(
              def index
                paginate_all_#{plural_name}

                render_partial_response?
              end
            )
          else
            module_eval %(
              def index
                find_all_#{plural_name}
                render_partial_response?
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
              params[:ul].each do |_, list|
                # After we drop Ruby 1.8.x support the following line can be changed back to
                # list.each do |index, hash|
                # because there won't be an ordering issue (see https://github.com/resolve/refinerycms/issues/1585)
                list.sort_by {|k, v| k.to_i}.map { |item| item[1] }.each_with_index do |hash, index|
                  moved_item_id = hash['id'].split(/#{singular_name}\_?/).reject(&:empty?).first
                  @current_#{singular_name} = #{class_name}.find_by_id(moved_item_id)

                  if @current_#{singular_name}.respond_to?(:move_to_root)
                    if previous.present?
                      @current_#{singular_name}.move_to_right_of(#{class_name}.find_by_id(previous))
                    else
                      @current_#{singular_name}.move_to_root
                    end
                  else
                    @current_#{singular_name}.update_attributes :position => index
                  end

                  if hash['children'].present?
                    update_child_positions(hash, @current_#{singular_name})
                  end

                  previous = moved_item_id
                end
              end

              #{class_name}.rebuild! if #{class_name}.respond_to?(:rebuild!)
              render :nothing => true
            end

            def update_child_positions(_node, #{singular_name})
              list = _node['children']['0']
              list.sort.map { |item| item[1] }.each_with_index do |child, index|
                child_id = child['id'].split(/#{singular_name}\_?/).reject(&:empty?).first
                child_#{singular_name} = #{class_name}.where(:id => child_id).first
                child_#{singular_name}.move_to_child_of(#{singular_name})

                if child['children'].present?
                  update_child_positions(child, child_#{singular_name})
                end
              end
            end
          )
        end

        module_eval %(
          class << self
            def pageable?
              #{options[:paging].to_s}
            end
            alias_method :paging?, :pageable?

            def sortable?
              #{options[:sortable].to_s}
            end

            def searchable?
              #{options[:searchable].to_s}
            end
          end
        )

      end

    end

  end
end
