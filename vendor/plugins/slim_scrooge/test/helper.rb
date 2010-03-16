require File.join(File.dirname(__FILE__), 'setup')
require 'active_support/test_case'

module SlimScrooge
  class Test
    class << self

      def setup
        setup_constants
        make_sqlite_config
        make_sqlite_connection
        load_models
        load(SCHEMA_ROOT + "/schema.rb")
        require 'test/unit'
      end

      def test_files
        glob("#{File.dirname(__FILE__)}/**/*_test.rb")
      end

      def test_model_files
        %w{course}
      end

      private

      def setup_constants
        set_constant('TEST_ROOT') {File.expand_path(File.dirname(__FILE__))}
        set_constant('SCHEMA_ROOT') {TEST_ROOT + "/schema"}
      end
      
      def make_sqlite_config
        ActiveRecord::Base.configurations = {
          'db' => {
            :adapter => 'sqlite3',
            :database => 'test_db',
            :timeout => 5000
          }
        }
      end
      
      def load_models
        test_model_files.each {|f| require File.join(File.dirname(__FILE__), "models", f)}
      end

      def make_sqlite_connection
        ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['db'])
      end
      
      def set_constant(constant)
        Object.const_set(constant, yield) unless Object.const_defined?(constant)
      end
      
      def glob(pattern)
        Dir.glob(pattern)
      end
    end
  end
  
  class ActiveRecordTest < Test
    class << self
      def setup
        setup_constants
      end
      
      def test_files
        glob("#{AR_TEST_SUITE}/cases/**/*_test.rb").sort
      end

      def connection
        File.join(AR_TEST_SUITE, 'connections', 'native_mysql')
      end

      private

      def setup_constants
        set_constant('MYSQL_DB_USER') {'rails'}
        set_constant('AR_TEST_SUITE') {find_active_record_test_suite}
      end
 
      def find_active_record_test_suite
        ts = ($:).grep(/activerecord/).last.split('/')
        ts.pop
        ts << 'test'
        ts.join('/')
      end
    end

    AR_TEST_SUITE = find_active_record_test_suite
  end
end
