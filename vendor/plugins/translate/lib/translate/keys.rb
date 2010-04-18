require 'pathname'

class Translate::Keys
  # Allows keys extracted from lookups in files to be cached
  def self.files
    @@files ||= Translate::Keys.new.files
  end

  # Allows flushing of the files cache
  def self.files=(files)
    @@files = files
  end

  def files
    @files ||= extract_files
  end
  alias_method :to_hash, :files

  def keys
    files.keys
  end
  alias_method :to_a, :keys

  def i18n_keys(locale)
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    extract_i18n_keys(I18n.backend.send(:translations)[locale.to_sym]).sort
  end

  # Convert something like:
  #
  # {
  #  :pressrelease => {
  #    :label => {
  #      :one => "Pressmeddelande"
  #    }
  #   }
  # }
  #
  # to:
  #
  #  {'pressrelease.label.one' => "Pressmeddelande"}
  #
  def self.to_shallow_hash(hash)
    hash.inject({}) do |shallow_hash, (key, value)|
      if value.is_a?(Hash)
        to_shallow_hash(value).each do |sub_key, sub_value|
          shallow_hash[[key, sub_key].join(".")] = sub_value
        end
      else
        shallow_hash[key.to_s] = value
      end
      shallow_hash
    end
  end

  # Convert something like:
  #
  #  {'pressrelease.label.one' => "Pressmeddelande"}
  #
  # to:
  #
  # {
  #  :pressrelease => {
  #    :label => {
  #      :one => "Pressmeddelande"
  #    }
  #   }
  # }
  def self.to_deep_hash(hash)
    hash.inject({}) do |deep_hash, (key, value)|
      keys = key.to_s.split('.').reverse
      leaf_key = keys.shift
      key_hash = keys.inject({leaf_key.to_sym => value}) { |hash, key| {key.to_sym => hash} }
      deep_merge!(deep_hash, key_hash)
      deep_hash
    end
  end

  # deep_merge by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
  def self.deep_merge!(hash1, hash2)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    hash1.merge!(hash2, &merger)
  end

  private
  def extract_i18n_keys(hash, parent_keys = [])
    hash.inject([]) do |keys, (key, value)|
      full_key = parent_keys + [key]
      if value.is_a?(Hash)
        # Nested hash
        keys += extract_i18n_keys(value, full_key)
      elsif value.present?
        # String leaf node
        keys << full_key.join(".")
      end
      keys
    end
  end

  def extract_files
    files_to_scan.inject(HashWithIndifferentAccess.new) do |files, file|
      IO.read(file).scan(i18n_lookup_pattern).flatten.map(&:to_sym).each do |key|
        files[key] ||= []
        path = Pathname.new(File.expand_path(file)).relative_path_from(Pathname.new(Rails.root)).to_s
        files[key] << path unless files[key].include?(path)
      end
      files
    end
  end

  def i18n_lookup_pattern
    /\b(?:I18n\.t|I18n\.translate|t)(?:\s|\():?'([a-z0-9_]+.[a-z0-9_.]+)'\)?/
  end

  def files_to_scan
    Dir.glob(File.join(files_root_dir, "{app,config,lib}", "**","*.{rb,erb,rhtml}")) +
      Dir.glob(File.join(files_root_dir, "public", "javascripts", "**","*.js"))
  end

  def files_root_dir
    Rails.root
  end
end
