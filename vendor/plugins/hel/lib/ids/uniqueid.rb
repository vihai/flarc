require 'uuidtools'

# fixme UUIDTOOLS has a broken namespace
unless defined?(BROKEN_UUIDTOOLS)
  # FIXME not 1.9 safe
  Object.send(:remove_const, :UUID)
  BROKEN_UUIDTOOLS = true
  UUID = UUIDTools::UUID
end


require 'ids/uuid22'
require 'ids/base32'

#
# Generates random/hashed UUID compatible with RFC4122
#
#
# main methods for generation
#
# randomid = UUID::create
#
# id.to_s => "950cccdf-4dec-f857-8018-69025948b069"
#

class UUID

  #
  # Default create method for our use is random, shadows the version 1 method which is
  # useless anyways

  def self.create
    random_create
  end

  #
  # Returns a compact base32 encoding
  #
  # id.to_base32 => "G7JXMNYWCHHVFCU6H5VLI5XEYQ"

    def to_base32
      Base32.encode(self.raw)
    end

  #
  # Creates a UUID object from base32 encoding
  #
  # UUID.parse_base32("G7JXMNYWCHHVFCU6H5VLI5XEYQ").to_s
  # => "37d37637-1611-cf52-8a9e-3f6ab476e4c4"

  def self.parse_base32(data)
    UUID.parse_raw(Base32.decode(data))
  end

  #
  # Converts to compact form (that is the base32 representation of the last 48 bits of the UUID
  # in a maigic number readable form
  #
  # id.to_compact => "FOF-TSOHOVI"

  def to_compact
    raw = to_base32
    UUID.compact(raw)
  end

  # Two  UUIDs  are  said  to  be  equal if  and  only  if  their  (byte-order
  # canonicalized) integer representations are equivallent.  Refer RFC4122 for
  # details.
  def ==(other)
    if(other.respond_to?(:to_i))
      to_i == other.to_i
    else
      false
    end
  end

  def self.compact(orig)
    orig[16..18] + '-' + orig[19..26]
  end
end

UUID_NIL = UUID.parse('00000000-0000-0000-0000-000000000000')

