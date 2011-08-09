Factory.define :resource, :class => Refinery::Resource do |r|
  r.file File.new(Refinery.roots("resources").join("spec/uploads/refinery_is_awesome.txt"))
end
