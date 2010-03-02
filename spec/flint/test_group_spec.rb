require 'flint'

describe Flint::TestGroup do
  it "should load from a file" do
    tg = Flint::TestGroup.load(  File.dirname(__FILE__) + "/test_group.ftg")
    tg.tests.size.should == 4
    tg.description.should == "A test group definition"
  end
end
