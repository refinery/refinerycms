Given /^I have no inquiries$/ do
  Inquiry.delete_all
end

Then /^I should have ([0-9]+) inquiries?$/ do |count|
  Inquiry.count.should == count.to_i
end

Given /^I have an inquiry from "([^"]*)" with email "([^\"]*)" and message "([^\"]*)"$/ do |name, email, message|
  Inquiry.create(:name => name,
                 :email => email,
                 :message => message)
end

Given /^I have test inquiry titled "([^"]*)"$/ do |title|
  Inquiry.create(:name => title,
                 :email => 'test@cukes.com',
                 :message => 'cuking ...',
                 :spam => false)

  Inquiry.create(:name => title,
                 :email => 'test@cukes.com',
                 :message => 'cuking ...',
                 :spam => true)
end
