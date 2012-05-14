require 'spec_helper'

describe Refinery::Activity do
  before { module X; module Y; class Z; end; end; end }

  let(:activity) { Refinery::Activity.new(:class_name => 'X::Y::Z') }

  describe '#base_class_name' do
    it 'returns the base class name, less module nesting' do
      activity.base_class_name.should == 'Z'
    end
  end

  describe '#klass' do
    it 'returns class constant' do
      activity.klass.should == X::Y::Z
    end
  end

  describe '#url_prefix' do
    it 'returns edit_ by default' do
      activity.url_prefix.should == 'edit_'
    end

    it 'returns user specified prefix' do
      activity.url_prefix = 'testy'
      activity.url_prefix.should == 'testy_'
      activity.url_prefix = 'testy_'
      activity.url_prefix.should == 'testy_'
    end
  end

  describe '#url' do
    it 'returns the url' do
      activity.url.should == 'refinery.edit_x_y_admin_z_path'
    end
  end

  describe '#url with Refinery namespace' do
    before { module Refinery; module Y; class Z; end; end; end }
    let(:activity) { Refinery::Activity.new(:class_name => 'Refinery::Y::Z') }
    it 'returns the url' do
      activity.url.should == 'refinery.edit_y_admin_z_path'
    end
  end
end
