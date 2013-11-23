module RailsSupport
  # Given a model name and an instance name, return
  # the id of the instance. 
  #
  # mdodel be either an instance of ActiveRecord::Base or a string.
  # If model is an ActiveRecord::Base object, name may be nil.
  #
  # name is used first in a call to find_by_name, then in a call
  # to find_by_display_name
  def model_id(model, name = nil)
    return model.id if model.kind_of? ActiveRecord::Base
    model_constant = model.capitalize.constantize
    return model_constant.find_by_name(name).id \
		rescue model_constant.find_by_email(name).id \
		rescue model_constant.find_by_display_name(name).id \
		rescue nil if not name.nil?

  end
end

if Rails.env.test?
	World(RailsSupport)
end