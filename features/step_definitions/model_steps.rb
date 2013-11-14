Then(/^the (.*?) named (.*?) should no longer exist$/) do |model, name|
   model.capitalize.constantize.find_by_name(name).should be_nil
end

Given(/^the (.*?) named (.*?) exists$/) do |model, name|
  FactoryGirl.create(model.downcase.to_sym, :name => name)
end

Then(/^the (.*?) named (.*?) should exist$/) do |model, name|
  model.capitalize.constantize.find_by_name(name)
end