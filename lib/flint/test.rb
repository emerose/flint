module Flint

  class Test
    include TestHelpers
    def self.test_by_title
      @@test[:title]
    end

    attr_accessor :result, :block, :group_code, :description, :title
    attr_reader :code, :firewall

    def initialize(code, title, options = { } , &block)
      @code = code
      @title = title
      @title ||= "Unnamed test"
      @description = options[:description]
      @supported_firewalls = options[:firewalls]
      @firewall = nil
      @block = block
      # code identify the test group we are associated/running under
      @group_code = nil
    end

    def supported?(firewall)
      if @supported_firewalls
        if @supported_firewalls.includes?(firewall)
          true
        else
          false
        end
      else
        false
      end
    end

    def run(firewall)
      @firewall = firewall
      @no_result = false
      new_result
      begin
        setup
        test
      rescue TestNotApplicable => e
        @no_result = true
      rescue => e
        warn "Error running check #{code}: #{e.to_s}:\n #{e.backtrace}"
        @result_attrs[:result] = :error
        @result_attrs[:summary] = e.to_s
      ensure
        teardown
        unless @no_result
          push_result
        end
      end
    end

    def with_result
      new_result
      yield
      push_result
    end
    
    def new_result
      @result_attrs = {
        :sha => @firewall.sha,
        :result => :pass,
        :title => @title,
        :name => @code,
        :group => @group_code,
        :summary => "",
        :description => @description ,
        :effected_rules => [],
        :effected_netblocks => CidrSet.new(),
        :effected_interfaces => []
      }
    end

    def push_result
      args = @result_attrs.reject { |k,v|
        [:effected_rules,
         :effected_netblocks,
         :effected_interfaces].member?(k)
      }
      # puts "Calling with #{args.inspect}"
      @result = TestResult.create(args)
      unless @result.save
        raise "Error saving results: #{@result.errors.inspect}"
      end
      @result.effected_rules.concat(@result_attrs[:effected_rules])
      @result.effected_interfaces.concat(@result_attrs[:effected_interfaces])
      
      @result.effected_netblocks.concat( @result_attrs[:effected_netblocks].to_cidr.map { |c|
                                           c.to_cidr_s } )


      unless @result.save
        raise "Error saving results: #{@result.errors.inspect}"
      end
      #t.effected_rules = @result_attrs[:effected_rules]
    end

    def suppress_result
      @no_result = true
    end

    alias :supress_result :suppress_result
    def set_title(str)
      @result_attrs[:title] = str
    end

    def describe(descr)
      @result_attrs[:description] = descr
    end

    def fail(rule = nil, weight = 1)
      @result_attrs[:result] = :fail
      effected_rule(rule) if rule
    end


    def warn(rule = nil, weight = 1)
      @result_attrs[:result] = :warning unless @result_attrs[:result] == :fail
      effected_rule(rule) if rule
    end

    def pass(rule = nil, weight = 1)
      @result_attrs[:result] = :pass
      effected_rule(rule) if rule
    end


    def effected_rule(rule)
      rule = rule.number if rule.kind_of? Line
      rule = rule[:lineno] if rule.kind_of? Hash
      unless @result_attrs[:effected_rules].include?(rule)
        @result_attrs[:effected_rules] << rule
      end
    end
    alias_method :affected_rule, :effected_rule # XXX

    def effected_netblocks(nblock)
      nblock = CidrSet.new(nblock) unless nblock.kind_of? CidrSet
      @result_attrs[:effected_netblocks].add(nblock)
    end
    alias_method :affected_netblocks, :effected_netblocks # XXX

    def interface
      @interface
    end

    def out_interface
      @out_interface
    end

    def effected_interface(iface)
      iface = iface.name if iface.kind_of? Interface
      unless @result_attrs[:effected_interfaces].include?(iface)
        @result_attrs[:effected_interfaces] << iface
      end
    end
    alias_method :affected_interface, :effected_interface # XXX

    def explain(str)
      @result_attrs[:summary] += str
    end

    def summary
      @result_attrs[:summary]
    end

    def rule_text
      @firewall.rule_text
    end

    def summary=(str)
      @result_attrs[:summary] = str
    end

    def chain(name)
      @firewall.chains_by_name[name]
    end

    def each_ast_of(name)
      @firewall.each_rule_for_chain(name) do |lp|
        if (ast = lp.ast)
          yield ast
        end
      end
    end

    def each_acl_of(name)
      @firewall.each_rule_for_chain(name) do |l|
        yield l.as_acl(@firewall)
      end
    end

    def interfaces
      @firewall.interfaces
    end

    def chains
      @firewall.chains
    end

    def rule_text
      @firewall.rule_text
    end
    
    def acl_for(astn, &block)
      if block_given?
        Flint::acl(astn, @firewall, &block)
      else
        Flint::acl(astn, @firewall)
      end
    end
    
    def policy_for(a)
      Flint::policy(a)
    end

    def rule_lines
      @firewall.rule_lines
    end

    def line_at(lno)
      CiscoLine.find(:sha => @firewall.sha, :number => lno).first
    end

    def setup
    end

    def teardown
    end

    def test
      if @block
        instance_eval &@block
      end
    end

    def match_acl(acl, spec)
      return false unless (
        match_protocol(acl, spec[:protocol]) and
        match_source_net(acl, spec[:source_net]) and
        match_destination_net(acl, spec[:destination_net])
      )

      if acl[:protocol].overlap?(:tcp, :udp)
        return(match_destination_port(acl, spec[:destination_port]) and
               match_source_port(acl, spec[:source_port]))
      elsif acl[:protocol].overlap(:icmp)
        return(match_icmp_type(acl, spec[:icmp_type]))
      end

      return true
    end

    def match_source_net(acl, spec)
      if set=acl[:source_net] and spec
        set.overlap?(spec)
      else
        true
      end
    end

    def match_destination_net(acl, spec)
      if set=acl[:destination_net] and spec
        set.overlap?(spec)
      else
        true
      end
    end
    
    
    def match_source_port(acl, *spec)
      spec = spec.compact.flatten
      if acl[:source_port] and not spec.empty?
        if spec.find{|sp| acl[:source_port].overlap?(sp) }
          true
        else
          false
        end
      else
        true
      end
    end
    
    def match_destination_port(acl, *spec)
      spec = spec.compact.flatten
      if acl[:destination_port] and not spec.empty?
        if spec.find{|sp| acl[:destination_port].overlap?(sp) }
          true
        else
          false
        end
      else
        true
      end
    end
    
    def match_protocol(acl, *spec)
      sp = spec.compact.flatten
      if acl[:protocol] and not sp.empty?
        sp.each{|mbr| return true if acl[:protocol].overlap?(mbr)}
        return false
      else
        true
      end
    end

    def match_icmp_type(acl, *spec)
      sp = spec.compact.flatten
      if acl[:icmp_type] and not sp.empty?
        sp.each{|mbr| return true if acl[:icmp_type].overlap?(mbr)}
        return false
      else
        true
      end
    end

    def rule_includes(rule, other)
      if( (rule[:protocol] == :ip and 
           not [:ip, :tcp, :udp].include?(other[:protocol])) or
          (rule[:protocol] != other[:protocol]) )
        return false
      end
      [:destination_net, :destination_port, :source_net, :source_port].each do |x|
        begin 
          return false if (not rule[x].nil?) and (other[x].nil? or not rule[x].superset_of?(other[x]))
        rescue => e
          warn "Error when comparing #{x} of #{rule.inspect} to #{other.inspect}"
          return false
        end
      end  
      return true
    end
  end

  class InterfaceTest < Test
    def run_iface(iface)
      @interface = iface
      @chains_for_interface = iface.chains.all.map {|x| x.split(":")}
      orig_run(@firewall)
    end

    def new_result
      super
      set_title("#{title} (#{@interface.name})")
      affected_interface(@interface.name)
    end

    


    alias :orig_run :run
    
    def each_acl_of_applied_chains
      applied_chains.each do |chain|
        each_acl_of(chain.name) do |acl|
          yield acl
        end
      end
    end    
    
    def each_line_of_applied_chains
      applied_chains.each do |ch|
        @firewall.each_rule_for_chain(ch.name) do |lp|
          yield lp
        end
      end
    end
    
    def applied_chains
      @chains_for_interface.select{ |entry|
        entry[1] == "in"
      }.map {|entry| chain(entry.first) }
    end
    
    
    def permit_select(&block)
      m, lines = permit_map_select(&block)
      lines.select do |line| 
        Flint::policy(line) == :permit and 
          m.find do |dst,src|
          match_destination_net(line, dst) and
            match_source_net(line, src)
        end
      end
    end
    
    def permit_map_select
      acls, all = [], []
      
      ports = [ports] if not ports.kind_of? Array
      
      each_acl_of_applied_chains do |acl|
        acls << acl if yield(acl)
      end
      
      # this is horrific, but we timed it on huge rulesets and it's not
      # worth making it any more clever than this.
      acls.reverse.each do |acl|
        if Flint::policy(acl) == :permit
          dst = acl[:destination_net] 
          src = acl[:source_net] 
          all.each do |k|
            if k.first.overlap? dst
              k.last.add src
            end
          end
          all << [Flint::CidrSet.new(dst), Flint::CidrSet.new(src)]
        else
          all.each do |k|
            if k.first.overlap? acl[:destination_net]
              k.last.subtract(acl[:source_net])
            end
          end
        end
      end
      return [all, acls]
    end



    def run(firewall)
      @firewall = firewall
      firewall.interfaces.each do |iface|
        run_iface(iface.last)
      end
    end
    
    ## Methods for tests to use
    def interface_types(*args)
      @interface_types = args
      unless check_interface?(@interface)
        raise TestNotApplicable.new("Interface #{@interface.name} not of type: #{@interface_types}")
      end
    end
    
    def check_interface?(iface)
      if @interface_types
        if ( @interface_types.member?(:any) or
             ( @interface_types.member?(:external) and
               @firewall.external?(iface) ) or
             ( @interface_types.member?(:dmz) and
               @firewall.dmz?(iface) ) or
             ( @interface_types.member?(:internal) and
               @firewall.internal?(iface) ))
          true
        else
          false
        end
      else
        true
      end
    end
    
  end

  class InterfacePairTest < InterfaceTest
    
    def run_iface_pair (inif , outif)
      @interface = inif
      @out_interface = outif

      @applied_chains = []
      
      inif.chains.all.map {|x| x.split(":")}.
        select {|x| x.last == "in"}.each do |x|
        @applied_chains << @firewall.chains_by_name[x.first]
      end
      
      outif.chains.all.map {|x| x.split(":")}.
        select {|x| x.last == "out"}.each do |x|
        @applied_chains << @firewall.chains_by_name[x.first]
      end

      @source_cidrset = nil
      @target_cidrset = nil

      orig_run(@firewall)
    end

    def destination_cidrset
      internal_cidrset = @out_interface.networks_as_cidrset
    end

    # includes mapped addresses as well as networks on the destination interface
    def target_cidrset
      return @target_cidrset if @target_cidrset
      internal_cidrset = @out_interface.networks_as_cidrset
      mapped_cidrset = @interface.mapped_to_interface(@out_interface.name)
      @target_cidrset = internal_cidrset.add(mapped_cidrset)
    end

    def source_cidrset
      return @source_cidrset if @source_cidrset
      net_cidrset = @interface.networks_as_cidrset
      @source_cidrset = net_cidrset
    end

    def new_result
      super
      set_title "#{title} (#{@interface.name} -> #{@out_interface.name})"
      affected_interface(@interface.name)
      affected_interface(@out_interface.name)
    end
    
    def applied_chains
      @applied_chains.compact
    end
    
    def run(firewall)
      @firewall = firewall
      _interface_pairs.each do |ipair|
        run_iface_pair(ipair[0], ipair[1])
      end
    end
    
    def _interface_pairs
      pairs = []
      @firewall.interfaces.values.each do |inif|
        @firewall.interfaces.values.each do |outif|
          unless ( firewall.external?(inif) and firewall.external?(outif) ) or
                 ( firewall.internal?(inif) and firewall.internal?(outif) ) or
                 ( firewall.dmz?(inif) and  firewall.dmz?(outif) )
            pairs << [inif,outif]
          end
        end
      end
      pairs
    end
    
  end
  
  class X2ITest < InterfacePairTest
    def _interface_pairs
      pairs = super
      pairs.select do |pair|
        @firewall.external?(pair[0]) and
          @firewall.internal?(pair[1])
      end
    end
  end

  class X2DTest < InterfacePairTest
    def _interface_pairs
      pairs = super
      pairs.select do |pair|
        @firewall.external?(pair[0]) and
          @firewall.dmz?(pair[1])
      end
    end
  end

  class D2ITest < InterfacePairTest
    def _interface_pairs
      pairs = super
      pairs.select do |pair|
        @firewall.dmz?(pair[0]) and
          @firewall.internal?(pair[1])
      end
    end
  end
  class D2XTest < InterfacePairTest
    def _interface_pairs
      pairs = super
      pairs.select do |pair|
        @firewall.dmz?(pair[0]) and
          @firewall.external?(pair[1])
      end
    end
  end
  class I2XTest < InterfacePairTest
    def _interface_pairs
      pairs = super
      pairs.select do |pair|
        @firewall.internal?(pair[0]) and
          @firewall.external?(pair[1])
      end
    end
  end
  class I2DTest < InterfacePairTest
    def _interface_pairs
      pairs = super
      pairs.select do |pair|
        @firewall.internal?(pair[0]) and
          @firewall.dmz?(pair[1])
      end
    end
  end
  

  class TestNotApplicable < Exception
  end
end # End Flint module

# a place to put helper functions for tests
