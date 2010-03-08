# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  layout :select_proper_layout

  def select_proper_layout
    if LAYOUTS.class == Hash
      return LAYOUTS[request.host] 
    else
      return LAYOUTS
    end
  end

#around_filter do |controller, action|
#  if controller.params.key?("browser_profile!" )
#    require 'ruby-prof'
#    # Profile only the action
#    profile_results = RubyProf.profile { action.call }
#    # Use RubyProf's built in HTML printer to format the results
#    printer = RubyProf::GraphHtmlPrinter.new(profile_results)
#    # Append the results to the HTML response
#    controller.response.body << printer.print("")
#  else
#    action.call
#  end
#end



end
