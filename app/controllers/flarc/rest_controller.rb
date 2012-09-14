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

  add :yaml do |yaml, options|
    if self.class.include?(ActiveRest::Controller) && yaml.respond_to?(:output)
      options[:with_perms] = true if is_true?(params[:_with_perms])
      yaml = yaml.output(:rest, self.rest_view, :yaml, options)
    else
      yaml.respond_to?(:to_yaml) ? yaml.to_yaml(options) : yaml
    end

    self.content_type ||= Mime::XML
    self.headers['X-Total-Resources-Count'] = options[:total].to_s if options[:total]

    yaml
  end

  add :xml do |xml, options|
    if self.class.include?(ActiveRest::Controller) && xml.respond_to?(:output)
      options[:with_perms] = true if is_true?(params[:_with_perms])
      xml = xml.output(:rest, self.rest_view, :xml, options)
    else
      xml.respond_to?(:to_xml) ? xml.to_xml(options) : xml
    end

    self.content_type ||= Mime::XML
    self.headers['X-Total-Resources-Count'] = options[:total].to_s if options[:total]

    xml
  end
end

module Flarc

class RestController < ApplicationController

  include ActiveRest::Controller

  respond_to :html, :json, :xml

  self.rest_transaction_handler = :xact_handler

  class RestResponder < ActionController::Responder
    def to_json
      render({ :json => resource }.merge(options))
    end

    def to_yaml
      render({ :yaml => resource }.merge(options))
    end

    def to_xml
      render({ :xml => resource }.merge(options))
    end

    def api_behavior(error)
      raise error unless resourceful?

      if get? || put?
        display resource
      elsif post?
        display resource, :status => :created, :location => api_location
      else
        head :no_content
      end
    end

  end

  self.responder = RestResponder

  def xact_handler
    Ygg::Core.transaction("Web interface operation", :ctrl => self) do |transaction|
      yield
    end
  end

  rescue_from Exception, :with => :rest_ar_exception_rescue_action

  # log action is inherits by all ExtjsControllers and can be used by Ext application to access object's log
  #
  # == Request Parameters
  #
  # [params[:filter]]   Expression in json format to filter results
  # [params[:sort]]     Sort attribute
  # [params[:dir]]      Sort direction (ASC/DESC)
  # [params[:start]]    Pagination offset
  # [params[:limit]]    Pagination limit
  # [params[:<fld>]]  Implement simple filtering by adding == condition between <fld> and parameter value
  #
  def log
    find_target
    rel = apply_json_filter_to_relation(@target.log_entries.scoped)
#    rel = apply_simple_filter_to_relation(rel)
    rel = apply_sorting_to_relation(rel)
    rel = apply_pagination_to_relation(rel)
    respond_with(rel.all, :view => (params[:view] ? params[:view].to_sym : :objlog))
  end

  def acl
    find_target
    rel = apply_json_filter_to_relation(@target.acl_entries.scoped)
#    rel = apply_simple_filter_to_relation(rel)
    rel = apply_sorting_to_relation(rel)
    rel = apply_pagination_to_relation(rel)
    respond_with(rel.all, :view => (params[:view] ? params[:view].to_sym : :objacl))
  end

end

end
