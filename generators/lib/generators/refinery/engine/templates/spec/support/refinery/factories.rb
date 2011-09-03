FactoryGirl.define do
  factory :<%= singular_name %>, :class => Refinery::<%= class_name %> do
    sequence(:<%= title.name %>) { |n| "title#{n}" }
  end
end
