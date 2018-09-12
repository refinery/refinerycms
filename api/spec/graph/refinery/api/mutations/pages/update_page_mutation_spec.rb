# frozen_string_literal: true

require 'spec_helper'

module Refinery
  module Api
    module Mutations
      module Pages
        describe 'UpdatePageMutation' do
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
            <<~QUERY
              mutation updatePage($input: UpdatePageInput!) {
                updatePage(input: $input) {
                  page {
                    id
                    title
                  }
                }
              }
            QUERY
          end

          subject { result }

          context 'as an admin' do
            context 'update a page' do
              let(:variables) do
                {
                  "input": {
                    "id": page.id,
                    "page": {
                      "title": "Updated test page"
                    }
                  }
                }
              end

              it 'returns the page id and title of the newly created page' do
                subject
                expect(result['data']['updatePage']['page']['id']).to eq(page.id)
                expect(result['data']['updatePage']['page']['title']).to eq('Updated test page')
              end
            end
          end
        end
      end
    end
  end
end
