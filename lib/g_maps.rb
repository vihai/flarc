module GMaps
  class AmbiguousGMapsAPIKeyException < StandardError
  end
  
  #Class fo the manipulation of the API key
  class ApiKey
    def self.get(options = {})
      if options.has_key?(:key)
        options[:key]
      elsif GOOGLE_MAPS_KEY.is_a?(Hash)
        #For this environment, multiple hosts are possible.
        #:host must have been passed as option
        if options.has_key?(:host)
          GOOGLE_MAPS_KEY[options[:host]]
        else
          raise AmbiguousGMapsAPIKeyException.new(GOOGLE_MAPS_KEY.keys.join(","))
        end
      else
        #Only one possible key: take it and ignore the :host option if it is there
        GOOGLE_MAPS_KEY
      end
    end
  end
end
