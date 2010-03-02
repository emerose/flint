require 'flint'

describe Flint::CidrSet do

  describe "initialization" do
    before(:all) do
      addr_192 = IPAddr.new("192.168.11.1/24")
      addr_182 = IPAddr.new("182.16.1.0/24")
      addr_10 =  IPAddr.new("10.1.1.1/28")
      @rng_192 = (addr_192.bottom.to_i .. addr_192.top.to_i)
      @rng_182 = (addr_182.bottom.to_i .. addr_182.top.to_i)
      @rng_10 = (addr_10.bottom.to_i .. addr_10.top.to_i)
    end

    it "should support a single range of IP addresses" do
      set = Flint::CidrSet.new("192.168.11.0-192.168.11.255")
      set.ranges.should == [@rng_192]
    end

    it "should support multiple ranges of IP addresses" do
      set = Flint::CidrSet.new("192.168.11.0-192.168.11.255", 
                               "10.1.1.0-10.1.1.15")
      set.ranges.should == [@rng_10, @rng_192]
    end

    it "should support single IPAddr objects" do
      set = Flint::CidrSet.new(IPAddr.new("192.168.11.1/24"))
      set.ranges.should == [@rng_192]
    end

    it "should support multiple IPAddr objects" do
      set = Flint::CidrSet.new(IPAddr.new("192.168.11.1/24"), 
                               IPAddr.new("10.1.1.1/28"))
      set.ranges.should == [@rng_10, @rng_192]
    end

    it "should support single CIDR notation strings" do
      set = Flint::CidrSet.new("192.168.11.1/24")
      set.ranges.should == [@rng_192]
    end

    it "should support multiple CIDR notation strings" do
      set = Flint::CidrSet.new("192.168.11.1/24", "10.1.1.1/28")
      set.ranges.should == [@rng_10, @rng_192]

      # test that close merge works correctly
      set2 = Flint::CidrSet.new("0.0.0.0/1", "128.128.128.0/1")
      set2.ranges.should == [0..0xffffffff]

      set3 = Flint::CidrSet.new("128.128.128.0/1", "0.0.0.0/1")
      set3.ranges.should == [0..0xffffffff]
    end

    it "should support a mix of IPAddrs, CIDR notations, and IP ranges" do
      set = Flint::CidrSet.new IPAddr.lite("10.1.1.1/28"), 
                              "192.168.11.0-192.168.11.255",
                               "182.16.1.0/24"

      set.ranges.should == [@rng_10, @rng_182, @rng_192]
    end

    it "should detect invalid addresses and ranges and raise an exception" do
      lambda {
        Flint::CidrSet.new("182.1.3/24") rescue($!.class)
      }.call.should == (ArgumentError)
      lambda {
        Flint::CidrSet.new("this is a totally bogus address") rescue($!.class)
      }.call.should == (ArgumentError)
      lambda {
        Flint::CidrSet.new("thisisabogusaddr.google.com") rescue($!.class)
      }.call.should == (ArgumentError)
      lambda {
        Flint::CidrSet.new("foo-bar.bogus.bab.blah") rescue($!.class)
      }.call.should == (ArgumentError)
    end
  end



  describe "modification" do
    before(:each) do
      @set = Flint::CidrSet.new("10.1.2.0/24")
    end

    it "should support creating a separate copy" do
      cp = @set.copy
      cp.object_id.should_not == @set.object_id
      cp.ranges.object_id.should_not == @set.ranges.object_id
      cp.ranges.should == @set.ranges
    end

    it "should support inversion" do
      @set.invert!
      inv = Flint::CidrSet.new("0.0.0.0-10.1.1.255", 
                               "10.1.3.0-255.255.255.255")

      @set.should == inv
      @set.ranges.should == inv.ranges

      (set2 = Flint::CidrSet.new("0.0.0.0-255.255.255.255")).ranges.should == 
        [ 0 .. 0xffffffff ]
      set2.invert!.ranges.should == []
      set2.invert!.ranges.should == [0 .. 0xffffffff]

      (set3 = Flint::CidrSet.new("0.0.0.1-255.255.255.255")).ranges.should == 
        [ 1 .. 0xffffffff ]
      set3.invert!.ranges.should == [0 .. 0]
      set3.invert!.ranges.should == [1 .. 0xffffffff]

      (set4 = Flint::CidrSet.new("0.0.0.0-255.255.255.254")).ranges.should == 
        [ 0 .. 0xfffffffe ]
      set4.invert!.ranges.should == [ 0xffffffff .. 0xffffffff ]
      set4.invert!.ranges.should == [ 0 .. 0xfffffffe ]
    end

    it "should support adding IPAddr objects a set" do
      addr = IPAddr.new("192.168.14.1")
      @set.add(addr)
      @set.include?(addr).should == true
    end

    it "should support adding CIDR notation strings a set" do
      addr = "192.168.14.1/32"
      @set.add(addr)
      @set.include?(addr).should == true
    end

    it "should support adding a single range of IP addresses to a set" do
      addr = "192.168.14.1-192.168.14.2"
      @set.add(addr)
      @set.include?(addr).should == true
    end

    it "should support adding sets to other sets" do
      addr = "182.16.33.254"
      set2 = Flint::CidrSet.new("182.16.33.254")
      @set.add(set2)
      @set.include?(addr).should == true
    end

    it "should support removing IPAddr objects from a set" do
      addr = IPAddr.new("10.1.2.17")
      @set.remove(addr)
      @set.include?(addr).should == false
    end

    it "should support removing CIDR notation strings from a set" do
      addr = "10.1.2.17/28"
      @set.remove(addr)
      @set.include?(addr).should == false
    end

    it "should support removing a range string of IP addresses from a set" do
      addr = "10.1.2.17-10.1.3.255"
      @set.remove(addr)
      @set.include?(addr).should == false
    end

    it "should support subtracting one set from another set" do
      addr = "10.1.2.64-10.1.3.40"
      @set.subtract( Flint::CidrSet.new(addr) ) # same as remove
      @set.include?(addr).should == false
    end

  end

  describe "comparison" do
    before(:each) do
      @set = Flint::CidrSet.new("182.16.1.0/24", 
                                "192.168.11.0-192.168.11.255",
                                IPAddr.lite("10.1.1.1/28"))
    end

    it "should identify equality" do
      set2 = Flint::CidrSet.new("182.16.1.0/24", 
                                IPAddr.lite("10.1.1.1/28"),
                                "192.168.11.0-192.168.11.255")
      set3 = Flint::CidrSet.new("182.16.1.0/24")

      @set.should == set2
      @set.should_not == set3
    end

    it "should identify overlapping sets" do
      other = Flint::CidrSet.new("182.16.0.240-182.16.1.30")
      @set.overlap(other).should == Flint::CidrSet.new("182.16.1.0-182.16.1.30")

      not_other = Flint::CidrSet.new("182.16.254.1/32")
      @set.overlap(not_other).should be_nil
    end

    it "should identify when it is a subset of another set" do
      @set.subset_of?("9.9.9.9-193.1.1.1").should == true
      @set.subset_of?("10.1.1.2").should == false
      @set.subset_of?("182.16.1.255").should == false
      @set.subset_of?("10.1.1.3", "192.168.11.2-192.168.11.64").should == false
      @set.subset_of?("10.1.1.0/24").should == false
      same = Flint::CidrSet.new("182.16.1.0/24", 
                                "192.168.11.0-192.168.11.255",
                                IPAddr.lite("10.1.1.1/28"))
      @set.subset_of?(same).should == true
    end

    it "should identify when it is a superset of another set" do
      @set.superset_of?("9.9.9.9-193.1.1.1").should == false
      @set.superset_of?("182.16.1.2/30","10.1.1.1/31","192.168.11.1/25").should == true
      @set.superset_of?("10.1.1.2").should == true
      @set.superset_of?("182.16.1.255").should == true
      @set.superset_of?("10.1.1.3", "192.168.11.2-192.168.11.64").should == true
      @set.superset_of?("10.1.1.0/24").should == false

      same = Flint::CidrSet.new("182.16.1.0/24", 
                                "192.168.11.0-192.168.11.255",
                                IPAddr.lite("10.1.1.1/28"))
      @set.superset_of?(same).should == true
    end

  end

  describe "iteration" do
    before(:each) do
      @set = Flint::CidrSet.new("10.1.2.0/30", 
                                "192.168.1.1-192.168.1.6", 
                                "192.168.1.252/30")

      @tstaddrs = [
        "10.1.2.0",
        "10.1.2.1",
        "10.1.2.2",
        "10.1.2.3",
        "192.168.1.1",
        "192.168.1.2",
        "192.168.1.3",
        "192.168.1.4",
        "192.168.1.5",
        "192.168.1.6",
        "192.168.1.252",
        "192.168.1.253",
        "192.168.1.254",
        "192.168.1.255",
      ]

      @tstcidr = [
        IPAddr.lite("10.1.2.0/30"),
        IPAddr.lite("192.168.1.1/32"),
        IPAddr.lite("192.168.1.2/31"),
        IPAddr.lite("192.168.1.4/31"),
        IPAddr.lite("192.168.1.6/32"),
        IPAddr.lite("192.168.1.252/30"),
      ]
    end

    it "should return the total count of addresses in the set" do
      @set.count.should == 14
    end

    it "should iterate over all IP addresses in the set" do
      addrs = []
      @set.each_address {|addr| addrs << addr }
      addrs.should == @tstaddrs
    end

    it "should return a set as an array of the largest possible CIDR blocks" do
      @set.to_cidr.should == @tstcidr
      Flint::CidrSet.new("192.168.11.0-192.168.11.129").to_cidr.should == [
        IPAddr.lite("192.168.11.0/25"),
        IPAddr.lite("192.168.11.128/31"),
      ]
      Flint::CidrSet.new("192.168.1.64-192.168.1.128").to_cidr.should == [
        IPAddr.lite("192.168.1.64/26"),
        IPAddr.lite("192.168.1.128/32"),
      ]
      Flint::CidrSet.new("0.0.0.0-255.255.255.255").to_cidr.should == [
        IPAddr.lite("0.0.0.0/0")
      ]
      Flint::CidrSet.new("128.0.0.0-192.0.0.1").to_cidr.should == [
        IPAddr.lite("128.0.0.0/2"),
        IPAddr.lite("192.0.0.0/31")
      ]
    end

  end

end
