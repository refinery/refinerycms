# frozen_string_literal: true

module GeneratorSpec
  module Matcher
    class Directory
      def description
        'match a directory structure'
      end
    end

    class File
      def description
        'match a file'
      end
    end
  end
end
