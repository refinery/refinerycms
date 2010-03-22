class Theme

  def self.current_theme(request = nil)
    RefinerySetting[:theme]
  end

end
