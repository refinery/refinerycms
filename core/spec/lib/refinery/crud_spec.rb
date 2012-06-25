require "spec_helper"

ActiveRecord::Schema.define do
  create_table :refinery_crud_dummies, :force => true do |t|
    t.integer :parent_id
    t.integer :lft
    t.integer :rgt
    t.integer :depth
  end
end

module Refinery
  class CrudDummy < ActiveRecord::Base
    attr_accessible :parent_id
    acts_as_nested_set
  end

  class CrudDummyController < ::ApplicationController
    crudify :'refinery/crud_dummy'
  end
end

module Refinery
  describe CrudDummyController, :type => :controller do
    
    describe "#update_positions" do
      before do
        3.times { Refinery::CrudDummy.create! } 
      end

      it "orders dummies" do
        post :update_positions, {"ul"=>{"0"=>{"0"=>{"id"=>"crud_dummy_3"}, "1"=>{"id"=>"crud_dummy_2"}, "2"=>{"id"=>"crud_dummy_1"}}}}
        
        dummy = Refinery::CrudDummy.find_by_id(1)
        dummy.lft.should eq(5)
        dummy.rgt.should eq(6)
        
        dummy = Refinery::CrudDummy.find_by_id(2)
        dummy.lft.should eq(3)
        dummy.rgt.should eq(4)

        dummy = Refinery::CrudDummy.find_by_id(3)
        dummy.lft.should eq(1)
        dummy.rgt.should eq(2)
      end
    end

  end
end
