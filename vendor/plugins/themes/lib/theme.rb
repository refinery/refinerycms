class Theme

  def self.current_theme(env)
    RefinerySetting[:theme]
  end

end
