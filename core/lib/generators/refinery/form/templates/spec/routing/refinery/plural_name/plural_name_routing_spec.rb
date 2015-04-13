require "spec_helper"

describe "<%= namespacing %> front-end routing", type: :routing do

  routes { Refinery::Core::Engine.routes }

  it "can route to index" do
    expect( :get => "/<%= plural_name %>" ).to route_to(
      :controller => "refinery/<%= plural_name %>/<%= plural_name %>",
      :action => "index",
      :locale => :en
    )
  end

  it "can route to new" do
    expect( :get => "/<%= plural_name %>/new" ).to route_to(
      :controller => "refinery/<%= plural_name %>/<%= plural_name %>",
      :action => "new",
      :locale => :en
    )
  end

  it "can route to create" do
    expect( :post => "/<%= plural_name %>" ).to route_to(
      :controller => "refinery/<%= plural_name %>/<%= plural_name %>",
      :action => "create",
      :locale => :en
    )
  end

  it "routes to thank_you" do
    expect( :get => "/<%= plural_name %>/thank_you" ).to route_to(
      :controller => "refinery/<%= plural_name %>/<%= plural_name %>",
      :action => "thank_you",
      :locale => :en
    )
  end

  it "does not route to show" do
    expect( :get => "/<%= plural_name %>/1" ).not_to route_to(
      :controller => "refinery/<%= plural_name %>/<%= plural_name %>",
      :action => "show",
      :locale => :en
    )
  end

  it "does not route to edit" do
    expect( :get => "/<%= plural_name %>/1/edit" ).not_to route_to(
      :controller => "refinery/<%= plural_name %>/<%= plural_name %>",
      :action => "edit",
      :locale => :en
    )
  end

  it "does not route to update" do
    expect( :update => "/<%= plural_name %>/1" ).not_to be_routable
  end

  it "does not route to delete" do
    expect( :delete => "/<%= plural_name %>/1" ).not_to be_routable
  end

end
