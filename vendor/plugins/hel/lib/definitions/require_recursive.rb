
module Hel
    
    #
    # recursive require of files
    #
    def self.require_recursive(pat, path='', recursive = false)
      #print(" + requireRecursive path=#{path}\n")
      
      fs = Dir[File.join(path, pat)]
      unless fs.empty?
        fs.each { |f|
          #print(" + requiring file: #{f}\n")
          Kernel.require(f) unless File.directory?(f)
        }
      end
      if(recursive)
        fs = Dir[File.join(path, '*')]
        unless fs.empty?
          fs.each { |d|
            self.require_recursive(pat, d, recursive)
          }
        end
      end
    end
end