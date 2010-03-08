module ActionView
  module Helpers
    module PrototypeHelper
      alias_method :form_remote_tag_old, :form_remote_tag
      def form_remote_tag(options = {}, &block)
        if options[:html] && options[:html][:multipart]

          uid = "a#{Time.now.to_f.hash}"

          options[:form] = true
          options[:html] ||= {}
          options[:html][:target] = uid

          concat("<iframe name=\"#{uid}\" id=\"#{uid}\" style=\"display: none;\" src=\"about:blank\"></iframe>\n")

          form_tag(options[:html].delete(:action) || url_for(options[:url]), options[:html], &block)
        else
          form_remote_tag_old(options, &block)
        end
      end                             
    end
  end
end
