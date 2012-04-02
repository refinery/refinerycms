require 'spec_helper'

module Refinery
  describe Menu do

    let(:menu) do
      page1 = FactoryGirl.create(:page, :title => 'test1')
      page2 = FactoryGirl.create(:page, :title => 'test2', :parent_id => page1.id)
      Refinery::Menu.new([page1, page2])
    end

    describe '.initialize' do
      it "returns a collection of menu item objects" do
        menu.each { |item| item.should be_an_instance_of(MenuItem) }
      end
    end

    describe '#items' do
      it 'returns a collection' do
        menu.items.count.should eq(2)
      end
    end

    describe '#roots' do
      it 'returns a collection of items with parent_id == nil' do
        menu.roots.collect(&:parent_id).should eq([nil])
      end
    end

    describe '#to_s & #inspect' do
      it 'returns string of joined page titles' do
        menu.to_s.should eq('test1 test2')
        menu.inspect.should eq('test1 test2')
      end
    end

  end
end
