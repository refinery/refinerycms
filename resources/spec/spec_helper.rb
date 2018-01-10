module Capybara

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

def uri_filename(url)
  File.basename(URI.parse(url).path)
end
