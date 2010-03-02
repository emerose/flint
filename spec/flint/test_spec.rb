require 'flint'

describe Flint::Test do
  
  before(:each) do
    @fw = Flint::CiscoFirewall.factory(File.read(File.dirname(__FILE__) + "/test_group.ftg"))
  end
  
  it "should run blocks in its own scope" do
    atest = Flint::Test.new("Empty Test",{ :description => "An Empty Test"}) do
      true if firewall
    end
    atest.run(@fw)
    atest.result
    
  end
  
  it "should let tests throw errors" do
    atest = Flint::Test.new("Empty Test",{ :description => "An Empty Test"}) do
      raise "dummy" if firewall
    end
    atest.run(@fw)
    atest.result.result.should == :error
  end
  
  
  it "should let tests set effected_rules" do
    atest = Flint::Test.new("Empty Test",{ :description => "An Empty Test"}) do
      effected_rule("Some rule") 
      effected_rule("Another rule")
    end
    atest.run(@fw)
    atest.result.effected_rules.pop.should == "Another rule"

    atest.result.effected_rules.pop.should == "Some rule"
  end
  
  it "should let tests set effected_netblocks" do
    atest = Flint::Test.new("Empty Test",
                            { :description => "An Empty Test"}) do
      effected_netblocks("127.0.0.1")
      effected_netblocks("192.168.1.1")
    end
    atest.run(@fw)
    atest.result.effected_netblocks.pop.should == "192.168.1.1/32"
    atest.result.effected_netblocks.pop.should == "127.0.0.1/32"

  end

  it "should let tests set effected_interfaces" do
    atest = Flint::Test.new("Empty Test",{ :description => "An Empty Test"}) do
      effected_interface("if0")
      effected_interface("if1")
    end
    atest.run(@fw)
    atest.result.effected_interfaces.pop.should == "if1"
    atest.result.effected_interfaces.pop.should == "if0"
  end

  it "should let tests indicate failure" do
    atest = Flint::Test.new("Empty Test",{ :description => "An Empty Test"}) do
      fail("if1")
    end
    atest.run(@fw)
    atest.result.result.should == :fail
    atest.result.effected_rules.should == ["if1"]
  end
end
  
