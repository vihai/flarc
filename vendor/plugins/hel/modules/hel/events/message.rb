module Hel
  module Events
    class Message
      attr_accessor :uuid, :oclass, :message
      
      def initialize(message, object)
        @uuid = object.uuid.to_s
        @oclass = object.class.name
        @message = message
      end
      

      def serialize
        
        YAML.dump(self)
      end      
      
      def self.unserialize(serialized_message)
        
        return YAML.load(serialized_message)
      end
      
    end
  end
end