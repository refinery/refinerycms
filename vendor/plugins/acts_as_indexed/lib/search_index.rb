# ActsAsIndexed
# Copyright (c) 2007 Douglas F Shearer.
# http://douglasfshearer.com
# Distributed under the MIT license as included with this plugin.

module Foo #:nodoc:
  module Acts #:nodoc:
    module Indexed #:nodoc:
      class SearchIndex

        # root:: Location of index on filesystem.
        # index_depth:: Degree of index partitioning.
        # fields:: Fields or instance methods of ActiveRecord model to be indexed.
        # min_word_size:: Smallest query term that will be run through search.
        def initialize(root, index_depth, fields, min_word_size)
          @root = root
          @fields = fields
          @index_depth = index_depth
          @atoms = {}
          @min_word_size = min_word_size
          @records_size = exists? ? load_record_size : 0
        end

        # Adds +record+ to the index.
        def add_record(record)
          condensed_record = condense_record(record)
          load_atoms(condensed_record)
          add_occurences(condensed_record,record.id)
          @records_size += 1
        end

        # Adds multiple records to the index. Accepts an array of +records+.
        def add_records(records)
          records.each do |r|
            condensed_record = condense_record(r)
            load_atoms(condensed_record)
            add_occurences(condensed_record,r.id)
            @records_size += 1
          end
        end

        # Removes +record+ from the index.
        def remove_record(record)
          atoms = condense_record(record)
          load_atoms(atoms)
          atoms.each do |a|
            @atoms[a].remove_record(record.id) if @atoms.has_key?(a)
            @records_size -= 1
            #p "removing #{record.id} from #{a}"
          end
        end

        def update_record(record_new, record_old)
          # Work out which atoms have modifications.
          # Minimises loading and saving of partitions.
          old_atoms = condense_record(record_old)
          new_atoms = condense_record(record_new)

          # Remove the old version from the appropriate atoms.
          load_atoms(old_atoms)
          old_atoms.each do |a|
            @atoms[a].remove_record(record_new.id) if @atoms.has_key?(a)
          end

          # Add the new version to the appropriate atoms.
          load_atoms(new_atoms)
          # TODO: Make a version of this method that takes the
          # atomised version of the record.
          add_occurences(new_atoms, record_new.id)
        end

        # Saves the current index partitions to the filesystem.
        def save
          prepare
          atoms_sorted = {}
          @atoms.each do |atom_name, records|
            e_p = encoded_prefix(atom_name)
            atoms_sorted[e_p] = {} if !atoms_sorted.has_key?(e_p)
            atoms_sorted[e_p][atom_name] = records
          end
          atoms_sorted.each do |e_p, atoms|
            #p "Saving #{e_p}."
            File.open(File.join(@root + [e_p.to_s]),'w+') do |f|
              Marshal.dump(atoms,f)
            end
          end
          save_record_size
        end

        # Deletes the current model's index from the filesystem.
        #--
        # TODO: Write a public method that will delete all indexes.
        def destroy
          FileUtils.rm_rf(@root)
          true
        end

        # Returns an array of IDs for records matching +query+.
        def search(query)
          load_atoms(cleanup_atoms(query))
          return [] if query.nil?
          queries = parse_query(query.dup)
          positive = run_queries(queries[:positive])
          positive_quoted = run_quoted_queries(queries[:positive_quoted])
          negative = run_queries(queries[:negative])
          negative_quoted = run_quoted_queries(queries[:negative_quoted])

          if !queries[:positive].empty? && !queries[:positive_quoted].empty?
            p = positive.delete_if{ |r_id,w| !positive_quoted.include?(r_id) }
            pq = positive_quoted.delete_if{ |r_id,w| !positive.include?(r_id) }
            results = p.merge(pq) { |r_id,old_val,new_val| old_val + new_val}
          elsif !queries[:positive].empty?
            results = positive
          else
            results = positive_quoted
          end

          negative_results = (negative.keys + negative_quoted.keys)
          results.delete_if { |r_id, w| negative_results.include?(r_id) }
          #p results
          results
        end

        # Returns true if the index root exists on the FS.
        #--
        # TODO: Make a private method called 'root_exists?' which checks for the root directory.
        def exists?
          File.exists?(File.join(@root + ['size']))
        end

        private

        # Gets the size file from the index.
        def load_record_size
          File.open(File.join(@root + ['size'])) do |f|
            return (Marshal.load(f))
          end
        end

        # Saves the size to the size file.
        def save_record_size
          File.open(File.join(@root + ['size']),'w+') do |f|
            Marshal.dump(@records_size,f)
          end
        end

        # Returns true if the given atom is present.
        def include_atom?(atom)
          @atoms.has_key?(atom)
        end

        # Returns true if all the given atoms are present.
        def include_atoms?(atoms_arr)
          atoms_arr.each do |a|
            return false if !include_atom?(a)
          end
          true
        end

        # Returns true if the given record is present.
        def include_record?(record_id)
          @atoms.each do |atomname, atom|
            return true if atom.include_record?(record_id)
          end
        end

        def add_atom(atom)
          @atoms[atom] = SearchAtom.new if !include_atom?(atom)
        end

        def add_occurences(condensed_record,record_id)
          condensed_record.each_with_index do |atom, i|
            add_atom(atom)
            @atoms[atom].add_position(record_id, i)
            #p "adding #{record.id} to #{atom}"
          end
        end

        def encoded_prefix(atom)
          prefix = atom[0,@index_depth]
          if !@prefix_cache || !@prefix_cache.has_key?(prefix)
            @prefix_cache = {} if !@prefix_cache
            len = atom.length
            if len > 1
              @prefix_cache[prefix] = prefix.split(//).map{|c| encode_character(c)}.join('_')
            else
              @prefix_cache[prefix] = encode_character(atom)
            end
          end
          @prefix_cache[prefix]
        end

        # Allows compatibility with 1.8.6 which has no ord method.
        def encode_character(char)
          if @@has_ord ||= char.respond_to?(:ord)
            char.ord.to_s
          else
            char[0]
          end
        end

        def parse_query(s)

          # Find -"foo bar".
          negative_quoted = []
          while neg_quoted = s.slice!(/-\"[^\"]*\"/)
            negative_quoted << cleanup_atoms(neg_quoted)
          end

          # Find "foo bar".
          positive_quoted = []
          while pos_quoted = s.slice!(/\"[^\"]*\"/)
            positive_quoted << cleanup_atoms(pos_quoted)
          end

          # Find -foo.
          negative = []
          while neg = s.slice!(/-[\S]*/)
            negative << cleanup_atoms(neg).first
          end

          # Find +foo
          positive = []
          while pos = s.slice!(/\+[\S]*/)
            positive << cleanup_atoms(pos).first
          end

          # Find all other terms.
          positive += cleanup_atoms(s,true)

          return {:negative_quoted => negative_quoted, :positive_quoted => positive_quoted, :negative => negative, :positive => positive}
        end

        def run_queries(atoms)
          results = {}
          atoms.uniq.each do |atom|
            interim_results = {}
            if include_atom?(atom)

              interim_results = @atoms[atom].weightings(@records_size)
            end
            if results.empty?
              results = interim_results
            else
              rr = {}
              interim_results.each do |r,w|
                rr[r] = w + results[r] if results[r]
              end
              results = rr
            end
          end
          #p results
          results
        end

        def run_quoted_queries(quoted_atoms)
          results = {}
          quoted_atoms.each do |quoted_atom|
            interim_results = {}
            # Check the index contains all the required atoms.
            # match_atom = first_word_atom
            # for each of the others
            #   return atom containing records + positions where current atom is preceded by following atom.
            # end
            # return records from final atom.
            next if !include_atoms?(quoted_atom)
            matches = @atoms[quoted_atom.first]
            quoted_atom[1..-1].each do |atom_name|
              matches = @atoms[atom_name].preceded_by(matches)
            end
            #results += matches.record_ids

            interim_results = matches.weightings(@records_size)
            if results.empty?
              results = interim_results
            else
              rr = {}
              interim_results.each do |r,w|
                rr[r] = w + results[r] if results[r]
              end
              #p results.class
              results = rr
            end

          end
          return results
        end

        def load_atoms(atoms)
          # Remove duplicates
          # Remove atoms already in index.
          # Calculate prefixes.
          # Remove duplicates
          atoms.uniq.reject{|a| include_atom?(a)}.collect{|a| encoded_prefix(a)}.uniq.each do |name|
            if File.exists?(File.join(@root + [name.to_s]))
              File.open(File.join(@root + [name.to_s])) do |f|
                @atoms.merge!(Marshal.load(f))
              end
            end
          end
        end

        def prepare
          # Makes the RAILS_ROOT/index directory
          Dir.mkdir(File.join(@root[0,2])) if !File.exists?(File.join(@root[0,2]))
          # Makes the RAILS_ROOT/index/ENVIRONMENT directory
          Dir.mkdir(File.join(@root[0,3])) if !File.exists?(File.join(@root[0,3]))
          # Makes the RAILS_ROOT/index/ENVIRONMENT/CLASS directory
          Dir.mkdir(File.join(@root)) if !File.exists?(File.join(@root))
        end

        def cleanup_atoms(s, limit_size=false, min_size = @min_word_size || 3)
          atoms = s.downcase.gsub(/\W/,' ').squeeze(' ').split
          return atoms if !limit_size
          atoms.reject{|w| w.size < min_size}
        end

        def condense_record(record)
          record_condensed = ''
          @fields.each do |f|
            record_condensed += ' ' + record.send(f).to_s if record.send(f)
          end
          cleanup_atoms(record_condensed)
        end

      end
    end
  end
end
