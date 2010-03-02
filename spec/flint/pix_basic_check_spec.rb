require 'flint'

describe "Pix Basic Checks" do
  before(:each) do
    Flint.flush_data
    @tg = Flint::TestGroup.load(  FLINT_ROOT + "/checks/pix/basic.ftg" )
  end

  it "should identify rules that allow any to any" do
    @fw = Flint::CiscoFirewall.factory("access-list 101 permit tcp any any
                                        access-list 101 permit icmp any any
                                        access-group 101 in interface outside")
    @tr = Flint::TestRunner.new(@tg)
    @tr.run(@fw)
    res = @tr.results(:allow_any_to_any)
    res.first.effected_rules.size.should == 1
    res.first.effected_rules.first.should == @fw.rule_lines[0].number
  end

  it "should identify rules that allow any service" do
    @fw = Flint::CiscoFirewall.factory("access-list 101 permit tcp host 1.1.1.1 host 2.2.2.2
access-list 101 permit tcp host 1.1.1.1 host 2.2.2.2 range 1 5000
access-list 101 permit tcp host 1.1.1.1 any eq www
                                    access-group 101 in interface outside")
    @tr = Flint::TestRunner.new(@tg)
    @tr.run(@fw)
    res = @tr.results(:allow_any_service)
    res.first.effected_rules.size.should == 2
    res.first.effected_rules.first.should == @fw.rule_lines[0].number
  end

end

