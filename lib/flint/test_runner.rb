module Flint
  def self.harness(tg, fw)
    (r = TestRunner.new(tg)).run(fw)
    return r
  end

  class TestRunner
    attr_reader :test_group
    def initialize(test_group)
      @test_group = test_group
      @firewall = nil
    end

    def run(firewall, opts={})
      @firewall = firewall
      TestResult.find(:sha => @firewall.sha,
                      :group => @test_group.code).map { |r| r.delete }

      @test_group.tests.values.each do |t|
        # make sure it's test group is set
        t.group_code = @test_group.code
        t.run(firewall)
      end
    end

    # returns an array of TestResult objects.  if tcodes is a test code,
    # like :syntax_check, then it will return just the results for that
    # test.  If tcodes is a string, it returns the results for the test
    # with that title.  If it is an array of test codes it returns the
    # results for all those tests.
    def results(tcode = nil)
      return [] unless @firewall
      if tcode.kind_of? Symbol
        TestResult.find(:sha => @firewall.sha,
                        :group => @test_group.code,
                        :name => tcode)
      elsif tcode.kind_of? String
        TestResult.find(:sha => @firewall.sha,
                        :group => @test_group.code,
                        :title => tcode)
      else
        TestResult.find(:sha => @firewall.sha, :group => @test_group.code)
      end
    end

    # returns an array of TestResult objects that are errors
    def errors
      return [] unless @firewall
      TestResult.find(:sha => @firewall.sha,
                      :group => @test_group.code,
                      :result => :error)
    end

    # returns an array of TestResult objects that are failures
    def failures
      return [] unless @firewall
      TestResult.find(:sha => @firewall.sha,
                      :group => @test_group.code,
                      :result => :fail)
    end

    # returns an array of TestResult objects that are successes
    def successes
      return [] unless @firewall
      TestResult.find(:sha => @firewall.sha,
                      :group => @test_group.code,
                      :result => :pass)
    end

  end
end
