module HtmlHelpers
  RSpec::Matchers.define :xml_eq do |expected|
    match do |actual|
      Hash.from_xml(expected) == Hash.from_xml(actual)
    end
  end
end
