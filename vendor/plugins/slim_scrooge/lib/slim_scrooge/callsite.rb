# Author: Stephen Sykes

module SlimScrooge
  # A Callsite contains the list of columns that are accessed when an SQL
  # query is made from a particular place in the app
  #
  class Callsite
    ScroogeComma = ",".freeze 
    ScroogeRegexJoin = /(?:LEFT|INNER|OUTER|CROSS)*\s*(?:STRAIGHT_JOIN|JOIN)/i

    attr_accessor :seen_columns
    attr_reader :columns_hash, :primary_key, :model_class_name

    class << self
      # Make a callsite if the query is of the right type for us to optimise
      #
      def make_callsite(model_class, original_sql)
        if use_scrooge?(model_class, original_sql)
          new(model_class)
        else
          nil
        end
      end

      # Check if query can be optimised
      #
      def use_scrooge?(model_class, original_sql)
        original_sql =~ select_regexp(model_class.table_name) && 
        model_class.columns_hash.has_key?(model_class.primary_key) && 
        original_sql !~ ScroogeRegexJoin
      end
      
      # The regexp that enables us to replace the * from SELECT * with
      # the list of columns we actually need
      #
      def select_regexp(table_name)
        %r{SELECT (`?(?:#{table_name})?`?.?\\*) FROM}
      end
    end

    def initialize(model_class)
      @all_columns = SimpleSet.new(model_class.column_names)
      @model_class_name = model_class.to_s
      @quoted_table_name = model_class.quoted_table_name
      @primary_key = model_class.primary_key
      @quoted_primary_key = model_class.connection.quote_column_name(@primary_key)
      @columns_hash = model_class.columns_hash
      @select_regexp = self.class.select_regexp(model_class.table_name)
      @seen_columns = SimpleSet.new(essential_columns(model_class))
    end

    # List of columns that should always be fetched no matter what
    #
    def essential_columns(model_class)
      model_class.reflect_on_all_associations.inject([@primary_key]) do |arr, assoc|
        if assoc.options[:dependent] && assoc.macro == :belongs_to
          arr << assoc.association_foreign_key
        end
        arr
      end
    end

    # Returns suitable sql given a list of columns and the original query
    #
    def scrooged_sql(seen_columns, sql)
      sql.gsub(@select_regexp, "SELECT #{scrooge_select_sql(seen_columns)} FROM")
    end
    
    # List if columns what were not fetched
    #
    def missing_columns(fetched_columns)
      (@all_columns - SimpleSet.new(fetched_columns)) << @primary_key
    end
    
    # Returns sql for fetching the unfetched columns for all the rows
    # in the result set, specified by primary_keys
    #
    def reload_sql(primary_keys, fetched_columns)
      sql_keys = primary_keys.collect{|pk| "'#{pk}'"}.join(ScroogeComma)
      cols = scrooge_select_sql(missing_columns(fetched_columns))
      "SELECT #{cols} FROM #{@quoted_table_name} WHERE #{@quoted_primary_key} IN (#{sql_keys})"
    end

    def connection
      @model_class_name.constantize.connection
    end

    # Change a set of columns into a correctly quoted comma separated list
    #
    def scrooge_select_sql(set)
      set.collect do |name|
        "#{@quoted_table_name}.#{connection.quote_column_name(name)}"
      end.join(ScroogeComma)
    end
  end
end
