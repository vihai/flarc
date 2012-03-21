# encoding: utf-8

module Flarc

class RegistrationController < ApplicationController

  def check_email
    req = ActiveSupport::JSON.decode(request.body).symbolize_keys!
    resp = nil

    if !req[:email] || !(req[:email] =~ /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\z/)
      resp = { :valid => false }
    else
      identity = Ygg::Core::Identity.find_by_qualified(params[:email])
      if identity
        resp = { :valid => true, :found => true }
      else
        resp = { :valid => true, :found => false }
      end
    end

    respond_to do |format|
      format.json { render :json => resp }
    end
  end

  def wizard
    if request.method == 'GET'
    elsif request.method == 'POST'
      req = ActiveSupport::JSON.decode(request.body).symbolize_keys!

      Ygg::Core::Transaction.new 'Registration wizard' do

        pilot = nil

        password = Password.phonemic(8)

        credential = Ygg::Core::Credential::ObfuscatedPassword.new(:password => password)
        identity = Ygg::Core::Identity.new(
          :qualified => req[:email],
          :is_admin => false,
          :credentials => [ credential ]
        )

        person = Ygg::Core::Person.new(
          :first_name => req[:first_name],
          :middle_name => nil,
          :last_name => req[:last_name],
          :identities => [ identity ],
          :tmp_telefono => req[:phone]
        )

        person.save!

        if current_site == :cid
          Notifier::Cid.registration_complete(req[:email], password).deliver
        elsif current_site == :csvva
          Notifier::Csvva.registration_complete(req[:email], password).deliver
        else
          Notifier.registration_complete(req[:email], password).deliver
        end
      end
    end
  end

  def recover_password
    if request.method == 'GET'
    elsif request.method == 'POST'
      req = ActiveSupport::JSON.decode(request.body).symbolize_keys!

      identity = Ygg::Core::Identity.find_by_qualified(req[:fqda])

      if !identity
        respond_to do |format|
          format.json { render :json => { :success => false, :error => 'Indirizzo e-mail non trovato' } }
        end

        return
      end

      if identity.credentials.empty?
        Ygg::Core::Transaction.new 'Password auto-generated' do
          identity.credentials << Ygg::Core::Credential::ObfuscatedPassword.new(:password => Password.phonemic(8))
          identity.save!
        end
      end

      password = identity.credentials.first.password
      Cid::RegistrationNotifier.send_password(identity.qualified, password).deliver

      respond_to do |format|
        format.json { render :json => { :success => true, :error => 'La password è stata inviata per e-mail' } }
      end
    end
  end
end


end
