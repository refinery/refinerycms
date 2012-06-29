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
      let!(:crud_dummy_one) { Refinery::CrudDummy.create! }
      let!(:crud_dummy_two) { Refinery::CrudDummy.create! }
      let!(:crud_dummy_three) { Refinery::CrudDummy.create! }

      it "orders dummies" do
        post :update_positions, {
          "ul" => {
            "0" => {
              "0" => {"id" => "crud_dummy_#{crud_dummy_three.id}"},
              "1" => {"id" => "crud_dummy_#{crud_dummy_two.id}"},
              "2" => {"id" => "crud_dummy_#{crud_dummy_one.id}"}
            }
          }
        }

        dummy = crud_dummy_three.reload
        dummy.lft.should eq(1)
        dummy.rgt.should eq(2)

        dummy = crud_dummy_two.reload
        dummy.lft.should eq(3)
        dummy.rgt.should eq(4)

        dummy = crud_dummy_one.reload
        dummy.lft.should eq(5)
        dummy.rgt.should eq(6)
      end

      it "orders nested dummies" do
        nested_crud_dummy_one = Refinery::CrudDummy.create! :parent_id => crud_dummy_one.id
        nested_crud_dummy_two = Refinery::CrudDummy.create! :parent_id => crud_dummy_one.id

        post :update_positions, {
          "ul" => {
            "0" => {
              "0" => {
                "id" => "crud_dummy_#{crud_dummy_three.id}",
                "children" => {
                  "0" => {
                    "0" => {"id" => "crud_dummy_#{nested_crud_dummy_one.id}"},
                    "1" => {"id" => "crud_dummy_#{nested_crud_dummy_two.id}"}
                  }
                }
              },
              "1" => {"id" => "crud_dummy_#{crud_dummy_two.id}"},
              "2" => {"id" => "crud_dummy_#{crud_dummy_one.id}"}
            }
          }
        }

        dummy = crud_dummy_three.reload
        dummy.lft.should eq(1)
        dummy.rgt.should eq(6)

        dummy = nested_crud_dummy_one.reload
        dummy.lft.should eq(2)
        dummy.rgt.should eq(3)
        dummy.parent_id.should eq(crud_dummy_three.id)

        dummy = nested_crud_dummy_two.reload
        dummy.lft.should eq(4)
        dummy.rgt.should eq(5)
        dummy.parent_id.should eq(crud_dummy_three.id)

        dummy = crud_dummy_two.reload
        dummy.lft.should eq(7)
        dummy.rgt.should eq(8)

        dummy = crud_dummy_one.reload
        dummy.lft.should eq(9)
        dummy.rgt.should eq(10)
      end
    end

  end
end
