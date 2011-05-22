After do |s|
  Cucumber.wants_to_quit = true if s.failed?
end
