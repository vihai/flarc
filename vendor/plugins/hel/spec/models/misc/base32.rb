require File.join(File.dirname(__FILE__), '../..', "spec_helper")
require 'ids/base32'

TESTSTRING = 'Hallo world, whats new?'
ENCODEDSTRING = 'JBQWY3DPEB3W64TMMQWCA53IMF2HGIDOMV3T6'

  describe "the Base32 helper" do
    it "should encode correctly" do
      Base32.encode(TESTSTRING).should == ENCODEDSTRING
    end

    it "should decode correctly" do
      Base32.decode(ENCODEDSTRING).should == TESTSTRING
    end
    
    it "should be reversible" do
      Base32.decode(Base32.encode(TESTSTRING)).should == TESTSTRING
    end
  end