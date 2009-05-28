class Conversation < ActiveRecord::Base
  attr_writer :can_close
  attr_accessor :read_enter, :read_exit, :read_after_first, :read_after_second,
                :closed_after, :needs_attention_enter, :needs_attention_after

  acts_as_state_machine :initial => :needs_attention, :column => 'state_machine'

  state :needs_attention, :enter => Proc.new { |o| o.needs_attention_enter = true },
                          :after => Proc.new { |o| o.needs_attention_after = true }
                          
  state :read, :enter => :read_enter_action,
               :exit  => Proc.new { |o| o.read_exit  = true },
               :after => [:read_after_first_action, :read_after_second_action]

  state :closed, :after => :closed_after_action
  state :awaiting_response
  state :junk

  event :new_message do
    transitions :to => :needs_attention,   :from => [:read, :closed, :awaiting_response]
  end

  event :view do
    transitions :to => :read,              :from => [:needs_attention, :read]
  end
  
  event :reply do
    transitions :to => :awaiting_response, :from => [:read, :closed]
  end

  event :close do
    transitions :to => :closed,            :from => [:read, :awaiting_response], :guard => Proc.new {|o| o.can_close?}
    transitions :to => :read,              :from => [:read, :awaiting_response], :guard => :always_true
  end

  event :junk, :note => "finished" do
    transitions :to => :junk,              :from => [:read, :closed, :awaiting_response]
  end

  event :unjunk do
    transitions :to => :closed,            :from => :junk
  end

  def can_close?
    @can_close
  end

  def read_enter_action
    self.read_enter = true
  end

  def always_true
    true
  end

  def read_after_first_action
    self.read_after_first = true
  end

  def read_after_second_action
    self.read_after_second = true
  end

  def closed_after_action
    self.closed_after = true
  end
end
