require "spec_helper"

module Refinery
  module Admin
    describe PagesController, type: :controller do

      describe "valid templates" do
        before do
          File.write(Rails.root.join('tmp', 'abc.html.erb'), '')
          File.write(Rails.root.join('tmp', 'def.rb'), '')
          File.write(Rails.root.join('tmp', 'xyz.html.erb'), '')
          File.write(Rails.root.join('tmp', 'odd.file.name'), '')

          allow(Refinery::Pages).to receive(:use_layout_templates).and_return(true)
          allow(Refinery::Pages).to receive(:layout_template_whitelist).and_return(['abc', 'def'])
          allow(Refinery::Pages).to receive(:layout_templates_pattern).and_return(['tmp', '*html*'])
          allow(Refinery::Pages).to receive(:view_templates_pattern).and_return(['tmp', '*.{rb,erb}'])
        end

        after do
          File.delete(Rails.root.join('tmp', 'abc.html.erb'))
          File.delete(Rails.root.join('tmp', 'def.rb'))
          File.delete(Rails.root.join('tmp', 'xyz.html.erb'))
          File.delete(Rails.root.join('tmp', 'odd.file.name'))
        end

        describe 'layout templates' do
          it 'returns the names of all files which fit the pattern and are in the whitelist' do
            expect(subject.send(:valid_layout_templates)).to include('abc')
          end

          it 'does not return files whose names are not in the whitelist' do
             expect(subject.send(:valid_layout_templates)).not_to include('xyz')
          end

          it 'does not return files that do not fit the pattern' do
            expect(subject.send(:valid_layout_templates)).not_to include('def')
          end
        end

        describe "valid view templates" do
          it 'returns the names of all files which fit the pattern' do
            expect(subject.send(:valid_view_templates)).to include('xyz','def', 'abc')
          end

          it "does not return names which don't fit the pattern" do
            expect(subject.send(:valid_view_templates)).not_to include('odd')
           end
         end
       end
    end
  end
end
