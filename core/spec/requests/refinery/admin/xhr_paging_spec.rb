require "spec_helper"

module Refinery
  describe "Crudify" do
    refinery_login_with :refinery_superuser

    describe "xhr_paging", js:true do
      before do
        FactoryGirl.create(:user)
      end

      describe 'when set to true' do
        it 'should perform ajax paging of index' do
          Refinery::Admin::UsersController.should_receive(:xhr_pageable?).any_number_of_times.and_return(true)
          Refinery::User.should_receive(:per_page).any_number_of_times.and_return(1)

          visit refinery.admin_users_path

          expect(page).to have_selector('li.record', count: 1)
          expect(page).to have_content(Refinery::User.first.email)

          within '.pagination' do
            click_link '2'
          end

          expect(page.evaluate_script('jQuery.active')).to eq(1)
          expect(page).to have_content(Refinery::User.last.email)
        end
      end

      describe 'set to false' do
        it 'should not perform ajax paging of index' do
          Refinery::Admin::UsersController.should_receive(:xhr_pageable?).any_number_of_times.and_return(false)
          Refinery::User.should_receive(:per_page).any_number_of_times.and_return(1)

          visit refinery.admin_users_path

          expect(page).to have_selector('li.record', count: 1)
          expect(page).to have_content(Refinery::User.first.email)

          within '.pagination' do
            click_link '2'
          end

          expect(page.evaluate_script('jQuery.active')).to eq(0)
          expect(page).to have_content(Refinery::User.last.email)

        end
      end
    end
  end

end