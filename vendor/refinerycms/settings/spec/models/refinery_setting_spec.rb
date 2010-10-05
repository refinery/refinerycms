require 'spec_helper'

describe RefinerySetting do
  it "should find or set particular settings" do
    @created = RefinerySetting.find_or_set(:creating_from_scratch, 'I am a setting being created', :scoping => 'pages')
    @expected = RefinerySetting.set(:creating_from_scratch, {:value => 'I should be changed!', :scoping => 'pages'})
    @actual = RefinerySetting.find_or_set(:creating_from_scratch, 'I am a setting that should be found', :scoping => 'pages')
    assert_equal @expected, @actual
  end

end
