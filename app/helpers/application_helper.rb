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

end


