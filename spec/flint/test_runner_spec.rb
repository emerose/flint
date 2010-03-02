require 'flint'

describe Flint::TestRunner do
  before(:each) do
    @fw = Flint::Firewall.factory("")
    @tg = Flint::TestGroup.new(:empty, "Empty Test Group")
  end
  
  it "should run against an empty TestGroup" do
    @tr = Flint::TestRunner.new(@tg)
    @tr.run(@fw)
  end
  
  it "should run against the tests in a TestGroup" do
    atest = Flint::Test.new(:empty, "Empty Test") do
      true if firewall
    end

    @tg.tests[atest.title] = atest
    @tr = Flint::TestRunner.new(@tg)
    @tr.run(@fw)
    @tr.results.size.should == (1)
    @tr.errors.size.should == (0)
  end
  
  it "should catch test errors and set their result value" do
    atest = Flint::Test.new(:empty, "Empty Test") do
      raise "Oops" if firewall
    end
    @tg.tests[atest.title] = atest
    @tr = Flint::TestRunner.new(@tg)
    @tr.run(@fw)
    @tr.results.size.should == (1)
    @tr.errors.size.should == (1)
    @tr.errors.first.name == :empty
  end
  
end
