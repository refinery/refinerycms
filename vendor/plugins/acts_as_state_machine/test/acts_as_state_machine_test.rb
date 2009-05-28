require File.dirname(__FILE__) + '/test_helper'

include ScottBarron::Acts::StateMachine

class ActsAsStateMachineTest < Test::Unit::TestCase
  fixtures :conversations
  
  def test_no_initial_value_raises_exception
    assert_raise(NoInitialState) {
      Person.acts_as_state_machine({})
    }
  end
  
  def test_initial_state_value
    assert_equal :needs_attention, Conversation.initial_state
  end
  
  def test_column_was_set
    assert_equal 'state_machine', Conversation.state_column
  end
  
  def test_initial_state
    c = Conversation.create
    assert_equal :needs_attention, c.current_state
    assert c.needs_attention?
  end
  
  def test_states_were_set
    [:needs_attention, :read, :closed, :awaiting_response, :junk].each do |s|
      assert Conversation.states.include?(s)
    end
  end
  
  def test_event_methods_created
    c = Conversation.create
    %w(new_message! view! reply! close! junk! unjunk!).each do |event|
      assert c.respond_to?(event)
    end
  end

  def test_query_methods_created
    c = Conversation.create
    %w(needs_attention? read? closed? awaiting_response? junk?).each do |event|
      assert c.respond_to?(event)
    end
  end
  
  def test_transition_table
    tt = Conversation.transition_table
    
    assert tt[:new_message].include?(SupportingClasses::StateTransition.new(:from => :read, :to => :needs_attention))
    assert tt[:new_message].include?(SupportingClasses::StateTransition.new(:from => :closed, :to => :needs_attention))
    assert tt[:new_message].include?(SupportingClasses::StateTransition.new(:from => :awaiting_response, :to => :needs_attention))
  end

  def test_next_state_for_event
    c = Conversation.create
    assert_equal :read, c.next_state_for_event(:view)
  end
  
  def test_change_state
    c = Conversation.create
    c.view!
    assert c.read?
  end
  
  def test_can_go_from_read_to_closed_because_guard_passes
    c = Conversation.create
    c.can_close = true
    c.view!
    c.reply!
    c.close!
    assert_equal :closed, c.current_state
  end
  
  def test_cannot_go_from_read_to_closed_because_of_guard
    c = Conversation.create
    c.can_close = false
    c.view!
    c.reply!
    c.close!
    assert_equal :read, c.current_state
  end

  def test_ignore_invalid_events
    c = Conversation.create
    c.view!
    c.junk!

    # This is the invalid event
    c.new_message!
    assert_equal :junk, c.current_state
  end

  def test_entry_action_executed
    c = Conversation.create
    c.read_enter = false
    c.view!
    assert c.read_enter
  end

  def test_after_actions_executed
    c = Conversation.create

    c.read_after_first = false
    c.read_after_second = false
    c.closed_after = false

    c.view!
    assert c.read_after_first
    assert c.read_after_second

    c.can_close = true
    c.close!

    assert c.closed_after
    assert_equal :closed, c.current_state
  end

  def test_after_actions_not_run_on_loopback_transition
    c = Conversation.create

    c.view!
    c.read_after_first = false
    c.read_after_second = false
    c.view!

    assert !c.read_after_first
    assert !c.read_after_second

    c.can_close = true

    c.close!
    c.closed_after = false
    c.close!

    assert !c.closed_after
  end

  def test_exit_action_executed
    c = Conversation.create
    c.read_exit = false
    c.view!
    c.junk!
    assert c.read_exit
  end
  
  def test_entry_and_exit_not_run_on_loopback_transition
    c = Conversation.create
    c.view!
    c.read_enter = false
    c.read_exit  = false
    c.view!
    assert !c.read_enter
    assert !c.read_exit
  end

  def test_entry_and_after_actions_called_for_initial_state
    c = Conversation.create
    assert c.needs_attention_enter
    assert c.needs_attention_after
  end
  
  def test_run_transition_action_is_private
    c = Conversation.create
    assert_raise(NoMethodError) { c.run_transition_action :foo }
  end
  
  def test_find_all_in_state
    cs = Conversation.find_in_state(:all, :read)
    
    assert_equal 2, cs.size
  end
  
  def test_find_first_in_state
    c = Conversation.find_in_state(:first, :read)
    
    assert_equal conversations(:first).id, c.id
  end
  
  def test_find_all_in_state_with_conditions
    cs = Conversation.find_in_state(:all, :read, :conditions => ['subject = ?', conversations(:second).subject])
    
    assert_equal 1, cs.size
    assert_equal conversations(:second).id, cs.first.id
  end
  
  def test_find_first_in_state_with_conditions
    c = Conversation.find_in_state(:first, :read, :conditions => ['subject = ?', conversations(:second).subject])
    assert_equal conversations(:second).id, c.id
  end
  
  def test_count_in_state
    cnt0 = Conversation.count(['state_machine = ?', 'read'])
    cnt  = Conversation.count_in_state(:read)
    
    assert_equal cnt0, cnt
  end
  
  def test_count_in_state_with_conditions
    cnt0 = Conversation.count(['state_machine = ? AND subject = ?', 'read', 'Foo'])
    cnt  = Conversation.count_in_state(:read, ['subject = ?', 'Foo'])
    
    assert_equal cnt0, cnt
  end
  
  def test_find_in_invalid_state_raises_exception
    assert_raise(InvalidState) {
      Conversation.find_in_state(:all, :dead)
    }
  end
  
  def test_count_in_invalid_state_raises_exception
    assert_raise(InvalidState) {
      Conversation.count_in_state(:dead)
    }
  end

  def test_can_access_events_via_event_table
    event = Conversation.event_table[:junk]
    assert_equal :junk, event.name
    assert_equal "finished", event.opts[:note]
  end
end
