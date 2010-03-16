# Author: Stephen Sykes

module SlimScrooge
  # A ResultSet contains all the rows found by an sql query
  # A call to reload! will cause all the rows in the set to be fully loaded
  # from the database - this should be called when a column access that hasn't previously
  # been seen by SlimScrooge is encountered
  #
  class ResultSet
    attr_reader :rows, :callsite_key
    
    def initialize(rows, callsite_key, fetched_columns)
      @rows = rows
      @callsite_key = callsite_key
      @fetched_columns = fetched_columns
    end
    
    def rows_by_key(key)
      @rows.inject({}) {|hash, row| hash[row[key]] = row; hash}
    end
    
    # Reload all the rows in the sql result at once
    # Reloads only those columns we didn't fetch the first time
    #
    def reload!
      callsite = Callsites[@callsite_key]
      rows_hash = rows_by_key(callsite.primary_key)
      sql = callsite.reload_sql(rows_hash.keys, @fetched_columns)
      new_rows = callsite.connection.send(:select, sql, "#{callsite.model_class_name} Reload SlimScrooged")
      new_rows.each do |row|
        if old_row = rows_hash[row[callsite.primary_key]]
          old_row.result_set = nil
          old_row.monitored_columns.merge!(row)
        end
      end
    end
  end
end
