require 'flint'

def make_x2d_fw(*acl)
  fw = <<_EOF_
#{ acl.map{|x| "access-list 101 #{x}"}.join("\n") }
access-group 101 in interface outside

nameif ethernet0 outside security0
nameif ethernet1 dmz security50
_EOF_
  return fw, 0
end


describe Flint::CiscoFirewall do
  before(:each) do
    Flint.flush_data
    @tg = Flint::TestGroup.load( FLINT_ROOT + 
            "/checks/pix/external_to_dmz.ftg")
  end

  it "should identify when too many hosts can speak http in the dmz" do
    fwdat, off = make_x2d_fw( 'permit tcp any any eq 80' )
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:http_restricted)
    res.first.result.should == "fail"
    res.first.affected_rules.size.should == 1
    res.first.affected_rules.first.should == fw.rule_lines[off].number
    
    fwdat, off = make_x2d_fw( 'permit tcp any host 192.168.1.1 eq 80' )
    fw = Flint::CiscoFirewall.factory(fwdat)
    tr = Flint::TestRunner.new(@tg)
    tr.run(fw)
    res = tr.results(:http_restricted)
    res.first.result.should == "pass"

  end

end
