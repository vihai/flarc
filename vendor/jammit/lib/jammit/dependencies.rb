# Standard Library Dependencies:
require 'uri'
require 'zlib'
require 'base64'
require 'pathname'
require 'fileutils'

unless defined? Rails
  require 'rubygems'
end
require 'yui/compressor'
require 'closure-compiler'
require 'active_support'

# Load initial configuration before the rest of Jammit.

# Jammit Core:
require 'jammit/compressor'
require 'jammit/packager'
# Jammit Rails Integration:
if defined?(Rails)
  Jammit.load_configuration(Jammit::DEFAULT_CONFIG_PATH) if defined?(Rails)
  ActionView::Base.send(:include, JammitHelper)
  if Rails.env.development?
    ActionController::Base.class_eval do
      append_before_filter { Jammit.reload! }
    end
  end
end