module Refinery
  module PagesHelper

    def sanitize_hash(input_hash)
      sanitized_hash = HashWithIndifferentAccess.new
      input_hash.each do |key, value|
        # ActionPack's sanitize calls html_safe on sanitized input.
        sanitized_hash[key] = if value.respond_to? :html_safe
          sanitize value
        elsif value.respond_to? :each
          sanitize_hash value
        else
          value
        end
      end
      sanitized_hash
    end

  end
end
