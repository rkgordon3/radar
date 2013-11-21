
class String
	def list_word?
		[ "manage", "list" ].include? self.downcase  
	end
end

module ApplicationHelper


def ApplicationHelper.unknown_date
  Date.civil(0,1,1)
end

UNKNOWN_IMAGE = "person-silhouette.jpg"

def ApplicationHelper.unknown_image
 UNKNOWN_IMAGE
end

def maintenance_report_warning_text 
   %Q[Before submitting a Maintenance Request involving a fire alarm problem, a\nheating or hot water issue, or a security/entrance issue, please radio Unit 1.

DO NOT submit a Maintenance Request involving computer, printer, or network\nissues. Instead, please call the Helpdesk at x7800 or email helpdesk@smumn.edu.

For lock, lost key or keycard issues, please contact the on-call Hall Director (507-429-3780)\nfor assistance.

Press Okay to submit a Maintenance Request, otherwise press Cancel.].html_safe
end

def link_id_from_text(text)
	text[0] = '_' if text[0] == '/'
	text.split.join("_").downcase
end

def named_route_from_text(text)
	words = text.split
	words = words[1..-1] if words[0].list_word?
	words.reverse.join("_").downcase+"_path"
end

def model_element_id(model)
	name = model.class.name.downcase
	name = "organization" if name.match(/^(.*)organization/)
	[name, model.id].join("_")
end

def html_id(model)
	model.class.to_s.downcase+"_#{model.id}"
end
