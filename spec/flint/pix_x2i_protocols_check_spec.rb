require 'flint'

def make_x2i_fw(*acl)
  fw = <<_EOF_
global (outside) 1 131.1.23.12-131.1.23.254
nat (inside) 1 10.0.0.0 
static (inside,outside) 131.1.23.11 10.14.8.50

static (inside, outside) 131.1.23.10 10.10.254.3

route inside 10.14.8.0 255.255.255.0 10.10.254.2
route outside 0.0.0.0 0.0.0.0 131.1.23.1

#{ acl.map{|x| "access-list 101 #{x}"}.join("\n") }
access-group 101 in interface outside

nameif ethernet0 outside security0
nameif ethernet1 inside security100
_EOF_
  return fw, 10-1
end

describe "Pix External-to-Internal Protocol Checks" do
  before(:each) do
    Flint.flush_data
    @tg = Flint::TestGroup.load( FLINT_ROOT + 
            "/checks/pix/external_to_internal_protocols.ftg")
  end

  it "should identify when SSH is permitted from any to any" do
    fwdat, off = make_x2i_fw( 'permit tcp any any eq 22' )
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:ssh)
    res.first.result.should == "fail"
    res.first.affected_rules.size.should == 1
    res.first.affected_rules.first.should == fw.rule_lines[off].number

    fwdat, off = make_x2i_fw("permit tcp any any eq 80")
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:ssh)
    res.first.result.should ==  "pass"

    fwdat, off = make_x2i_fw("deny ip any any", "permit ip any any eq 22")
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:ssh)
    res.first.result.should ==  "pass"
  end

  it "should identify when FTP is permitted from any to any" do
    fwdat, off = make_x2i_fw( 'permit tcp any any eq 21' )
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:ftp)
    res.first.result.should == "fail"
    res.first.affected_rules.size.should == 1
    res.first.affected_rules.first.should == fw.rule_lines[off].number

    fwdat, off = make_x2i_fw("permit tcp any any eq 80")
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:ftp)
    res.first.result.should ==  "pass"

    fwdat, off = make_x2i_fw("deny ip any any", "permit ip any any eq 21")
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:ftp)
    res.first.result.should ==  "pass"
  end

  it "should identify when SMB is permitted from any to any" do
    fwdat, off = make_x2i_fw( 'permit tcp any any eq 139',
                              'permit tcp any any eq 445',
                              'permit udp any any eq 138',
                              'permit udp any any eq 137' )

    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:smb)
    res.first.result.should == "fail"
    res.first.affected_rules.size.should == 4
    res.first.affected_rules.all.should be_include(fw.rule_lines[off].number)
    res.first.affected_rules.all.should be_include(fw.rule_lines[off+1].number)
    res.first.affected_rules.all.should be_include(fw.rule_lines[off+2].number)
    res.first.affected_rules.all.should be_include(fw.rule_lines[off+3].number)

    fwdat, off = make_x2i_fw("permit tcp any any eq 80")
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:smb)
    res.first.result.should ==  "pass"

    fwdat, off = make_x2i_fw( 'permit tcp any any eq 139',
                              'permit tcp any any eq 445',
                              'deny ip any any', 
                              'permit udp any any eq 138',
                              'permit udp any any eq 137' )

    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:smb)
    res.first.result.should ==  "fail"
    res.first.affected_rules.size.should == 2
    res.first.affected_rules.all.should be_include(fw.rule_lines[off].number)
    res.first.affected_rules.all.should be_include(fw.rule_lines[off+1].number)

    res.first.affected_rules.should_not be_include(fw.rule_lines[off+3].number)
    res.first.affected_rules.should_not be_include(fw.rule_lines[off+4].number)
  end

  it "should identify when database ports are permitted from any to any" do
    database_ports = [ 1521, 1526, 1675, 1630, 1701, 1748, 1754, 1808, 1809, 
                       1810, 1830, 1831, 1850, 2481, 2482, 3938, 1158, 5520, 
                       5540, 5560, 5580, 1433 ]

    fwdat, off = 
      make_x2i_fw(*database_ports.map{|p| "permit ip any any eq #{p}"})

    fw = Flint::CiscoFirewall.factory(fwdat)

    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:database)
    res.first.result.should == "fail"
    affected_rules = res.first.affected_rules.all
    database_ports.each_with_index do |pair, idx|
      affected_rules[idx].should == fw.rule_lines[off+idx].number
    end
  end


  it "should identify a 'high risk' protocol permitted from any to any" do
    fwdat, off = make_x2i_fw("permit ip any any eq 174")
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:high_risk_protocol)
    mailq = res.all.find {|x| x.title =~ /mailq/}
    mailq.should_not be_nil
    mailq.result.should ==  "fail"
    mailq.affected_rules.first.should == fw.rule_lines[off].number

    fwdat, off = make_x2i_fw("permit tcp any any eq 80")
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:high_risk_protocol)
    mailq = res.all.find {|x| x.title =~ /mailq/}
    mailq.result.should ==  "pass"

    fwdat, off = make_x2i_fw("deny ip any any", "permit ip any any eq 174")
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:high_risk_protocol)
    mailq = res.all.find {|x| x.title =~ /mailq/}
    mailq.result.should == "pass"
  end

end
