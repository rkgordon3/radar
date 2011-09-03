module ApplicationHelper


def ApplicationHelper.unknown_date
  Date.civil(0,1,1)
end


UNKNOWN_IMAGE = "person-silhouette.jpg"

    def ApplicationHelper.unknown_image
	   UNKNOWN_IMAGE
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
