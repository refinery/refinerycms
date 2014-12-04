require 'spec_helper'
require 'refinery/menu'
require 'refinery/menu_item'

module Refinery
  describe Menu do
    it 'constructs a menu given items' do
      Menu.new([{:id => 1}, {:id => 2}]).items.each { |item|
        expect(item).to be_kind_of MenuItem
      }
    end

    it 'allows construction of a new menu from this menu' do
      expect {
        Menu.new(Menu.new([{:id => 1}, {:id => 2}]).map.first)
      }.to_not raise_exception
    end

    it '#roots contains only items at the same depth' do
      menu = Menu.new([{:id => 1, :depth => 0, :parent_id => nil},
                        {:id => 2, :depth => 0, :parent_id => nil},
                        {:id => 3, :depth => 1, :parent_id => nil}])
      expect(menu.roots.length).to eq(2)
      expect(menu.roots.map(&:original_id)).to include(1,2)
    end
  end
end
