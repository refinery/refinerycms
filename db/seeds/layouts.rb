Layout.create(
  :title => 'One Column',
  :template_name => '1column'
)
Layout.create(
  :title => 'Two Column with Left Sidebar',
  :template_name => '2column_left'
)
Layout.create(
  :title => 'Two Column with Right Sidebar',
  :template_name => '2column_right'
)
Layout.create(
  :title => 'Three Column',
  :template_name => '3column'
)
RefinerySetting.create(:name => "Multi Layout", :value => 0, :destroyable => false)
RefinerySetting.create(:name => "Per Page Templates", :value => 0, :destroyable => false)
