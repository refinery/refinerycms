# frozen_string_literal: true

require 'spec_helper'

module Refinery
  module Api
    module Fields
      module Pages
        describe 'PagesField' do

          let!(:page) { FactoryBot.create(:page) }

          let(:context) { { } }
          let(:variables) { {} }

          let(:result) do
            GraphqlSchema.execute(
              query_string,
              context: context,
              variables: variables
            )
          end

          let(:query_string) do
            <<-QUERY
query {
  pages {
    title
  }
}
            QUERY
          end

          context "as a normal user" do
            it 'returns the page fields' do
              page_result = result['data']['pages'].first
              expect(page_result).to include(
                                'title' => page.title,
                              )
            end
          end
        end
      end
    end
  end
  end
