require 'flint'
include Flint

describe IcmpTypeSet do

  describe "initialization" do
    before(:all) do
    end

    it "should support a single icmp type name" do
      IcmpTypeSet.new("alternate-address").ranges.should == [6..6]
      IcmpTypeSet.new("mask-request").ranges.should == [17..17]
      IcmpTypeSet.new("echo-reply").should be_include(0)
      IcmpTypeSet.new("echo-reply").ranges.should == [0..0]
    end

    it "should support a single icmp type number" do
      IcmpTypeSet.new(6).ranges.should == [6..6]
      IcmpTypeSet.new(17).ranges.should == [17..17]
      IcmpTypeSet.new(99).ranges.should == [99..99]
      IcmpTypeSet.new(255).ranges.should == [255..255]
      IcmpTypeSet.new(0).ranges.should == [0..0]
      IcmpTypeSet.new(0).should be_include(0)
    end

    it "should support multiple icmp type names" do
      p1 = IcmpTypeSet.new("mask-request", "alternate-address")
      p1.ranges.should == [6..6, 17..17]
    end

    it "should support multiple icmp type numbers" do
      p1 = IcmpTypeSet.new(99, 255, 6, 17)
      p1.ranges.should == [6..6, 17..17, 99..99, 255..255]
    end

    it "should support initializing from another IcmpTypeSet" do
      p = IcmpTypeSet.new( IcmpTypeSet.new(14) )
      p.should be_include(14)
      p.ranges.should == [14..14]
    end

    it "should support a mix of names, numbers, and sets" do
      p1 = IcmpTypeSet.new(99, 255, "alternate-address", IcmpTypeSet.new(17))
      p1.ranges.should == [6..6, 17..17, 99..99, 255..255]
    end

    it "should support initialization of an ANY set with .any" do
      p = IcmpTypeSet.any
      p.should be_include(0..0xff)
      p.ranges.should == [0 .. 0xff]
      p.any?.should == true
      p.empty?.should == false
    end

    it "should support initialization of an empty set with .empty" do
      p = IcmpTypeSet.empty
      p.should_not be_include(0..0xff)
      p.should_not be_overlap(0..0xff)
      p.ranges.should == []
      p.empty?.should == true
      p.any?.should == false
      IcmpTypeSet.new(1).any?.should == false
    end


    it "should detect invalid icmp type names and numbers" do
      (IcmpTypeSet.new("bogus") rescue($!)).should be_kind_of(Exception)
      (IcmpTypeSet.new(300) rescue($!)).should be_kind_of(Exception)
    end
  end


  describe "modification" do
    before(:each) do
      @set = IcmpTypeSet.new("mask-request", "alternate-address")
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

    it "should support adding icmp type names to a set" do
      @set.should_not be_include(3)
      @set.add("unreachable")
      @set.should be_include(3)
      @set.should_not be_include(9)
    end

    it "should support adding icmp type numbers to a set" do
      @set.should_not be_include(1)
      @set.add(1)
      @set.should be_include(1)
      @set.should_not be_include(9)
    end

    it "should support adding sets to other sets" do
      set2=IcmpTypeSet.new(1)
      set2.should be_include(1)
      set2.should_not be_include(9)
      @set.should_not be_include(1)
      @set.add(set2)
      @set.should be_include(1)
      @set.should_not be_include(9)
    end

    it "should support subtracting icmp type names from a set" do
      @set.should be_include("alternate-address")
      @set.subtract("alternate-address")
      @set.should_not be_include("alternate-address")
    end

    it "should support subtracting icmp type numbers from a set" do
      @set.should be_include(6)
      @set.subtract(6)
      @set.should_not be_include(6)
    end

    it "should support subtracting one set from another set" do
      set2=IcmpTypeSet.new("alternate-address")
      @set.should be_include("alternate-address")
      @set.subtract(set2)
      @set.should_not be_include("alternate-address")
    end

  end

  describe "comparison" do
    before(:each) do
      @set = IcmpTypeSet.new("alternate-address", "mask-request")
    end

    it "should identify equality" do
      @set.should == IcmpTypeSet.new(6, 17)
    end

    it "should identify overlapping sets" do
      @set.overlap(17).should == IcmpTypeSet.new(17)
      @set.overlap(6).should == IcmpTypeSet.new(6)
      @set.overlap("alternate-address").should == IcmpTypeSet.new(6)
      @set.overlap("mask-request").should == IcmpTypeSet.new(17)
      @set.overlap(1..50).should == IcmpTypeSet.new(6,17)
      @set.overlap(16).should == nil
      @set.overlap(50..255).should == nil
    end

    it "should identify when it is a subset of another set" do
      @set.subset_of?(17).should == false
      @set.subset_of?(IcmpTypeSet.any).should == true
      @set.subset_of?(IcmpTypeSet.new(6,17)).should == true
      @set.subset_of?(IcmpTypeSet.new(0..50)).should == true
      @set.subset_of?(IcmpTypeSet.new(50..255)).should == false
    end

    it "should identify when it is a superset of another set" do
      @set.superset_of?(17).should == true
      @set.superset_of?(IcmpTypeSet.any).should == false
      @set.superset_of?(IcmpTypeSet.new(6,17)).should == true
      @set.superset_of?(IcmpTypeSet.new(0..50)).should == false
      @set.superset_of?(IcmpTypeSet.new(50..255)).should == false
    end

    it "should identify whether it is any? or empty?" do
      @set.empty?.should == false
      @set.any?.should == false
      IcmpTypeSet.new(1).any?.should == false
      IcmpTypeSet.new().empty?.should == true
      IcmpTypeSet.any.any?.should == true
      IcmpTypeSet.empty.empty?.should == true
      IcmpTypeSet.empty.any?.should == false
      IcmpTypeSet.any.empty?.should == false
    end

  end

  describe "iteration" do
    before(:each) do
      @set = IcmpTypeSet.new("echo", "echo-reply")
    end

    it "should return the total count of addresses in the set" do
      @set.count.should == 2
      @set.add(99)
      @set.count.should == 3
    end

    it "should return an array of icmp types in the set" do
      @set.to_icmp_types.should == ["echo-reply", "echo"]
      @set.add(99)
      @set.to_icmp_types.should == ["echo-reply", "echo", 99]
      @set.add(17)
      @set.to_icmp_types.should == ["echo-reply", "echo", "mask-request", 99]
    end

  end

end

