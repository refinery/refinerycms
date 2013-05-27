require 'spec_helper'

module Refinery
  describe User do
    let(:user) { FactoryGirl.create(:user) }

    context "Locales" do
      let(:locale_list) { ['en', 'de', 'fr', 'it'] }
      before { user.locales = locale_list }

      it "have a locales attribute" do
        user.should respond_to :locales
      end

      it "returns locales in ASC order" do
        sorted_locales = locale_list.sort
        user.locales[0].locale.should == sorted_locales[0]
        user.locales[1].locale.should == sorted_locales[1]
        user.locales[2].locale.should == sorted_locales[2]
        user.locales[3].locale.should == sorted_locales[3]
      end

      it "deletes associated locales" do
        user.destroy
        UserLocale.find_by_user_id(user.id).should be_nil
      end

      it "assigns locales to user" do
        user.locales.collect(&:locale).should == locale_list.sort
      end
    end
  end
end
