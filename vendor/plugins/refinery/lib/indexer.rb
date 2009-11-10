module Indexer
  
  
  def self.sortalize(array)
    Marshal.load(Marshal.dump(array)).each do |element|
      element.sort! if element.is_a?(Array)
    end
  end
  
  def self.check_for_indexes(migration_format = false)
    model_names = []
    Dir.chdir(Rails.root) do 
      model_names = Dir["**/app/models/*.rb"].collect {|filename| File.basename(filename) }.uniq
    end

    model_classes = []
    model_names.each do |model_name|
      class_name = model_name.sub(/\.rb$/,'').camelize
      begin
        klass = class_name.split('::').inject(Object){ |klass,part| klass.const_get(part) }
        if klass < ActiveRecord::Base && !klass.abstract_class?
          model_classes << klass
        end
      rescue
        # No-op
      end
    end
    puts "Found #{model_classes.size} Models"

    @indexes_required = Hash.new([])
    @index_migrations = Hash.new([])

    model_classes.each do |class_name|

      # check if this is an STI child instance      
      if class_name.base_class.name != class_name.name && (class_name.column_names.include?(class_name.base_class.inheritance_column) || class_name.column_names.include?(class_name.inheritance_column))
        # add the inharitance column on the parent table
        if !(migration_format)
          @indexes_required[class_name.base_class.table_name] += [class_name.inheritance_column].sort unless  @indexes_required[class_name.base_class.table_name].include?([class_name.inheritance_column].sort)
        else
          # index migration for STI should require both the primary key and the inheritance_column in a composite index.
          @index_migrations[class_name.base_class.table_name] += [[class_name.inheritance_column, class_name.base_class.primary_key].sort] unless @index_migrations[class_name.base_class.table_name].include?([class_name.base_class.inheritance_column].sort)
        end
      end

      class_name.reflections.each_pair do |reflection_name, reflection_options|
        case reflection_options.macro
        when :belongs_to
          # polymorphic?
          @table_name = class_name.table_name.to_s #(reflection_options.options.has_key?(:class_name) ?  reflection_options.options[:class_name].constantize.table_name : )
          if reflection_options.options.has_key?(:polymorphic) && (reflection_options.options[:polymorphic] == true)
            poly_type = "#{reflection_options.name.to_s}_type"
            poly_id = "#{reflection_options.name.to_s}_id"
            if !(migration_format)
              @indexes_required[@table_name.to_s] += [poly_type, poly_id].sort unless @indexes_required[@table_name.to_s].include?([poly_type, poly_id].sort)
            else

              @index_migrations[@table_name.to_s] += [[poly_type, poly_id].sort] unless @index_migrations[@table_name.to_s].include?([poly_type, poly_id].sort)
            end
          else

            foreign_key = reflection_options.options[:foreign_key] ||= reflection_options.primary_key_name

            if !(migration_format)
              @indexes_required[@table_name.to_s] += [foreign_key] unless @indexes_required[@table_name.to_s].include?(foreign_key)
            else
              @index_migrations[@table_name.to_s] += [foreign_key] unless @index_migrations[@table_name.to_s].include?(foreign_key)
            end
          end
        when :has_and_belongs_to_many
          table_name = reflection_options.options[:join_table] ||= [class_name.table_name, reflection_name.to_s].sort.join('_')
          association_foreign_key = reflection_options.options[:association_foreign_key] ||= "#{reflection_name.to_s.singularize}_id"
          foreign_key = reflection_options.options[:foreign_key] ||= "#{class_name.name.tableize.singularize}_id"

          if !(migration_format)
            @indexes_required[table_name.to_s] += [association_foreign_key, foreign_key].sort unless @indexes_required[table_name].include?([association_foreign_key, foreign_key].sort)
          else
            @index_migrations[table_name.to_s] += [[association_foreign_key, foreign_key].sort] unless @index_migrations[table_name].include?([association_foreign_key, foreign_key].sort)
          end
        else
          #nothing
        end
      end
    end

    @missing_indexes = {}
    @indexes_required.each do |table_name, foreign_keys|

      unless foreign_keys.blank?
        existing_indexes = ActiveRecord::Base.connection.indexes(table_name.to_sym).collect(&:columns)
        keys_to_add = self.sortalize(foreign_keys.uniq) - self.sortalize(existing_indexes)
        @missing_indexes[table_name] = keys_to_add unless keys_to_add.empty?
      end
    end
    if !(migration_format)
      @missing_indexes
    else
      @index_migrations
    end
  end

  def self.scan_finds
    file_names = []
    Dir.chdir(Rails.root) do 
      file_names = Dir["**/app/**/*.rb"].uniq.reject {|file_with_path| file_with_path.include?('test')}
    end

    puts "Found #{file_names.size} files."

    @indexes_required = Hash.new([])
    file_names.each do |file_name| 
      current_file = File.open(File.join(Rails.root, file_name), 'r')

      current_file.each do |line|
        find_regexp = Regexp.new(/([A-Z]{1}[A-Za-z]+).(find){1}((_all){0,1}(_by_){0,1}([A-Za-z_]+))?\(([0-9A-Za-z"\':=>. \[\]{},]*)\)/)
        if matches = find_regexp.match(line)

          model_name, column_names, options = matches[1], matches[6], matches[7]
        #  puts "Model: #{model_name}, columns: #{column_names}, options: #{options}"
          
          if model_name.respond_to?(:constantize)
            if model_name.constantize.respond_to?(:table_name)             
              table_name = model_name.constantize.table_name
            else
              puts "Unable to get the table_name for #{model_name.to_s}. it could be an ActiveResource"
              next
            end
          else
            puts "Unable to constantize #{model_name.to_s}, if you are sure that #{model_name.to_s} is a valid class name, please file an issue on\nhttp://github.com/eladmeidar/rails_indexes\nPlease supply the relevant code as well, thanks. =)"
            next
          end

          if column_names.blank?
            primary_key = model_name.constantize.primary_key
            @indexes_required[table_name] += [primary_key] unless @indexes_required[table_name].include?(primary_key)
          else
            column_names = column_names.split('_and_')

            # remove find_by_sql references.
           # column_names.delete("sql")

            column_names = model_name.constantize.column_names & column_names

            # Check if there were more than 1 column
            if column_names.size == 1
              column_name = column_names.first
              @indexes_required[table_name] += [column_name] unless @indexes_required[table_name].include?(column_name)
            else
              @indexes_required[table_name] += [column_names.sort] unless @indexes_required[table_name].include?(column_names.sort)
            end
          end
        end
      end
    end
    @missing_indexes = {}
    @indexes_required.each do |table_name, foreign_keys|

      unless foreign_keys.blank?
        existing_indexes = ActiveRecord::Base.connection.indexes(table_name.to_sym).collect(&:columns)
        keys_to_add = self.sortalize(foreign_keys.uniq) - self.sortalize(existing_indexes)
        @missing_indexes[table_name] = keys_to_add unless keys_to_add.empty?
      end
    end
    
    @indexes_required
  end
  
  def self.key_exists?(table,key_columns)     
    result = (key_columns.to_a - ActiveRecord::Base.connection.indexes(table).map { |i| i.columns }.flatten)
    result.empty?
  end
  
  def self.simple_migration
    migration_format = true
    missing_indexes = check_for_indexes(migration_format)

    unless missing_indexes.keys.empty?
      add = []
      remove = []
      missing_indexes.each do |table_name, keys_to_add|
        keys_to_add.each do |key|
          next if key_exists?(table_name,key)
          next if key.blank?
          if key.is_a?(Array)
            keys = key.collect {|k| ":#{k}"}
            add << "add_index :#{table_name}, [#{keys.join(', ')}]"
            remove << "remove_index :#{table_name}, :column => [#{keys.join(', ')}]"
          else
            add << "add_index :#{table_name}, :#{key}"
            remove << "remove_index :#{table_name}, :#{key}"
          end
          
        end
      end
      
      migration = <<EOM  
class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    
    # These indexes were found by searching for AR::Base finds on your application
    # It is strongly recommanded that you will consult a professional DBA about your infrastucture and implemntation before
    # changing your database in that matter.
    # There is a possibility that some of the indexes offered below is not required and can be removed and not added, if you require
    # further assistance with your rails application, database infrastructure or any other problem, visit:
    #
    # http://www.railsmentors.org
    # http://www.railstutor.org
    # http://guides.rubyonrails.org

    
    #{add.uniq.join("\n    ")}
  end
  
  def self.down
    #{remove.uniq.join("\n    ")}
  end
end
EOM

      puts "## Drop this into a file in db/migrate ##"
      puts migration
    end
  end
  
  def self.indexes_list
    check_for_indexes.each do |table_name, keys_to_add|
      puts "Table '#{table_name}' => #{keys_to_add.to_sentence}"
    end
  end
  
  def self.ar_find_indexes
    find_indexes = self.scan_finds
    
    unless find_indexes.keys.empty?
      add = []
      remove = []
      find_indexes.each do |table_name, keys_to_add|
        keys_to_add.each do |key|
          next if key_exists?(table_name,key)
          next if key.blank?
          if key.is_a?(Array)
            keys = key.collect {|k| ":#{k}"}
            add << "add_index :#{table_name}, [#{keys.join(', ')}]"
            remove << "remove_index :#{table_name}, :column => [#{keys.join(', ')}]"
          else
            add << "add_index :#{table_name}, :#{key}"
            remove << "remove_index :#{table_name}, :#{key}"
          end
          
        end
      end
      
      migration = <<EOM      
class AddFindsMissingIndexes < ActiveRecord::Migration
  def self.up
    
    # These indexes were found by searching for AR::Base finds on your application
    # It is strongly recommanded that you will consult a professional DBA about your infrastucture and implemntation before
    # changing your database in that matter.
    # There is a possibility that some of the indexes offered below is not required and can be removed and not added, if you require
    # further assistance with your rails application, database infrastructure or any other problem, visit:
    #
    # http://www.railsmentors.org
    # http://www.railstutor.org
    # http://guides.rubyonrails.org
    
    #{add.uniq.join("\n    ")}
  end
  
  def self.down
    #{remove.uniq.join("\n    ")}
  end
end
EOM

      puts "## Drop this into a file in db/migrate ##"
      puts migration
    end
  end
end