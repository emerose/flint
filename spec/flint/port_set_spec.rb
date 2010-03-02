require 'flint'
include Flint

describe PortSet do

  describe "initialization" do
    before(:all) do
    end

    it "should support a single range of IP addresses" do
      PortSet.new("0-255").ranges.should == [ 0..255 ]
      PortSet.new(0..255).ranges.should == [ 0..255 ]
    end

    it "should support multiple ranges of IP addresses" do
      PortSet.new("0-255", 512 .. 1024).ranges.should == [
        0 .. 255 , 
        512 .. 1024
      ]

      PortSet.new("0-255", 257 .. 1024).ranges.should == [ 
        0 .. 255 , 
        257 .. 1024
      ]

      PortSet.new("0-255", 255 .. 1024).ranges.should == [ 0 .. 1024 ]
      PortSet.new("0-255", 256 .. 1024).ranges.should == [ 0 .. 1024 ]
    end

    it "should support single Port" do
      set = PortSet.new(22).ranges.should == [22 .. 22]
    end

    it "should support multiple Ports" do
      PortSet.new(21, 23, 44).ranges.should == [21..21, 23..23, 44..44]
      PortSet.new(21, 22, 23).ranges.should == [21..23]
    end

    it "should support single port strings" do
      PortSet.new("22").ranges.should == [22..22]
      PortSet.new("ssh").ranges.should == [22..22]
    end

    it "should support multiple port strings" do
      PortSet.new("ssh", "ftp").ranges.should == [21..22]
      PortSet.new("22", "ftp").ranges.should == [21..22]
      PortSet.new("telnet", "ftp").ranges.should == [21..21, 23..23]
    end

    it "should support a mix of ranges, strings, and port numbers" do
      set = PortSet.new(21, "22-telnet", 24..50)
      set.ranges.should == [21 .. 50]
    end

    it "should detect invalid addresses and ranges and raise an exception" do
      (PortSet.new("bogus foo bar") rescue($!)).should be_kind_of(Exception)
      (PortSet.new("bogus - foo bar") rescue($!)).should be_kind_of(Exception)
      (PortSet.new(PORT_MAX + 1) rescue($!)).should be_kind_of(Exception)
      (PortSet.new(-1) rescue($!)).should be_kind_of(Exception)
    end
  end


  describe "modification" do
    before(:each) do
      @set = PortSet.new(10..100)
    end

    it "should support creating a separate copy" do
      cp = @set.copy
      cp.object_id.should_not == @set.object_id
      cp.ranges.object_id.should_not == @set.ranges.object_id
      cp.ranges.should == @set.ranges
    end

    it "should support inversion" do
      @set.invert!
      inv = PortSet.new(0..9, 101..PORT_MAX)

      @set.should == inv
      @set.ranges.should == inv.ranges

      (set2 = PortSet.any).ranges.should == [ 0..PORT_MAX ]
      set2.invert!.ranges.should == []
      set2.invert!.ranges.should == [0..PORT_MAX ]

      (set3 = PortSet.empty).ranges.should == []
      set3.invert!.ranges.should == [0..PORT_MAX ]
      set3.invert!.ranges.should == []

      (set4 = PortSet.new("1-65535")).ranges.should == [ 1 .. PORT_MAX ]
      set4.invert!.ranges.should == [0 .. 0]
      set4.invert!.ranges.should == [1 .. PORT_MAX]

      (set5 = PortSet.new("0-65534")).ranges.should == [ 0 .. PORT_MAX-1]
      set5.invert!.ranges.should == [ PORT_MAX .. PORT_MAX ]
      set5.invert!.ranges.should == [ 0 .. PORT_MAX-1 ]
    end

    it "should support adding a port number to a set" do
      @set.include?(143).should == false
      @set.add(143)
      @set.include?(143).should == true
    end

    it "should support adding port names to a set" do
      @set.include?(143).should == false
      @set.add("imap")
      @set.include?(143).should == true
    end

    it "should support adding a single port-range to a set" do
      @set.include?(1..9).should == false
      @set.add("1-9")
      @set.include?(1..9).should == true
    end

    it "should support adding sets to other sets" do
      @set.include?(1).should == false
      @set.add( PortSet.new(1) )
      @set.include?(1).should == true
    end

    it "should support removing a port number from a set" do
      @set.include?(50).should == true
      @set.remove(50)
      @set.include?(50).should == false
    end

    it "should support removing a port number string from a set" do
      @set.include?(50).should == true
      @set.remove("50")
      @set.include?(50).should == false
    end

    it "should support a removing port name from a set" do
      @set.include?(22).should == true
      @set.remove("ssh")
      @set.include?(22).should == false
    end

    it "should support removing a range of ports from a set" do
      @set.include?(20 .. 23).should == true
      @set.remove( "20-23" )
      @set.include?(20 .. 23).should == false
    end

    it "should support subtracting one set from another set" do
      @set.include?(22).should == true
      @set.subtract( PortSet.new(22) )
      @set.include?(22).should == false
    end

  end

  describe "comparison" do
    before(:each) do
      @set = PortSet.new(1 .. 20, 100 .. 200)
    end

    it "should identify equality" do
      set2 = PortSet.new("1-20", "100-200")
      set3 = PortSet.new(50)

      @set.should == set2
      @set.should_not == set3
    end

    it "should identify overlapping sets" do
      other = PortSet.new(10..50)
      @set.overlap(other).should == PortSet.new(10 .. 20)
      @set.overlap?(other).should == true

      other2 = PortSet.new(10..150)
      @set.overlap(other2).should == PortSet.new(10 .. 20, 100 .. 150)
      @set.overlap?(other2).should == true


      not_other = PortSet.new(50)
      @set.overlap(not_other).should be_nil
      @set.overlap?(not_other).should == false
    end

    it "should identify when it is a subset of another set" do
      @set.should be_subset_of(0 .. PORT_MAX)
      @set.should be_subset_of(1 .. 200)

      @set.should_not be_subset_of(1 .. 20)
      @set.should_not be_subset_of(100 .. 200)
      @set.should_not be_subset_of(50)

      @set.should be_subset_of(PortSet.new(1..20, 100..200))
    end

    it "should identify when it is a superset of another set" do
      @set.should_not be_superset_of(0 .. PORT_MAX)
      @set.should_not be_superset_of(1 .. 200)

      @set.should be_superset_of(1 .. 20)
      @set.should be_superset_of(100 .. 200)
      @set.should_not be_superset_of(50)
      @set.should be_superset_of(11)
      @set.should be_superset_of(101..150)

      @set.should be_superset_of(PortSet.new(1..20, 100..200))
    end

  end

  describe "iteration" do
    before(:each) do
      @set = PortSet.new(1..25, 101..200, 351..375)
      @tstports = (1..25).to_a + (101..200).to_a + (351..375).to_a
    end

    it "should return the total count of ports in the set" do
      @set.count.should == 150
    end

    it "should iterate over all ports in the set" do
      ports = []
      @set.each_port {|port| ports << port }
      ports.should == @tstports
    end

  end

end
