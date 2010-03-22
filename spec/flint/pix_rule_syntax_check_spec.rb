require 'flint'

describe "Pix Rule Syntax Checks" do
  before(:each) do
    Flint.flush_data
    @tg = Flint::TestGroup.load(  FLINT_ROOT + "/checks/pix/rule_syntax.ftg" )
  end

  it "should identify rules with syntax errors" do
    @fw = Flint::CiscoFirewall.factory("access-list with error
                                     access-list 101 permit tcp any any")
    @tr = Flint::TestRunner.new(@tg)
    @tr.run(@fw)
    res = @tr.results(:syntax_error)
    res.first.effected_rules.size.should == 1
    res.first.effected_rules.first.should == @fw.rule_lines[0].number
  end


end
