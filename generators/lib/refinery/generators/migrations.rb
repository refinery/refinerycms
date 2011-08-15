module Refinery
  module Generators
    module Migrations
      class << self
        def revoke(options = {})
          options = {:pattern => 'db/*.rb', :plural_name => nil, :singular_name => nil}.merge(options)
          migration_files = Pathname.glob(options[:pattern]).sort.map { |m|
            if options[:plural_name]
              m = m.to_s.gsub('plural_name', options[:plural_name])
            end
            if options[:singular_name]
              m = m.to_s.gsub('singular_name', options[:singular_name])
            end
            Pathname.new(m).basename.to_s.split(/^\d+_/).last
          }.reject{|m| m.blank?}

          if migration_files.any? and (migration_paths = Dir[Rails.root.join('db', 'migrate', "*#{migration_files.join(',')}")]).any?
            message = [""]
            message << "I found #{'a ' unless migration_paths.many?}migration#{'s' if migration_paths.many?} at:"
            message << migration_paths.join("\n")
            message << ""
            message << "Please ensure that you roll back these migrations if you used them (using rake db:rollback) and then run:"
            message << "\nrm #{migration_paths.join("\nrm ")}"
            message << "rm #{Rails.root.join('db', 'seeds', "#{options[:plural_name]}.rb")}" if options[:plural_name]
            message << "\nThis will ensure that nothing gets left behind in your database."
            message << "Note - be careful about rolling back if you have any migrations created after this one."
            message << "This is because Rails rolls back from the last migration backwards when rake db:rollback is invoked"
            message << "\n"
            puts message.join("\n")
          end
        end
      end
    end
  end
end