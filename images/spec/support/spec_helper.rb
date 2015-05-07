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

RSpec.configure do |c|
  c.alias_it_should_behave_like_to :it_has_behaviour, 'has behaviour:'
end
