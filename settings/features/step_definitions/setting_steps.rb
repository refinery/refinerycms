Given /^I have no (?:|refinery )settings$/ do
  ::Refinery::Setting.delete_all
end

Given /^I (only )?have a (?:|refinery )setting titled "([^\"]*)"$/ do |only, title|
  ::Refinery::Setting.delete_all if only

  ::Refinery::Setting.set(title.to_s.gsub(' ', '').underscore.to_sym, nil)
end
