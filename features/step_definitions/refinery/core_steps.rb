# Login stuff
Given %r`not logged in$` do
  visit logout_path
end

Given %r`(?:log|am logged) in as "([^\"]+)"$` do |login|
  @my_username = login
  visit login_path
  And %Q`enter the username "#{login}"`
  And %Q`enter the password "#{login}-123"`
  And "press the login button"
end

Then 'I should( not)? see a login form' do |negative|
  expect_opposite_if(negative) do
    response.should have_tag('form#new_user_session') do
      field_labeled('Username').should_not be_nil
      field_labeled('Password', :password).should_not be_nil
    end
  end
end

When %r`enter the username "(.+)"$` do |login|
  fill_in 'user_session[login]'   , :with => login
end

When %r`enter the password "(.+)-123"$` do |login|
  fill_in 'user_session[password]', :with => "#{login}-123"
end

When %r`press the login button$` do
  click_button 'Sign In'
end

Then %r`not be allowed to log in$` do
  When %Q`log in as "#{@my_username}"`
  Then 'I should see a login form'
end

Then %r`be redirected to login$` do
  request.request_uri.should == login_path
end

Then /^"([^\"]*)" can log in$/ do |name|
  user = User.find_by_login!(name)
  visit login_path
  When %Q`I enter the username "#{name}"`
  And %Q`I enter the password "#{name}-123"`
  And 'I press the login button'
  Then 'I should not see a login form'
end

Then /^I should be redirected back to "([^"]*)"$/ do |page_name|
  visit path_to(page_name)
end
