class Hash

  # Merges new_hash into source_hash, without modifying arguments, but
  # will merge nested arrays and hashes too. Also will NOT merge nil or blank
  # from new_hash into old_hash.
  def safe_deep_merge(new_hash)
    dup.safe_deep_merge!(new_hash)
  end

  def safe_deep_merge!(new_hash)
    merge!(new_hash) do |key, old_val, new_val|
      if new_val.respond_to?(:blank) && new_val.blank?
        old_val   
      elsif (old_val.kind_of?(Hash) and new_val.kind_of?(Hash))
        safe_deep_merge!(old_val, new_val)
      elsif (old_val.kind_of?(Array) and new_val.kind_of?(Array))
        old_val.concat(new_val).uniq
      else
        new_val
      end
    end
  end

end

