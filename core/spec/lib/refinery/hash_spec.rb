require 'spec_helper'

module Refinery
  describe Hash do
    it 'does a deep merge with arrays' do
      a = {:use=>[:reserved, :globalize], :reserved_words=>["index", "new", "session", "login", "logout", "users", "refinery", "admin", "images", "wymiframe"]}
      b = {:use => [:scoped], :scope => :parent}

      # This example meant to show what Hash does now
      c = a.deep_merge b
      c.should eq({:use=>[:scoped], :reserved_words=>["index", "new", "session", "login", "logout", "users", "refinery", "admin", "images", "wymiframe"], :scope => :parent})

      # This is the new behavior
      c = a.safe_deep_merge b
      c.should eq({:use=>[:reserved, :globalize, :scoped], :reserved_words=>["index", "new", "session", "login", "logout", "users", "refinery", "admin", "images", "wymiframe"], :scope => :parent})
    end
  end
end


