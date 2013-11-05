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
      context "with existing dummies" do
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

      # Regression test for https://github.com/refinery/refinerycms/issues/1585
      it "sorts numerically rather than by string key" do
        dummy, dummy_params = [], {}

        # When we have 11 entries, the 11th index will be #10, which will be
        # sorted above #2 if we are sorting by strings.
        11.times do |n|
          dummy << Refinery::CrudDummy.create!
          dummy_params[n.to_s] = {"id" => "crud_dummy_#{dummy[n].id}"}
        end

        post :update_positions, { "ul" => { "0" => dummy_params } }

        dummy.last.reload.lft.should eq(21)
      end
    end

  end
end
