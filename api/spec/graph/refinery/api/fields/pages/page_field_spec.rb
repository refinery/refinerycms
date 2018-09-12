# frozen_string_literal: true

require 'spec_helper'

module Refinery
  module Api
    module Fields
      module Pages
        describe 'PageField' do

          let!(:page) { FactoryBot.create(:page) }

          let(:context) { {  } }
          let(:variables) { { } }

          let(:result) do
            GraphqlSchema.execute(
              query_string,
              context: context,
              variables: variables
            )
          end

          let(:query_string) do
            <<-GRAPHQL
              query($id: ID!) {
                page(id: $id) {
                  title
                }
              }
            GRAPHQL
          end

          subject { result }

          context "as a normal user" do
            let(:variables) do
              {'query' => '', 'id' => page.id }
            end

            it 'returns a page' do
              subject
              expect(result['data']['page']['title']).to eq(page.title)
            end
          end
        end
      end
    end
  end
end
