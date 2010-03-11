# Author: Stephen Sykes

module SlimScrooge
  # A MonitoredHash allows us to return only some columns into the @attributes
  # of an ActiveRecord model object, but to notice when an attribute that
  # wasn't fetched is accessed.
  #
  # Also, when a result is first fetched for a particular callsite, we monitor
  # all the columns so that we can immediately learn which columns are needed.
  #
  class MonitoredHash < Hash
    attr_accessor :callsite, :result_set, :monitored_columns
    
    # Create a monitored hash.  The unmonitored_columns are accessed like a regular
    # hash.  The monitored columns kept separately, and new_column_access is called
    # before they are returned.
    #
    def self.[](monitored_columns, unmonitored_columns, callsite)
      hash = MonitoredHash.new {|hash, key| hash.new_column_access(key)}
      hash.monitored_columns = monitored_columns
      hash.merge!(unmonitored_columns)
      hash.callsite = callsite
      hash
    end
    
    # Called when an unknown column is requested, through the default proc.
    # If the column requested is valid, and the result set is not completely
    # loaded, then we reload.  Otherwise just note the column with add_seen_column.
    #
    def new_column_access(name)
      if @callsite.columns_hash.has_key?(name)
        @result_set.reload! if @result_set && name != @callsite.primary_key
        Callsites.add_seen_column(@callsite, name)
      end
      @monitored_columns[name]
    end
    
    # Reload if needed before allowing assignment
    #
    def []=(name, value)
      if has_key?(name)
        return super
      elsif @result_set && @callsite.columns_hash.has_key?(name)
        @result_set.reload!
        Callsites.add_seen_column(@callsite, name)
      end
      @monitored_columns[name] = value
    end
    
    # Returns the column names
    #
    def keys
      @result_set ? @callsite.columns_hash.keys : super | @monitored_columns.keys
    end
    
    # Check for a column name
    #
    def has_key?(name)
      @result_set ? @callsite.columns_hash.has_key?(name) : super || @monitored_columns.has_key?(name)
    end
    
    alias_method :include?, :has_key?
    
    # Called by Hash#update when reload is called on an ActiveRecord object
    #
    def to_hash
      @result_set.reload! if @result_set
      @monitored_columns.merge(self)
    end
    
    def freeze
      @result_set.reload! if @result_set
      @monitored_columns.freeze
      super
    end
    
    # Marshal
    # Dump a real hash - can't dump a monitored hash due to default proc
    #
    def _dump(depth)
      Marshal.dump(to_hash)
    end
    
    def self._load(str)
      Marshal.load(str)
    end
  end
end

# We need to change the update method of Hash so that it *always* calls
# to_hash.  This is because it normally checks if other_hash is a kind of
# Hash, and doesn't bother calling to_hash if so.  But we need it to call
# to_hash, because otherwise update will not get the complete columns
# from a MonitoredHash
#
# This is not harmful - to_hash in a regular Hash just returns self.
#
class Hash
  alias_method :c_update, :update
  def update(other_hash, &block)
    c_update(other_hash.to_hash, &block)
  end
end
