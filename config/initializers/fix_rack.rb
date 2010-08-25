# TEMPORARY SOLUTION
# Remove when Rack is fixed upstream
module Rack
  module Utils
    def escape(s)
      regexp = case
        when RUBY_VERSION >= "1.9" && s.encoding === Encoding.find('UTF-8')
          /([^ a-zA-Z0-9_.-]+)/u
        else
          /([^ a-zA-Z0-9_.-]+)/n
        end
      s.to_s.gsub(regexp) {
        '%'+$1.unpack('H2'*bytesize($1)).join('%').upcase
      }.tr(' ', '+')
    end
  end
end
