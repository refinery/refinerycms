Given /^I have no <%= plural_name %>$/ do
  <%= class_name %>.delete_all
end

<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? -%>
Given /^I (only )?have <%= plural_name %> titled "?([^\"]*)"?$/ do |only, titles|
  <%= class_name %>.delete_all if only
  titles.split(', ').each do |title|
    <%= class_name %>.create(:<%= title.name %> => title)
  end
end
<% end -%>

Then /^I should have ([0-9]+) <%= plural_name.to_s.gsub(/ies$/, '[y|ies]+') %>?$/ do |count|
  <%= class_name %>.count.should == count.to_i
end
