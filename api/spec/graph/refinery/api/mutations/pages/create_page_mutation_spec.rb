# frozen_string_literal: true

require 'spec_helper'

module Refinery
  module Api
    module Mutations
      module Pages
        describe 'CreatePageMutation' do
          let(:logged_in_user) { Refinery::Core::NilUser.new }

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
              mutation createPage($input: CreatePageInput!) {
                createPage(input: $input) {
                  page {
                    title
                  }
                }
              }
            GRAPHQL
          end

          subject { result }

          context 'as an admin' do
            context 'create a page' do
              let(:variables) do
                {
                  "input": {
                    "page": {
                      "title": "Test page"
                    }
                  }
                }
              end

              it 'returns the page title of the newly created page' do
                subject
                expect(result['data']['createPage']['page']['title']).to eq('Test page')
              end
            end
          end
        end
      end
    end
  end
end
