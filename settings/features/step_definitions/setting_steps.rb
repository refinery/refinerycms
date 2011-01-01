Given /^I have no (?:|refinery )settings$/ do
  RefinerySetting.delete_all
end

Given /^I (only )?have a (?:|refinery )setting titled "([^\"]*)"$/ do |only, title|
  RefinerySetting.delete_all if only

  RefinerySetting.set(title.to_s.gsub(' ', '').underscore.to_sym, nil)
end
