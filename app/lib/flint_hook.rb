module Flint
  
  class TestHook
    
    attr_reader :tests, :firewall
    
    def initialize(sha)
      @sha = sha
      @tests = Dir["../checks/pix/*.ftg"]
      @firewall = Flint::CiscoFirewall.find(:sha => sha).first

    end
    
    def run_tg? tg
      if @firewall.options[:test_groups]
        @firewall.options[:test_groups].member?(tg.code)
      else
        true
      end
    end
    
    def run
      begin
        saved_results = Flint::TestResult.find(:sha => @sha).all
        results = []
        if saved_results.empty?
          # we run each test
          # first we run the analyzer on the firewall
          @firewall.analyze
          @tests.each do |t|
            tg = Flint::TestGroup.load(t)
            if run_tg?(tg)
              tr = Flint::TestRunner.new(tg)
              tr.run(@firewall)
              results << [tg,tr.results]
            end
          end
        else
          @tests.each do |t|
            tg = Flint::TestGroup.load(t)
            if run_tg?(tg)
              res = saved_results.select { |tr| tr.group == tg.code.to_s }
              results << [tg, res]
            end
          end
        end
        return results
      end
    rescue
      # if the test doesn't run for some reason, return nothing.
      # eventually, we'll want to use this to return errors to the ui
      return []
    end

  end

end
