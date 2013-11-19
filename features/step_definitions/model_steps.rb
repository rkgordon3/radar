Then(/^the (.*?) named (.*?) should no longer exist$/) do |model, name|
   model.capitalize.constantize.find_by_name(name).should be_nil
end

Given(/^the (.*?) named (.*?) exists$/) do |model, name|
  FactoryGirl.create(model.downcase.to_sym, :name => name)
end

Given(/^the (.*?) named (.*?) should exist$/) do |model, name|
  model.capitalize.constantize.find_by_name(name)
end

Given(/^the student with name (.*?) should exist$/) do |name|
  Student.find_by_full_name(name)
end