
require 'action_controller/metal/renderers'

module ActionController::Renderers
  add :json do |obj, options|
    if self.class.include?(ActiveRest::Controller) && obj.respond_to?(:output)
      options[:with_perms] = true if is_true?(params[:_with_perms])
      json = obj.output(:rest, { :view => self.rest_view, :format => :json }.merge(options))

    elsif self.class.include?(ActiveRest::Controller) && obj.respond_to?(:ar_serializable_hash)
      options[:with_perms] = true if is_true?(params[:_with_perms])
      json = ActiveSupport::JSON.encode(obj.ar_serializable_hash(
               :rest, { :view => self.rest_view }.merge(options)))
    else
      json = obj.to_json(options) unless obj.kind_of?(String)
      json = "#{options[:callback]}(#{json})" unless options[:callback].blank?
    end

    self.content_type ||= Mime::JSON
    self.headers['X-Total-Resources-Count'] = options[:total].to_s if options[:total]
    json
  end
end

class RestController < ApplicationController

  include ActiveRest::Controller

  respond_to :html, :json, :xml

  self.rest_transaction_handler = :xact_handler

  def xact_handler
    Ygg::Core.transaction("Web interface operation", :ctrl => self) do |transaction|
      yield
    end
  end

end
