ActionController.add_renderer :json do |json, opts|
  unless json.respond_to?(:to_str)

    if self.class.include?(ActiveRest::Controller)
      opts.merge! :view => self.rest_view
    end

    json = ActiveSupport::JSON.encode(json, opts)
  end

  json = "#{opts[:callback]}(#{json})" unless opts[:callback].blank?

  self.content_type ||= Mime::JSON
  self.headers['X-Total-Resources-Count'] = opts[:total].to_s if opts[:total]

  json
end


class RestController < ApplicationController

  include ActiveRest::Controller

  respond_to :html, :json, :xml

  rest_transaction_handler :xact_handler

  def xact_handler
    Ygg::Core.transaction("Web interface operation", {
                           :identity => hel_session.auth_identity,
                           :http_session_id => hel_session.id
                          }) do |transaction|
      yield
    end
  end

end
