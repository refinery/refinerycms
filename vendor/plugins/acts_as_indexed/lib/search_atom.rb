# ActsAsIndexed
# Copyright (c) 2007 Douglas F Shearer.
# http://douglasfshearer.com
# Distributed under the MIT license as included with this plugin.

module Foo #:nodoc:
  module Acts #:nodoc:
    module Indexed #:nodoc:
      class SearchAtom

        # Contains a hash of records.
        # { 'record_id' => [pos1, pos2, pos] }
        #--
        # Weighting:
        # http://www.perlmonks.com/index.pl?node_id=27509
        # W(T, D) = tf(T, D) * log ( DN / df(T))
        # weighting = frequency_in_this_record * log (total_number_of_records / number_of_matching_records)

        def initialize
          @records = {}
        end

        # Returns true if the given record is present.
        def include_record?(record_id)
          @records.include?(record_id)
        end

        # Adds +record_id+ to the stored records.
        def add_record(record_id)
          @records[record_id] = [] if !include_record?(record_id)
        end

        # Adds +pos+ to the array of positions for +record_id+.
        def add_position(record_id, pos)
          add_record(record_id)
          @records[record_id] << pos
        end

        # Returns all record IDs stored in this Atom.
        def record_ids
          @records.keys
        end

        # Returns an array of positions for +record_id+ stored in this Atom.
        def positions(record_id)
          return @records[records] if include_record?(record_id)
          nil
        end

        # Removes +record_id+ from this Atom.
        def remove_record(record_id)
          @records.delete(record_id)
        end

        # Returns at atom containing the records and positions of +self+ preceded by +former+
        # "former latter" or "big dog" where "big" is the former and "dog" is the latter.
        def preceded_by(former)
          matches = SearchAtom.new
          latter = {}
          former.record_ids.each do |rid|
            latter[rid] = @records[rid] if @records[rid]
          end
          # Iterate over each record in latter.
          latter.each do |record_id,pos|

            # Iterate over each position.
            pos.each do |p|
              # Check if previous position is in former.
              if former.include_position?(record_id,p-1)
                matches.add_record(record_id) if !matches.include_record?(record_id)
                matches.add_position(record_id,p)
              end
            end

          end
          return matches
        end

        # Returns a hash of record_ids and weightings for each record in the
        # atom.
        def weightings(records_size)
          out = {}
          @records.each do |r_id, pos|

            # Fixes a bug when the records_size is zero. i.e. The only record
            # contaning the word has been deleted.
            if records_size < 1
              out[r_id] = 0.0
              next
            end

            # weighting = frequency * log (records.size / records_with_atom)
            ## parndt 2010/05/03 changed to records_size.to_f to avoid -Infinity Errno::ERANGE exceptions
            ## which would happen for example Math.log(1 / 20) == -Infinity but Math.log(1.0 / 20) == -2.99573227355399
            out[r_id] = pos.size * Math.log(records_size.to_f / @records.size)
          end
          out
        end

        protected

        def include_position?(record_id,pos)
          @records[record_id].include?(pos)
        end

      end
    end
  end
end
