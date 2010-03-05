require 'flint'

describe Flint::CiscoFirewall do
  before :each do
    Flint.flush_data
  end
  it "should parse cisco rules" do
    @rules = File.read(File.dirname(__FILE__) + "/pix-1.txt")
    @fw = Flint::CiscoFirewall.factory(@rules)
    lines = @fw.rule_lines
    lines.size.should == 107
    # an ICMP access rule

    lines[3].load_ast.should == ["access-list", [:acl_id, 100], [:policy, "permit"], [:protocol, "icmp"], [:source_net, "any"], [:destination_net, "any"], [:icmp_type, ["echo-reply"]], [:lineno, 4]]


    # a tcp access rule
    lines[12].load_ast.should eql(["access-list", [:acl_id, 100],
                              [:policy, "permit"],
                              [:protocol, "tcp"],
                              [:source_net, "any"],
                              [:destination_net, ["host",
                                                  IPAddr.new("10.1.1.4/255.255.255.255")]],
                                   [:destination_port, ["eq", PortName.new("smtp")]],
                                  [:lineno, 13]])

    # an access-group assignment
    lines[87].load_ast.should eql(["access-group", [:acl_id, 100],
                              [:direction, "in"],
                              [:interface, "outside"],
                                  [:lineno, 88]])


    lines.each do |l|
      Flint::acl(l.load_ast, @fw) if l.load_ast
    end

    # a comment
    lines[100].comment?.should be_true

  end

  it "should recognize name commands" do
    @rules = File.read(File.dirname(__FILE__) + "/pix-og.txt")
    @fw = Flint::CiscoFirewall.factory(@rules)
    @fw.resolver.address("devserver").should == IPAddr.new("10.1.1.1")
  end

  it "should build object-group tables" do
    @rules = File.read(File.dirname(__FILE__) + "/pix-og.txt")
    @fw = Flint::CiscoFirewall.factory(@rules)
    lines = @fw.rule_lines
    @fw.groups.size.should == 4
  end

  it "should bind rules to interfaces" do
    @rules = File.read(File.dirname(__FILE__) + "/pix-1.txt")
    @fw = Flint::CiscoFirewall.factory(@rules)
    lines = @fw.rule_lines
  end

  it "should normalize addresses" do
    @rules = File.read(File.dirname(__FILE__) + "/pix-og.txt")
    @fw = Flint::CiscoFirewall.factory(@rules)

    spec = @fw.normalize_netspec(["host", IPAddr.new("127.0.0.1")])
    spec.should == Flint::CidrSet.new(IPAddr.new("127.0.0.1"))

    spec = @fw.normalize_netspec(IPAddr.new("10.0.0.0/255.255.255.255"))
    spec.should == Flint::CidrSet.new(IPAddr.new("10.0.0.0/255.255.255.255"))

    spec = @fw.normalize_netspec(IPAddr.new("10.0.0.0/255.255.0.0"))
    spec.should == Flint::CidrSet.new(IPAddr.new("10.0.0.0/255.255.0.0"))

    spec = @fw.normalize_netspec("any")
    spec.any?.should == true

    spec = @fw.normalize_netspec(["host", Hostname.new("Unresolvable")])
    spec.empty?.should == true

    spec = @fw.normalize_netspec(["host", Hostname.new("devserver")])
    spec.should == Flint::CidrSet.new(IPAddr.new("10.1.1.1"))

    spec = @fw.normalize_netspec([:object_group_ref, "webservers"])
    spec.should == Flint::CidrSet.new("10.1.1.10", "10.1.1.11", "10.1.1.1")

    spec = @fw.normalize_netspec([:object_group_ref, "servers"])
    spec.should == Flint::CidrSet.new("10.1.1.10", "10.1.1.11", "10.1.1.1", "10.1.1.100", "10.1.1.111")
  end

  it "should normalize ports and services" do
    @rules = File.read(File.dirname(__FILE__) + "/pix-og.txt")
    @fw = Flint::CiscoFirewall.factory(@rules)

    spec = @fw.normalize_portspec([PortRange.new(1000,2000)])
    spec.should == Flint::PortSet.new(1000..2000)
    
    spec = @fw.normalize_portspec([PortRange.new("ftp","www")])
    spec.should == Flint::PortSet.new(21..80)
    
    
    spec = @fw.normalize_portspec(["eq", PortNumber.new(99)])
    spec.should == Flint::PortSet.new(99)

    spec = @fw.normalize_portspec(["gt", PortName.new("www")])
    spec.should == Flint::PortSet.new(80..Flint::PORT_MAX)

    spec = @fw.normalize_portspec(["neq", PortName.new("www")])
    spec.should == Flint::PortSet.new((0..79),(81..Flint::PORT_MAX))

  end

  it "should parse a big rule file" do
    @rules = File.read("#{ FLINT_ROOT }/victim.pix")
    @fw = Flint::CiscoFirewall.factory(@rules)
    lines = @fw.rule_lines
    lines.size.should == 4709
  end



end
