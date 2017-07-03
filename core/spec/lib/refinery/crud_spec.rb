require "spec_helper"

ActiveRecord::Schema.define do
  create_table :refinery_crud_dummies, force: true do |t|
    t.integer :parent_id
    t.integer :lft
    t.integer :rgt
    t.integer :depth
  end
end

module Refinery
  class CrudDummy < ActiveRecord::Base
    acts_as_nested_set
  end

  class CrudDummyController < ::ApplicationController
    crudify :'refinery/crud_dummy'
  end
end

module Refinery
  describe CrudDummyController, type: :controller do
    before do
      @routes = ActionDispatch::Routing::RouteSet.new.tap do |r|
        r.draw do
          namespace :refinery do
            resources :crud_dummy, except: :show do
              post :update_positions, on: :collection
            end
          end
        end
      end
    end

    describe "#update_positions" do
      context "with existing dummies" do
        let!(:crud_dummy_one) { Refinery::CrudDummy.create! }
        let!(:crud_dummy_two) { Refinery::CrudDummy.create! }
        let!(:crud_dummy_three) { Refinery::CrudDummy.create! }

        it "orders dummies" do
          post :update_positions, params: {
            "ul": {
              "0": {
                "0": {"id": "crud_dummy_#{crud_dummy_three.id}"},
                "1": {"id": "crud_dummy_#{crud_dummy_two.id}"},
                "2": {"id": "crud_dummy_#{crud_dummy_one.id}"}
              }
            }
          }

          dummy = crud_dummy_three.reload
          expect(dummy.lft).to eq(1)
          expect(dummy.rgt).to eq(2)

          dummy = crud_dummy_two.reload
          expect(dummy.lft).to eq(3)
          expect(dummy.rgt).to eq(4)

          dummy = crud_dummy_one.reload
          expect(dummy.lft).to eq(5)
          expect(dummy.rgt).to eq(6)
        end

        it "orders nested dummies" do
          nested_crud_dummy_one = Refinery::CrudDummy.create! parent_id: crud_dummy_one.id
          nested_crud_dummy_two = Refinery::CrudDummy.create! parent_id: crud_dummy_one.id

          post :update_positions, params: {
            "ul": {
              "0": {
                "0": {
                  "id": "crud_dummy_#{crud_dummy_three.id}",
                  "children": {
                    "0": {
                      "0": {"id": "crud_dummy_#{nested_crud_dummy_one.id}"},
                      "1": {"id": "crud_dummy_#{nested_crud_dummy_two.id}"}
                    }
                  }
                },
                "1": {"id": "crud_dummy_#{crud_dummy_two.id}"},
                "2": {"id": "crud_dummy_#{crud_dummy_one.id}"}
              }
            }
          }

          dummy = crud_dummy_three.reload
          expect(dummy.lft).to eq(1)
          expect(dummy.rgt).to eq(6)

          dummy = nested_crud_dummy_one.reload
          expect(dummy.lft).to eq(2)
          expect(dummy.rgt).to eq(3)
          expect(dummy.parent_id).to eq(crud_dummy_three.id)

          dummy = nested_crud_dummy_two.reload
          expect(dummy.lft).to eq(4)
          expect(dummy.rgt).to eq(5)
          expect(dummy.parent_id).to eq(crud_dummy_three.id)

          dummy = crud_dummy_two.reload
          expect(dummy.lft).to eq(7)
          expect(dummy.rgt).to eq(8)

          dummy = crud_dummy_one.reload
          expect(dummy.lft).to eq(9)
          expect(dummy.rgt).to eq(10)
        end
      end

      # Regression test for https://github.com/refinery/refinerycms/issues/1585
      it "sorts numerically rather than by string key" do
        dummy, dummy_params = [], {}

        # When we have 11 entries, the 11th index will be #10, which will be
        # sorted above #2 if we are sorting by strings.
        11.times do |n|
          dummy << Refinery::CrudDummy.create!
          dummy_params[n.to_s] = {"id": "crud_dummy_#{dummy[n].id}"}
        end

        post :update_positions, params: { "ul": { "0": dummy_params } }

        expect(dummy.last.reload.lft).to eq(5)
      end
    end

  end
end
