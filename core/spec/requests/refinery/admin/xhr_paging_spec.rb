require "spec_helper"

module Refinery
  describe "Crudify" do
    refinery_login_with :refinery_superuser

    describe "xhr_paging", :js => true do
      # Refinery::Admin::UsersController specifies :order => 'username ASC' in crudify
      let(:first_user) { User.order('username ASC').first }
      let(:last_user) { User.order('username ASC').last }
      before do
        FactoryGirl.create :user
        Admin::UsersController.should_receive(:xhr_pageable?).
                               at_least(1).times.and_return(xhr_pageable)
        User.stub(:per_page).and_return(1)
      end

      describe 'when set to true' do
        let(:xhr_pageable) { true }
        it 'should perform ajax paging of index' do
          visit refinery.admin_users_path

          expect(page).to have_selector('li.record', :count => 1)
          expect(page).to have_content(first_user.email)

          within '.pagination' do
            click_link '2'
          end

          expect(page.evaluate_script('jQuery.active')).to eq(1)
          expect(page).to have_content(last_user.email)
        end
      end

      describe 'set to false' do
        let(:xhr_pageable) { false }
        it 'should not perform ajax paging of index' do
          visit refinery.admin_users_path

          expect(page).to have_selector('li.record', :count => 1)
          expect(page).to have_content(first_user.email)

          within '.pagination' do
            click_link '2'
          end

          expect(page.evaluate_script('jQuery.active')).to eq(0)
          expect(page).to have_content(last_user.email)

        end
      end
    end
  end

end
