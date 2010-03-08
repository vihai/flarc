
# this is for taking care of ruby 1.9.x
# FIXME should really check > 1.9
if(RUBY_VERSION == "1.9.0")
  $:.unshift File.join(File.dirname(__FILE__), '..', 'compat')
end

module Hel
  class Dependencies
   
    # class level accessors
    cattr_accessor :root_dir
    cattr_accessor :lib_dir
    cattr_accessor :definitions_dir
    cattr_accessor :models_dir
    cattr_accessor :modules_dir
    
    def self.bootStrap
      
      @@root_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
      
      # definition of class variables
      @@lib_dir =  File.join(@@root_dir, "lib")
      @@definitions_dir = File.join(@@lib_dir, "definitions")
      @@overrides_dir = File.join(@@lib_dir, "overrides")

      @@models_dir =  File.join(@@root_dir, "models")
      @@modules_dir = File.join(@@root_dir, "modules")     
      
      # add libdir to the path
      $:.unshift @@lib_dir      
      $:.unshift @@definitions_dir
      $:.unshift @@models_dir
      $:.unshift @@modules_dir
    end
    
    def self.base_load
      Dir[File.join(@@definitions_dir, "*.rb")].each { |ext| require ext }
      Hel.require_recursive('*.rb', @@overrides_dir , true)
    end
      
  end
end

Hel::Dependencies.bootStrap
Hel::Dependencies.base_load


ActiveSupport::Dependencies.load_paths << Hel::Dependencies.models_dir
ActiveSupport::Dependencies.load_paths << Hel::Dependencies.modules_dir
