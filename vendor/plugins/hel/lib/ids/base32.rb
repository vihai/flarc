
#
# Base32 encoding compliant with RFC-3548
# Author Lele Forzani <lele@windmill.it>
#
# Direct port from the Perl implementation by Daniel Peder <Daniel.Peder@InfoSet.COM>
#

class Base32

  #
  # Base32.encode(string)
  #
  def self.encode(source)
    data = source.unpack('B*')[0].gsub(/(.....)/, '000\1')
    len = data.length
    if(len & 7)
      e = data[(len & ~7)..-1]
      data = data[0, len & ~7]
      data += "000#{e}" + ('0' * (5 - e.length))
      data = data.to_a.pack('B*')
      data.tr!("\0-\37", 'A-Z2-7')
      data
    end
  end

  #
  # Base32.decode(string)
  #
  def self.decode(source)
    data = source.tr('A-Z2-7', "\0-\37")
    data = data.unpack('B*')[0].gsub(/000(.....)/, '\1')
    len = data.length
    data = data[0, len & ~7] if len & 7
    data = data.to_a.pack('B*')
    data
  end

end
