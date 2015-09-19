require "spec_helper"

describe "<%= plural_name %> admin routing", type: :routing do

  routes { Refinery::Core::Engine.routes }

  it "can route to new" do
    expect( :get => "/refinery/<%= plural_name %>/new" ).to route_to(
      :controller => "refinery/<%= plural_name %>/admin/<%= plural_name %>",
      :action => "new",
      :locale => :en
    )

  end

  it "can route to create" do
    expect( :post => "/refinery/<%= plural_name %>" ).to be_routable
  end

  it "can route to show" do
    expect( :get => "/refinery/<%= plural_name %>/1" ).to route_to(
      :controller => "refinery/<%= plural_name %>/admin/<%= plural_name %>",
      :action => "show",
      :id => '1',
      :locale => :en
    )
  end

  it "can route to edit" do
    expect( :get => "/refinery/<%= plural_name %>/1/edit" ).to route_to(
      :controller => "refinery/<%= plural_name %>/admin/<%= plural_name %>",
      :action => "edit",
      :id => "1",
      :locale => :en
    )
  end

  it "does not route to update" do
    expect( :update => "/refinery/<%= plural_name %>/1" ).not_to be_routable
  end

  it "does route to delete" do
    expect( :delete => "/refinery/<%= plural_name %>/1" ).to route_to(
      :controller => "refinery/<%= plural_name %>/admin/<%= plural_name %>",
      :action => "destroy",
      :id => '1',
      :locale => :en
    )
  end

end
