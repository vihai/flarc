# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

#require 'facebooker'

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time

  helper_method :facebook_uid, :asgard_session, :auth_method, :auth_person

  before_filter :load_session

  layout :select_proper_layout

  def select_proper_layout
    return LAYOUTS[request.host] || 'flarc'
  end

  def current_site
    # Ugly hack to give a site name
    select_proper_layout.to_sym
  end

#  protect_from_forgery
  
  attr_accessor :asgard_session

  def auth_method
    asgard_session ? asgard_session.auth_method : nil
  end

  def auth_person
    asgard_session ? asgard_session.auth_identity.person : nil
  end

  def load_session
    @asgard_session = Ygg::Core::HttpSession.find_by_uuid(request.headers['X-Ygg-Session-Id'])
    @asgard_session ||= Ygg::Core::HttpSession.find_by_uuid(request.cookies['X-Ygg-Session-Id'])

    if @asgard_session
      fb_cookie = cookies["fbs_#{Flarc::Application.config.fb_api_key}"]
      @facebook_session = fb_cookie ? CGI.parse(fb_cookie).symbolize_keys! : nil

      if @facebook_session && !@asgard_session.authenticated?
        if person = Person.find_by_fb_uid(facebook_uid)
          @asgard_session.authenticated!(:facebook, person, nil)
        end
      elsif @asgard_session.authenticated? && @asgard_session.auth_method == :facebook && !@facebook_session
        @asgard_session.close(:not_authenticated_anymore)
      end
    end
      
  end

  def facebook_session
    @facebook_session
  end

  def facebook_uid
    facebook_session ? facebook_session[:uid][0] : nil
  end
end
