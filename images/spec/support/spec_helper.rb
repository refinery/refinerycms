module Capybara
  class Session
    def has_image?(src)
      has_xpath?("//img[contains(@src,'#{src}')]")
    end
  end

  add_selector(:linkhref) do
    xpath {|href| ".//a[@href='#{href}']"}
  end
end

def ensure_on(path)
  visit(path) unless current_path == path
end
