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
            <<-GRAPHQL
              mutation deletePage($input: DeletePageInput!) {
                deletePage(input: $input) {
                  page {
                    id
                  }
                }
              }
            GRAPHQL
          end

          subject { result }

          context 'Correct page id' do
            let(:variables) do
              {
                "input": {
                  "id": page.id
                }
              }
            end

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
