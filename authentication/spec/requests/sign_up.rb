require 'spec_helper'

module Refinery
  module Users
    
    describe 'user sign up' do
      before(:each) do
        User.delete_all
      end
      
      describe 'when there are no users' do
        it 'invites us to create a user' do
          visit root_url
          find("h1", :text => "There are no users yet, so we'll set you up first")
        end
        
        it 'allows user creation' do
          # Verify that we can access the sign up page.
          visit root_url
          click_link "Continue..."
          find("h1", :text => "Fill out your details below so that we can get you started.")
          
          # Fill in user details.
          fill_in 'Username', :with => 'rspec'
          fill_in 'Email', :with => 'rspec@example.com'
          fill_in 'Password', :with => 'spectacular'
          fill_in 'Password confirmation', :with => 'spectacular'
          
          # Sign up and verify!
          click_button "Sign up"
          find("h2", :text => "Welcome to Refinery, rspec.")
          find("h2", :text => "Latest Activity")
          User.count.should == 1
        end
      end
    end
  end
end
