# Author: Stephen Sykes

module SlimScrooge
  module FindBySql
    def self.included(base)
      ActiveRecord::Base.extend ClassMethods
      class << base
        alias_method_chain :find_by_sql, :slim_scrooge
      end
    end

    module ClassMethods
      def find_by_sql_with_slim_scrooge(sql)
        return find_by_sql_without_slim_scrooge(sql) if sql.is_a?(Array) # don't mess with user's custom query
        callsite_key = SlimScrooge::Callsites.callsite_key(sql)
        if SlimScrooge::Callsites.has_key?(callsite_key)
          find_with_callsite_key(sql, callsite_key)
        elsif callsite = SlimScrooge::Callsites.create(sql, callsite_key, name)  # new site that is scroogeable
          rows = connection.select_all(sql, "#{name} Load SlimScrooged 1st time")
          rows.collect! {|row| instantiate(MonitoredHash[row, {}, callsite])}
        else
          find_by_sql_without_slim_scrooge(sql)
        end
      end

      private

      def find_with_callsite_key(sql, callsite_key)
        if callsite = SlimScrooge::Callsites[callsite_key]
          seen_columns = callsite.seen_columns.dup          # dup so cols aren't changed underneath us
          rows = connection.select_all(callsite.scrooged_sql(seen_columns, sql), "#{name} Load SlimScrooged")
          rows.collect! {|row| MonitoredHash[{}, row, callsite]}
          result_set = SlimScrooge::ResultSet.new(rows.dup, callsite_key, seen_columns)
          rows.collect! do |row|
            row.result_set = result_set
            instantiate(row)
          end
        else
          find_by_sql_without_slim_scrooge(sql)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, SlimScrooge::FindBySql)
