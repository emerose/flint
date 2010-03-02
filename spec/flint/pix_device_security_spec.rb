require 'flint'

describe "Pix Device Security Checks" do
  before(:each) do
    Flint.flush_data
    @tg = Flint::TestGroup.load(  FLINT_ROOT + "/checks/pix/device_security.ftg" )
  end

  it "should identify external ssh, http, snmp, and telnet access" do
    @fw = Flint::CiscoFirewall.factory(
"ssh 10.0.0.0 255.0.0.0 outside
 telnet 10.0.0.0 255.0.0.0 outside
 http 10.0.0.0 255.0.0.0 outside
 http 10.0.0.0 255.0.0.0 inside
 snmp-server host outside 10.0.0.0")
    @tr = Flint::TestRunner.new(@tg)
    @tr.run(@fw)
    @tr.results(:dmz_ssh).all.select { |r|
      r.result == "fail" }.size.should == 0

    @tr.results(:external_ssh).all.select { |r|
      r.result == "fail" }.size.should == 1
    @tr.results(:external_telnet).all.select { |r|
      r.result == "fail" }.size.should == 1
    @tr.results(:external_snmp).all.select { |r|
      r.result == "fail" }.size.should == 1
    @tr.results(:external_http).all.select { |r|
      r.result == "fail" }.size.should == 1

  end

  it "should identify dmz ssh, http, snmp, and telnet access" do
    @fw = Flint::CiscoFirewall.factory(
"ssh 10.0.0.0 255.0.0.0 dmz
 telnet 10.0.0.0 255.0.0.0 dmz
 http 10.0.0.0 255.0.0.0 dmz
 http 10.0.0.0 255.0.0.0 dmz
 snmp-server host dmz 10.0.0.0")
    @tr = Flint::TestRunner.new(@tg)
    @tr.run(@fw)

    @tr.results(:external_ssh).all.select { |r|
      r.result == "fail" }.size.should == 0

    @tr.results(:dmz_ssh).all.select { |r|
      r.result == "fail" }.size.should == 1
    @tr.results(:dmz_telnet).all.select { |r|
      r.result == "fail" }.size.should == 1
    @tr.results(:dmz_snmp).all.select { |r|
      r.result == "fail" }.size.should == 1
    @tr.results(:dmz_http).all.select { |r|
      r.result == "fail" }.size.should == 1

  end

  it "should run icmp checks on external interfaces" do
    @fw = Flint::CiscoFirewall.factory(
"access-group 101 in interface outside
icmp permit 1.0.0.0 255.0.0.0 unreachable outside")
    @tr = Flint::TestRunner.new(@tg)
    @tr.run(@fw)

    @tr.results(:device_external_icmp).size.should == 1
    @tr.results(:device_external_icmp).first.result.should == "pass"

    @fw = Flint::CiscoFirewall.factory(
"access-group 101 in interface outside
icmp permit 1.0.0.0 255.0.0.0 echo-reply outside")
    @tr = Flint::TestRunner.new(@tg)
    @tr.run(@fw)

    @tr.results(:device_external_icmp).size.should == 1
    @tr.results(:device_external_icmp).first.result.should == "fail"
                
    @fw = Flint::CiscoFirewall.factory(
"access-group 101 in interface outside")
    @tr = Flint::TestRunner.new(@tg)
    @tr.run(@fw)                      

    @tr.results(:device_external_icmp).size.should == 1
    @tr.results(:device_external_icmp).first.result.should == "fail"

  end

end
