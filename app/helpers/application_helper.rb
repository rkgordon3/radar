module ApplicationHelper

	def on_duty
		Shift.where(:staff_id => current_staff.id, :time_out => nil).first != nil
	end
	
	def on_round
		Round.where(:end_time => nil).first != nil		
	end
				
module Helpers
    module UrlHelper
      def button_to(name, options = {}, html_options = nil)
      
        html_options = (html_options || {}).stringify_keys
        convert_boolean_attributes!(html_options, %w( disabled ))

        if confirm = html_options.delete("confirm")
          html_options["onclick"] = "return #
{confirm_javascript_function(confirm)};"
        end
        options = {:only_path=>false}.update(options)
        url = options.is_a?(String) ? options : url_for(options)
        name ||= url

        html_options.symbolize_keys!
        tag(:input, html_options.merge({
        								:type => "button", :value => name, :foo => "223",
          :onclick => (html_options[:onclick] ? "#{html_options
[:onclick]}; " : "") + "window.location.href='#{url_for(options)}';"
        }))

      end
    end
  end 
end
