Given /^I have pages titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Page.create(:title => title)
  end
end
