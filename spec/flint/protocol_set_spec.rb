require 'flint'
include Flint

describe ProtocolSet do

  describe "initialization" do
    before(:all) do
    end

    it "should support a single protocol name" do
      ProtocolSet.new("tcp").ranges.should == [6..6]
      ProtocolSet.new("udp").ranges.should == [17..17]
      ProtocolSet.new("ip").should be_include(0)
      ProtocolSet.new("ip").should be_include(6)
      ProtocolSet.new("ip").should be_include(17)
    end

    it "should support a single protocol number" do
      ProtocolSet.new(6).ranges.should == [6..6]
      ProtocolSet.new(17).ranges.should == [17..17]
      ProtocolSet.new(99).ranges.should == [99..99]
      ProtocolSet.new(255).ranges.should == [255..255]
      ProtocolSet.new(0).ranges.should == [0..255]
      ProtocolSet.new(0).should be_include(0)
      ProtocolSet.new(0).should be_include(6)
      ProtocolSet.new(0).should be_include(17)
    end

    it "should support multiple protocol names" do
      p1 = ProtocolSet.new("udp", "tcp")
      p1.ranges.should == [6..6, 17..17]
      ProtocolSet.new("tcp", "ip").ranges.should == [0..255]
    end

    it "should support multiple protocol numbers" do
      p1 = ProtocolSet.new(99, 255, 6, 17)
      p1.ranges.should == [6..6, 17..17, 99..99, 255..255]
      ProtocolSet.new(99, 0).ranges.should == [0..255]
    end

    it "should support initializing from another ProtocolSet" do
      p = ProtocolSet.new( ProtocolSet.new(14) )
      p.should be_include(14)
      p.ranges.should == [14..14]
    end

    it "should support a mix of names, numbers, and sets" do
      p1 = ProtocolSet.new(99, 255, "tcp", ProtocolSet.new("udp"))
      p1.ranges.should == [6..6, 17..17, 99..99, 255..255]
      ProtocolSet.new(ProtocolSet.new(99), 6, "ip").ranges.should == [0..255]
    end

    it "should support initialization of an ANY set with :any" do
      p = ProtocolSet.new(:any)
      p.should be_include(0..0xff)
      p.ranges.should == [0 .. 0xff]
      p.any?.should == true
      ProtocolSet.new(1).any?.should == false
    end

    it "should detect invalid protocol names and numbers" do
      (ProtocolSet.new("bogus") rescue($!)).should be_kind_of(Exception)
      (ProtocolSet.new(300) rescue($!)).should be_kind_of(Exception)
    end
  end


  describe "modification" do
    before(:each) do
      @set = ProtocolSet.new("udp", "tcp")
    end

    it "should support creating a separate copy" do
      cp = @set.copy
      cp.object_id.should_not == @set.object_id
      cp.ranges.object_id.should_not == @set.ranges.object_id
    end

    it "should support inversion" do
      @set.invert!
      @set.ranges.should == [0..5, 7..16, 18..255]
      @set.invert!
      @set.ranges.should == [6..6, 17..17]
    end

    it "should support adding protocol names to a set" do
      @set.should_not be_include(1)
      @set.add("icmp")
      @set.should be_include(1)
      @set.should_not be_include(9)
    end

    it "should support adding protocol numbers to a set" do
      @set.should_not be_include(1)
      @set.add(1)
      @set.should be_include(1)
      @set.should_not be_include(9)
    end

    it "should support adding sets to other sets" do
      set2=ProtocolSet.new(1)
      set2.should be_include(1)
      set2.should_not be_include(9)
      @set.should_not be_include(1)
      @set.add(set2)
      @set.should be_include(1)
      @set.should_not be_include(9)
    end

    it "should support subtracting protocol names from a set" do
      @set.should be_include("tcp")
      @set.subtract("tcp")
      @set.should_not be_include("tcp")
    end

    it "should support subtracting protocol numbers from a set" do
      @set.should be_include(6)
      @set.subtract(6)
      @set.should_not be_include(6)
    end

    it "should support subtracting one set from another set" do
      set2=ProtocolSet.new("tcp")
      @set.should be_include("tcp")
      @set.subtract(set2)
      @set.should_not be_include("tcp")
    end

  end

  describe "comparison" do
    before(:each) do
      @set = ProtocolSet.new("udp", "tcp")
    end

    it "should identify equality" do
      @set.should == ProtocolSet.new(6, 17)
    end

    it "should identify overlapping sets" do
      @set.overlap(:any).should == ProtocolSet.new(6,17)
      @set.overlap(17).should == ProtocolSet.new(17)
      @set.overlap(6).should == ProtocolSet.new(6)
      @set.overlap(1..50).should == ProtocolSet.new(6,17)
      @set.overlap(16).should == nil
      @set.overlap(50..255).should == nil
    end

    it "should identify when it is a subset of another set" do
      @set.subset_of?(:any).should == true
      @set.subset_of?(17).should == false
      @set.subset_of?(ProtocolSet.new(6,17)).should == true
      @set.subset_of?(ProtocolSet.new(:any)).should == true
      @set.subset_of?(ProtocolSet.new(0..50)).should == true
      @set.subset_of?(ProtocolSet.new(50..255)).should == false
    end

    it "should identify when it is a superset of another set" do
      @set.superset_of?(:any).should == false
      @set.superset_of?(17).should == true
      @set.superset_of?(ProtocolSet.new(6,17)).should == true
      @set.superset_of?(ProtocolSet.new(:any)).should == false
      @set.superset_of?(ProtocolSet.new(0..50)).should == false
      @set.superset_of?(ProtocolSet.new(50..255)).should == false
    end

  end

  describe "iteration" do
    before(:each) do
      @set = ProtocolSet.new("udp", "tcp")
    end

    it "should return the total count of addresses in the set" do
      @set.count.should == 2
    end

    it "should return an array of protocols in the set" do
      @set.to_protocols.should == ["tcp", "udp"]
      @set.add(99)
      @set.to_protocols.should == ["tcp", "udp", 99]
    end

  end

end

