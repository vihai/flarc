
class RestController < ApplicationController

  include ActiveRest::Controller

  respond_to :html, :json, :xml

end
