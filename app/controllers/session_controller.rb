
class SessionController < ApplicationController

  # GET /session/login
  def show_form
    respond_to do |format|
      format.html
    end
  end

  # POST /session/login
  def authenticate

    identity = Hel::Identity.find_by_fqdn(params[:email])

    if !identity.nil? && identity.password == params[:password]
      session[:authenticated_identity] = identity
    end

    respond_to do |format|
      format.html {
        redirect_to "/"
      }

      format.js {
        render :update do |page|
          page.reload
        end
      }
    end
  end

  # POST /session/logout
  def logout
    session[:authenticated_identity] = nil

    respond_to do |format|
      format.html {
        redirect_to "/"
      }

      format.js {
        render :update do |page|
          page.reload
        end
      }
    end
  end

end
