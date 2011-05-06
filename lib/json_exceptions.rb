#
# Yggdra Core
#
# Copyright (C) 2008-2011, Intercom Srl, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#          Lele Forzani <lele@windmill.it>
#          Alfredo Cerutti <acerutti@intercom.it>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

require 'action_dispatch/http/request'

class JsonExceptions < ActionDispatch::ShowExceptions
  private

  # Completely redefine render_exception as it wasn't passing request to rescue_action_in_public
  def render_exception(env, e)
    request = ActionDispatch::Request.new(env)

    return super env, e if request.format != :json

    log_error(e)

    res = {
      :reason => :exception,
      :short_msg => e.message,
      :long_msg => '',
      :retry_possible => false,
      :additional_info => "Exception of class '#{e.class}'",
    }

    res.merge!(e.public_data) if e.respond_to?(:public_data)

    if @consider_all_requests_local || request.local?
      res[:annotated_source_code] = e.annoted_source_code.to_s if e.respond_to?(:annoted_source_code)
      res[:application_backtrace] = clean_backtrace(e, :silent)
      res[:framework_backtrace] = clean_backtrace(e, :noise)

      res.merge!(e.private_data) if e.respond_to?(:private_data)
    end

    status = e.respond_to?(:http_status) ? e.http_status : status_code(e)

    json_render(status, res.to_json, request.format)

  rescue Exception => failsafe_error
    $stderr.puts "Error during failsafe response: #{failsafe_error}\n  #{failsafe_error.backtrace * "\n  "}"
    FAILSAFE_RESPONSE
  end

  def json_render(status, body, format)
    [status, {'Content-Type' => format.to_s, 'Content-Length' => body.bytesize.to_s}, [body]]
  end
end
