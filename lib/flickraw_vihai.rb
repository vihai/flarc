# Copyright (c) 2006 Mael Clerambault <maelclerambault@yahoo.fr>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


require 'net/http'
require 'digest/md5'
require 'json'
require 'cgi'

module FlickRawVihai
  VERSION='0.5.1'

  FLICKR_HOST='api.flickr.com'.freeze

  # Path of flickr REST API
  REST_PATH='/services/rest/?'.freeze

  # Path of flickr auth page
  AUTH_PATH='/services/auth/?'.freeze

  # Path of flickr upload
  UPLOAD_PATH='/services/upload/'.freeze

  module SimpleOStruct # :nodoc:
    def __attr_define(k,v)
      instance_variable_set "@#{k}", v
      meta = class << self; self; end
      meta.class_eval { attr_reader k.to_s }
    end
  end

  class Response # :nodoc:
    include SimpleOStruct
    def initialize(h)
      h.each {|k, v| __attr_define k, Response.structify(v, k) }
    end

    def self.structify(obj, name = '')
      if obj.is_a? Hash
        if name =~ /s$/ and obj[$`].is_a? Array
          list = structify obj.delete($`)
          list.extend SimpleOStruct
          list.instance_eval { obj.each {|kv, vv| __attr_define kv, vv } }
          list
        elsif obj.keys == ['_content']
          obj['_content'].to_s
        else
          Response.new obj
        end
      elsif obj.is_a? Array
        obj.collect {|e| structify e}
      else
        obj
      end
    end

    def to_s; @_content || super end
  end

  class FailedResponse < StandardError
    attr_reader :code
    alias :msg :message
    def initialize(msg, code, req)
      @code = code
      super("'#{req}' - #{msg}")
    end
  end

  class CallHelper
    def initialize(session, path)
      @session = session
      @path = path
    end

    def method_missing(symbol, *args)

      path = @path + "." + symbol.to_s

      if @session.is_method?(path)
        @session.call path, *args
      else
        CallHelper.new(@session, path)
      end
    end

  end

  # Root class of the flickr api hierarchy.
  class Session

    attr_accessor :token

    @@methods = nil
    @@hierarchy = nil

    def initialize(api_key, shared_secret, token = nil) # :nodoc:
      @api_key = api_key
      @shared_secret = shared_secret
      @token = token
      @debug_stream = nil

      if @@methods.nil?
        @@methods = call 'flickr.reflection.getMethods'
        auto_hash = lambda { |h,k| h[k] = Hash.new(&auto_hash)  }

        @@hierarchy = Hash.new(&auto_hash)

        @@methods.each{ |method|
          sub = @@hierarchy
          components = method.split(".")
          components[0..-2].each { |cls| sub = sub[cls] }

          sub[components.last] = true
         }
      end
    end

    def is_method?(path)
      sub = @@hierarchy
      path.split(".").each { |x| sub = sub[x] }

      return sub == true
    end

    def method_missing(symbol, *args)
      CallHelper.new(self, "flickr." + symbol.to_s)
    end

    def set_debug(stream)
      @debug_stream = stream
    end

    # This is the central method. It does the actual request to the flickr server.
    #
    # Raises FailedResponse if the response status is _failed_.
    def call(req, args={})
      path = REST_PATH + build_args(args, req).collect { |a, v| "#{a}=#{v}" }.join('&')

      @debug_stream.puts("REQUEST: #{path}") if @debug_stream
      http_response = Net::HTTP.start(FLICKR_HOST) { |http| http.get(path, 'User-Agent' => "Flickraw/#{VERSION}") }
      @debug_stream.puts("RESPONSE: #{http_response.body}") if @debug_stream
      parse_response(http_response, req)
    end

    # Use this to upload the photo in _file_.
    #
    #  flickr.upload_photo '/path/to/the/photo', :title => 'Title', :description => 'This is the description'
    #
    # See http://www.flickr.com/services/api/upload.api.html for more information on the arguments.
    def upload_photo(file, args={})
      photo = File.open(file, 'rb') { |f| f.read }
      boundary = Digest::MD5.md5(photo).to_s

      header = {'Content-type' => "multipart/form-data, boundary=#{boundary} ", 'User-Agent' => "Flickraw/#{VERSION}"}
      query = ''
      build_args(args).each { |a, v|
        query <<
          "--#{boundary}\r\n" <<
          "Content-Disposition: form-data; name=\"#{a}\"\r\n\r\n" <<
          "#{v}\r\n"
      }
      query <<
        "--#{boundary}\r\n" <<
        "Content-Disposition: form-data; name=\"photo\"; filename=\"#{file}\"\r\n" <<
        "Content-Transfer-Encoding: binary\r\n" <<
        "Content-Type: image/jpeg\r\n\r\n" <<
        photo <<
        "\r\n" <<
        "--#{boundary}--"

      http_response = Net::HTTP.start(FLICKR_HOST) { |http| http.post(UPLOAD_PATH, query, header) }
      xml = http_response.body
      if xml[/stat="(\w+)"/, 1] == 'fail'
        msg = xml[/msg="([^"]+)"/, 1]
        code = xml[/code="([^"]+)"/, 1]
        raise FailedResponse.new(msg, code, 'flickr.upload')
      end
      Response.structify( {:stat => 'ok', :photoid => xml[/<photoid>(\w+)<\/photoid>/, 1], :ticketid => xml[/<ticketid>([^<]+)<\/ticketid>/, 1]})
    end

    # Returns the flickr auth URL.
    def auth_url(args={})
      full_args = {:api_key => @api_key, :perms => 'read'}
      args.each {|k, v| full_args[k.to_sym] = v }
      full_args[:api_sig] = api_sig(full_args) if @shared_secret

      'http://' + FLICKR_HOST + AUTH_PATH + full_args.collect { |a, v| "#{a}=#{v}" }.join('&')
    end

    # Returns the signature of hsh. This is meant to be passed in the _api_sig_ parameter.
    def api_sig(hsh)
      Digest::MD5.md5(@shared_secret + hsh.sort{|a, b| a[0].to_s <=> b[0].to_s }.flatten.join).to_s
    end

    private

    def parse_response(response, req = nil)
      json = JSON.load(response.body)
      raise FailedResponse.new(json['message'], json['code'], req) if json.delete('stat') == 'fail'
      name, json = json.to_a.first if json.size == 1

      res = Response.structify json, name
      lookup_token(req, res)
      res
    end

    def build_args(args={}, req = nil)
      full_args = {:api_key => @api_key, :format => 'json', :nojsoncallback => 1}
      full_args[:method] = req if req
      full_args[:auth_token] = @token if @token
      args.each {|k, v| full_args[k.to_sym] = v.to_s }
      full_args[:api_sig] = api_sig(full_args) if @shared_secret
      args.each {|k, v| full_args[k.to_sym] = CGI.escape(v.to_s) } if req
      full_args
    end

    def lookup_token(req, res)
      token_reqs = ['flickr.auth.getToken', 'flickr.auth.getFullToken', 'flickr.auth.checkToken']
      @token = res.token if token_reqs.include?(req) and res.respond_to?(:token)
    end
  end

end
