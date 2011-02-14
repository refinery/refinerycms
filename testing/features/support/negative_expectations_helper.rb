# https://rspec.lighthouseapp.com/projects/16211/tickets/305
require 'singleton'

module NegativeExpectationsHelper

  class State
    include Singleton

    def is_negative?
      @negative === true
    end

    def is_negative!
      @negative = true
    end

    def restore!
      @negative = false
    end
  end

  module ObjectExpectations
    def self.included(base)
      base.class_eval do
        alias_method :original_should, :should
        alias_method :original_should_not, :should_not

        def should(*args, &block)
          should_if_true(!State.instance.is_negative?, *args, &block)
        end

        def should_not(*args, &block)
          should_if_true(State.instance.is_negative?, *args, &block)
        end
      end
    end

    private # ----------------------------------------------------------------

    def should_if_true(cond, *args, &block)
      cond ? self.send(:original_should, *args, &block) : self.send(:original_should_not, *args, &block)
    end
  end

  def expect_opposite_if(cond)
    raise "expected block" unless block_given?
    State.instance.is_negative! if cond
    yield
    State.instance.restore! if cond
  end
end

class Object
  include NegativeExpectationsHelper::ObjectExpectations
end

World(NegativeExpectationsHelper)
