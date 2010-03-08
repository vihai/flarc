
require 'ids/uniqueid'

module Hel
  module UsesGuid #:nodoc:
  
    def self.append_features(base)
      super
      base.extend(ClassMethods)  
    end

    
    module ClassMethods
      
      def uses_guid_as_primary(options = {})
                
        class_eval do
          set_primary_key options[:column] if options[:column]
          
          # don't implement directly in after_initialize.  If the model class defines
          # the after_initialize method, this one would be overwritten.  Instead use the
          # recommended practice of defining an empty after_initialize method and then
          # calling the custom code in a method declared with the after_initialize filter
          
          def after_initialize; end
          
          after_initialize :set_uuid
          
          def set_uuid
              self.id ||= UUID.create().to_s22
          end
        end        
      end
      
      def uses_guid(options = {})
                
        class_eval do
          set_primary_key options[:column] if options[:column]
          
          def after_initialize; end
          
          after_initialize :set_uuid
          
          def set_uuid
              self.uuid ||= UUID.create()
          end
          
          def uuid
            return UUID.parse22(read_attribute(:uuid)) unless read_attribute(:uuid).nil?
            nil
          end

          ## uuids are stored in the compact s22 format
          def uuid=(object)
            if object.respond_to?(:to_s22)
              write_attribute(:uuid, object.to_s22)
            else
              write_attribute(:uuid, object)
            end
          end

        end        
      end     
      
    end
  end
end

self.class.class_eval do
  include Hel::UsesGuid
end