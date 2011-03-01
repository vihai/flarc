require 'pp'

class FbController < ApplicationController

  protect_from_forgery :except => :post_authorize

  def authenticate
    begin
      if facebook_uid
        if person = Person.find_by_fb_uid(facebook_uid)
          authenticated!(:facebook, person, nil)
          return redirect_to('/')
        end

###FIXME        # not a linked user, try to match a user record by email_hash
###FIXME        facebook_user.email_hashes.each do |hash|
###FIXME          if person = Person.find_by_email_hash(hash)
###FIXME            person.update_attribute(:fb_uid, facebook_uid)
###FIXME            authenticated!(:facebook, person, nil)
###FIXME            return redirect_to('/')
###FIXME          end
###FIXME        end
        
        # joining facebook user, send to fill in username/email
        return redirect_to(registration_path(:fb_user => 1))
      end

    # facebook quite often craps out and gives us no data
#    rescue Curl::Err::GotNothingError => e
#      return redirect_to(:action => 'authenticate')

    # it seems sometimes facebook gives us a useless auth token, so retry
    rescue Facebooker::Session::MissingOrInvalidParameter => e
      return redirect_to(:action => 'authenticate')
    end

    render(:nothing => true)
  end

  # callbacks, no session
  def post_authorize
    if linked_account_ids = params[:fb_sig_linked_account_ids].to_s.gsub(/\[|\]/,'').split(',')
      linked_account_ids.each do |person_id|
        if person = Person.find_by_id(person_id)
          person.update_attribute(:fb_uid, params[:fb_sig_user])
        end
      end
    end

    render :nothing => true
  end
end
