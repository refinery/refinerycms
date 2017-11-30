# frozen_string_literal: true

require 'spec_helper'

module Refinery
  module Api
    module Mutations
      module Pages
        describe 'DeletePageMutation' do
          let(:logged_in_user) { Refinery::Core::NilUser.new }

          let!(:page) { FactoryBot.create(:page) }

          let(:context) { {current_user: logged_in_user} }

          let(:result) do
            GraphqlSchema.execute(
              query_string,
              context: context,
              variables: variables
            )
          end

          let(:query_string) do
            <<-QUERY
mutation($page: DeletePageInput!) {
  delete_page(input: $page) {
    page {
      id
    }
  }
}
            QUERY
          end

          subject { result }

          context 'Correct page id' do
            let(:variables) { {'page' => { 'id' => page.id }} }

            it 'deletes the page' do
              subject
              expect(Refinery::Page.find_by_id(page.id)).to be(nil)
            end
          end
        end
      end
    end
  end
end
