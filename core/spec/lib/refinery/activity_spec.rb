require 'spec_helper'

describe Refinery::Activity do
  before { module X; module Y; class Z; end; end; end }

  let(:activity) { Refinery::Activity.new(:class_name => 'X::Y::Z') }

  describe '#base_class_name' do
    it 'returns the base class name, less module nesting' do
      expect(activity.base_class_name).to eq('Z')
    end
  end

  describe '#klass' do
    it 'returns class constant' do
      expect(activity.klass).to eq(X::Y::Z)
    end
  end

  describe '#url_prefix' do
    it 'returns edit_ by default' do
      expect(activity.url_prefix).to eq('edit_')
    end

    it 'returns user specified prefix' do
      activity.url_prefix = 'testy'
      expect(activity.url_prefix).to eq('testy_')
      activity.url_prefix = 'testy_'
      expect(activity.url_prefix).to eq('testy_')
    end
  end

  describe '#url' do
    it 'returns the url' do
      expect(activity.url).to eq('refinery.edit_x_y_admin_z_path')
    end
  end

  describe '#url with Refinery namespace' do
    before { module Refinery; module Y; class Z; end; end; end }
    let(:activity) { Refinery::Activity.new(:class_name => 'Refinery::Y::Z') }
    it 'returns the url' do
      expect(activity.url).to eq('refinery.edit_y_admin_z_path')
    end
  end
end
