require "spec_helper"

module Refinery
  describe "Crudify", type: :feature do
    refinery_login_with :refinery_superuser

    describe "xhr_paging", :js do
      # Refinery::Admin::UsersController specifies :order => 'username ASC' in crudify
      let(:first_user) { User.order('username ASC').first }
      let(:last_user) { User.order('username ASC').last }
      let!(:user) { FactoryGirl.create :user }
      before do
        allow(User).to receive(:per_page).and_return(1)
      end

      it 'performs ajax paging of index' do
        visit refinery.admin_users_path

        expect(page).to have_selector('li.record', count: 1)
        expect(page).to have_content(first_user.email)

        # placeholder which would disappear in a full page refresh.
        page.evaluate_script(
          %{$('body').append('<i id="has_not_refreshed_entire_page"/>')}
        )

        within '.pagination' do
          click_link '2'
        end

        expect(page).to have_content(last_user.email)
        expect(page.evaluate_script(
          %{$('i#has_not_refreshed_entire_page').length}
        )).to eq(1)
      end
    end
  end

end
