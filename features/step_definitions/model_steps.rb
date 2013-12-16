Then(/^the (.*?) named (.*?) should no longer exist$/) do |model, name|
   	model_id(model, name).should be_nil
end

Given(/^the (.*?) named (.*?) exists$/) do |model, name|
	if model.eql?("building")
		model.capitalize.constantize.find_by_name(name) or FactoryGirl.create(model.downcase.to_sym, :name => name, :area_id => Area.unspecified_id)
    elsif model.eql?("area")
    	model.capitalize.constantize.find_by_name(name) or FactoryGirl.create(model.downcase.to_sym, :name => name)
    else
		FactoryGirl.create(model.downcase.to_sym, :name => name)
	end
end

And(/^the (.*?) named (.*?) should exist$/) do |model, name|
  	model_id(model,name).should_not be_nil
end

And(/^the student with name (.*?) should exist$/) do |name|
  	Student.find_by_full_name(name)
end

And(/^the user changes the (.*?) (.*?) from (.*?) to (.*?)$/) do |model, attr, name, new_name|
   	fill_in("#{model}_#{attr}", :with => "#{new_name}")
end
