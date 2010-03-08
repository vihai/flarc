require File.join(File.dirname(__FILE__), '../..', "spec_helper")
require 'ids/uniqueid'

TESTDATA = "random data"
TESTUUID = "30cea84c-c594-5e1b-ad5f-2b8b3938eeaa"
TESTB32  = "GDHKQTGFSRPBXLK7FOFTSOHOVI"
TESTU22  = "aWZQHmXzrEg61Fk4S5oo6Q"
TESTCOMP = "FOF-TSOHOVI"

  describe "the uniqueid class" do
    
    it "should produce unique ids " do
      UUID.create.should be_a_kind_of(UUID)
    end
    
    it "should produce valid uuids" do
      UUID.create.should be_valid
    end
    
    it "should be able to produce uuid from parsing data" do
      UUID.sha1_create(UUID_NIL, TESTDATA).should be_a_kind_of(UUID)
      UUID.sha1_create(UUID_NIL, TESTDATA).should be_valid
    end
      
    it "should produce the same hashes w/ the same data" do
      id1 = UUID.sha1_create(UUID_NIL, TESTDATA)
      id2 = UUID.sha1_create(UUID_NIL, TESTDATA)
      id1.should == id2
    end
    
    it "should produce different ids from hashing different data" do
      id1 = UUID.sha1_create(UUID_NIL, TESTDATA)
      id2 = UUID.sha1_create(UUID_NIL, TESTDATA + "diff")
      id1.should_not == id2      
    end
   
    it "should be able to parse uuids" do
      UUID.parse(TESTUUID).should be_valid
    end
    
    it "should not collide with random generations" do
      res = Array.new
      100.times { |i|
        res[i] = UUID.create
      }
      
      failed = false
      res.each_index { |i|
        res.each_index { |k|
          if(i != k)
            failed = true if(res[i] == res[k])
          end
        }
      }
      failed.should be_false
    end
    
    it "should produce predictable ids" do
      UUID.sha1_create(UUID_NIL, TESTDATA).to_s.should == TESTUUID
    end
    
    it "should produce valid base32 encoded ids" do
      UUID.sha1_create(UUID_NIL, TESTDATA).to_base32.should == TESTB32
    end
    
    it "should be able to parse base32 encoded ids" do
      UUID.parse_base32(TESTB32).to_s.should == TESTUUID
    end
    
    it "should be able to generate a compact form" do
      UUID.sha1_create(UUID_NIL, TESTDATA).to_compact.should == TESTCOMP
    end
    
    it "should be able to produce a 22char representation" do
      UUID.sha1_create(UUID_NIL, TESTDATA).to_s22.should == TESTU22
    end
    
    it "base32 should be reversible" do
      id1 = UUID.sha1_create(UUID_NIL, TESTDATA)
      b32 = id1.to_base32
      b32.should == TESTB32
      id2 = UUID.parse_base32(b32)
      id1.should == id2
      id1.to_s.should == id2.to_s
      b32.should == id2.to_base32
    end
    
    it "s22 should be reversible" do
      id1 = UUID.sha1_create(UUID_NIL, TESTDATA)
      s22 = id1.to_s22
      s22.should == TESTU22
      id2 = UUID.parse22(s22)
      id1.should == id2
      id1.to_s.should == id2.to_s
      s22.should == id2.to_s22
    end    
    
    
  end
