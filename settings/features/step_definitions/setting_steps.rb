Given /^I have no (?:|refinery )settings$/ do
  ::Refinery::RefinerySetting.delete_all
end

Given /^I (only )?have a (?:|refinery )setting titled "([^\"]*)"$/ do |only, title|
  ::Refinery::RefinerySetting.delete_all if only

  ::Refinery::RefinerySetting.set(title.to_s.gsub(' ', '').underscore.to_sym, nil)
end
