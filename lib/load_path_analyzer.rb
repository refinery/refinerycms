class LoadPathAnalyzer

  def initialize(load_path, loaded_features)
    @load_path       = load_path
    @loaded_features = loaded_features
  end

  def frequencies
    load_paths.inject({}) {|a, v|
      a[v] ||= 0
      a[v] += 1
      a
    }
  end

  private

  def load_paths
    @loaded_features.map {|feature|
      @load_path.detect {|path|
        feature[0, path.length] == path
      }
    }.compact
  end

end
