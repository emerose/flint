module Flint

  class CiscoFirewall < Firewall
    attr_accessor :resolver

    # Ohm models don't inherit attributes!!!
    attribute :rule_text
    attribute :options_dump
    attribute :sha
    list :lines, CiscoLine

    index :sha

    def initialize(*args)
      super
      @resolver = Resolver.new(sha)
      @rule_cache = {}
    end

    def parse
      # for tracking names
      current_group = nil

      # for rule chains (access lists in this case)
      new_chains = {}
      
      if CiscoLine.find(:sha => sha).empty?
        lno = 0
        rule_text.split("\n").each do |line|
          lno += 1
          l = CiscoLine.factory(sha, line, lno)
          if l.new?
            raise "Unable to save line #{l.errors}"
          end
          self.lines.add(l)
        end
        self.save
      end

      # gotta build our name and DB first
      name_pattern = /^name$/i

      if not ResolverCache.cached? sha
        lines.all.each do |line|
          if (ast = line.load_ast) and ast.first.match(name_pattern)
            resolver.name(ast[2], ast[1])
          end
        end
      end

      if Interface.find(:sha => sha).empty?
        lines.all.each do |line|
          next unless (ast = line.load_ast)

          # nameif
          if ast[0] == :interface_address
            if @current_iconf
              stmt = ast.tail.to_hash
              @current_iconf.address = stmt[:address]
              @current_iconf.netmask = stmt[:netmask]
              @current_iconf.networks << CidrSet.new("#{stmt[:address].to_s}/#{stmt[:netmask].to_s}").to_cidr.first.to_cidr_s
              @current_iconf.save
            end

            # an old form ip address command
          elsif ast[0] == :interface_address_assignment
            stmt = ast.tail.to_hash
            if i = Interface.find(:sha => sha, :name => stmt[:name]).first
              i.address = stmt[:address]
              i.netmask = stmt[:netmask]
              i.networks << CidrSet.new("#{stmt[:address].to_s}/#{stmt[:netmask].to_s}").to_cidr.first.to_cidr_s
              i.save
            else
              i = Interface.create(:name => stmt[:name],
                                   :address => stmt[:address],
                                   :netmask => stmt[:netmask],
                                   :sha => sha)
              i.networks << CidrSet.new("#{stmt[:address].to_s}/#{stmt[:netmask].to_s}").to_cidr.first.to_cidr_s
              i.save
              raise "Unable to save interface object: #{stmt[:name]}" if i.new?
            end

          elsif ast[0] == :interface_security_level
            if @current_iconf
              @current_iconf.security_level = ast[1]
              @current_iconf.save
            end

          elsif ast[0] == :interface_name
            @current_iconf = Interface.create(:sha => sha, :name => ast[1])
            
          elsif ast[0] == :nameif
            # parse old nameif
            stmt = ast.to_hash
            i = ensure_interface(sha,stmt[:name])
            i.security_level = stmt[:security_level].match(/\d+/)[0]
            i.save

          elsif ast[0] == :static
            cmd = ast.to_hash
            ri = ensure_interface(sha,cmd[:real_interface])
            mi = ensure_interface(sha,cmd[:mapped_interface])
            mnet = nil
            rnet = nil
            stype = "static"
            # map real
            if cmd[:real_acl]
              warn "We do not support static maps with ACLs"
            elsif cmd[:real_ip]
              if cmd[:real_netmask]
                rnet = normalize_netspec([cmd[:real_ip], cmd[:real_netmask].to_s])
              else
                rnet = CidrSet.new(cmd[:real_ip])
              end
            end
            
            # mapped to a cidrset
            if cmd[:interface]
              if ri.address.empty?
                warn "No address defined on interface #{mi.name}, cannot create static map: #{line.source}"
              else
                mnet = CidrSet.new(mi.address)
              end
            elsif cmd[:mapped_ip]
              if cmd[:real_netmask] # we inherit the real netmask
                mnet = normalize_netspec([cmd[:mapped_ip], cmd[:real_netmask].to_s])
              else
                mnet = CidrSet.new(cmd[:mapped_ip])
              end
            end

            if stype = "static"
              smap = StaticMap.create(:real_interface_name => cmd[:real_interface],
                                      :mapped_interface_name => cmd[:mapped_interface],
                                      :real => rnet.to_cidr_s,
                                      :mapped => mnet.to_cidr_s)
            elsif stype = "pat"
              warn "We do not support PAT at this time, cannot analyze line: #{line.source}"
            end
                                    
            
            
            # table def
          elsif ast[0].match(/^object-group$/i)
            current_group = Table.create(:sha => sha, :name => ast[2][1])

            # table member
          elsif ast[0].match(/^port-object$/i)
            current_group.add(ast.tail)

            # table member
          elsif ast[0].match(/^protocol-object$/i)
            current_group.add(ast.tail)

            # table member
          elsif ast[0].match(/^network-object$/i)
            current_group.add(ast.tail.first)

            # table member
          elsif ast[0].match(/^group-object$/i)
            current_group.add([:object_group_ref, ast[1]])

            # acl def
          elsif ast[0].match(/^access-list$/i)
            chain_name = ast[1][1]
            new_chains[chain_name] ||= RuleChain.new(chain_name, sha)
            new_chains[chain_name].rules << line.number

            # iface def
          elsif ast[0].match(/^access-group$/i)
            alname = ast[1][1]
            dir = ast[2][1]
            iname = ast[3][1]

            i = ensure_interface(sha,iname)

            # ensure the chain exists
            new_chains[alname] ||= RuleChain.new(alname, sha)

            # add it and save
            i.chains << [alname, ":", dir]
            i.save
          
          elsif ast[0].match(/^route$/i)
            cmd = ast.to_hash
            i = ensure_interface(sha, cmd[:interface])
            i.networks << normalize_netspec(cmd[:network]).to_cidr.first.to_cidr_s
            i.save
          end
        end
        build_realms
        ServicePath.build_service_paths(self)
        ProtocolMap.build_protocol_map(self)
      end
    end

    def build_realms
      opts = self.options
      extr = []
      intr = []
      dmzr = []
      Interface.find(:sha => sha).all.each do |i|
        if i.name.match(/inside/i)
          intr.push(i.name)
        elsif i.name.match(/outside/i)
          extr.push(i.name)
        elsif i.name.match(/dmz/i)
          dmzr.push(i.name)
        end
      end
      opts[:internal_interfaces] = intr
      opts[:external_interfaces] = extr
      opts[:dmz_interfaces] = dmzr
      self.options = opts
      self.save
    end
    
    def ensure_interface(sha, name)
      i = Interface.find(:sha => sha, :name => name).first
      i ||= Interface.create(:name => name,
                             :sha => sha)
      i
    end



    # converts [:host IPAddr|Hostname], IPAddr|Hostname and "any" etc..
    # to Flint::CidrSet.  This will handle name resolution.
    def normalize_netspec(input)

      if input.kind_of? IPAddr
        # it's an netblock, represented as an IPAddr object
        if input.mask_addr == 0
          CidrSet.any
        else
          CidrSet.new(input)
        end

      elsif input.kind_of? String and input.match(/^any$/i)
        # it's any!
        CidrSet.any

      elsif input.kind_of? Array

        if input[0].kind_of? Hostname
          addr = @resolver.address(input[0].to_s)
          if addr
            CidrSet.new("#{addr}/#{input[1]}")
          else
            CidrSet.empty
          end

        elsif input[0].kind_of? IPAddr
          CidrSet.new("#{input[0]}/#{input[1]}")

        elsif ( input[0].kind_of? String and
                input[0].match(/^host$/) )
          # it's a host spec, and should just be a single IPAddr or
          # Hostname object
          if input[1].kind_of? Hostname
            # it's a hostname
            addr = @resolver.address(input[1].to_s)
            if addr
              CidrSet.new(addr)
            else
              CidrSet.empty
            end
          elsif input[1].kind_of? IPAddr
            # it's an IPAddr object
            CidrSet.new(input[1])
          else
            CidrSet.empty
          end

        elsif input[0] == :object_group_ref
          # it's an object group reference
          gset = CidrSet.new
          if grp=groups[input[1]]
            grp.members.each {|mbr|
              gset.add(normalize_netspec(mbr))
            }
          end
          gset
        else
          raise "Error parsing network spec: #{input.inspect}"
        end
      else
        raise "Error parsing network spec: #{input.inspect}"
      end

    end


    def _resolve(p, prot="tcp")
      if p.kind_of? String
        ServiceResolver.lookup_service(p,prot).first
      elsif p.kind_of? PortName
        ServiceResolver.lookup_service(p.name,prot).first
      elsif p.kind_of? PortNumber
        p = p.value
      else
        p
      end
    end
      
    # Converts ports and port ranges in various formats to Flint::PortSet
    def normalize_portspec(input, prot="tcp")
      case input[0]
      when PortRange, PortNumber, PortName 
        PortSet.new(input[0])
      when /^eq$/i
        PortSet.new(input[1])
      when /^range$/i 
        PortSet.new(_resolve(input[1].start) .. _resolve(input[1].stop))
      when /^lt$/i
        PortSet.new(0.._resolve(input[1]))
      when /^gt$/i
        PortSet.new(_resolve(input[1]) .. Flint::PORT_MAX)
      when /^neq$/i  
        PortSet.any().subtract(input[1])
      when :object_group_ref
        gset = PortSet.new()
        if grp=groups[input[1]]
          grp.members.each {|mbr| gset.add(normalize_portspec(mbr)) }
        end
        gset
      else 
        raise "Error parsing port spec: #{input.inspect}"
      end
    end

    def normalize_protocol(input)
      if input.kind_of?(Array)
        f = input[0]
        if f.kind_of? Symbol and f == :object_group_ref
          gset = ProtocolSet.new
          if grp=groups[ input[1] ]
            grp.members.each{|mbr| gset.add(normalize_protocol(mbr.first)) }
          end
          gset
        else
          ProtocolSet.new(*input)
        end
      else
        ProtocolSet.new(input)
      end
    end

    def normalize_icmp_type(input)
      if input.kind_of?(Array)
        f = input[0]
        if f.kind_of? Symbol and f == :object_group_ref
          gset = IcmpTypeSet.new
          if grp=groups[ input[1] ]
            grp.members.each{|mbr| gset = add(normalize_icmp_type(mbr.first)) }
          end
          gset
        else
          IcmpTypeSet.new(*input)
        end
      else
        IcmpTypeSet.new(input)
      end
    end

    def normalize_rule(line)
      line
    end

    def table_by_name(n)
      if (t = Table.find(:sha => sha, :name => n))
        t.members
      else
        nil
      end
    end

    def interfaces
      Interface.find(:sha => sha).all.map do |ifa|
        [ifa.name, ifa]
      end.to_hash
    end

    def rule_lines
      @cached_lines ||= lines.all
      @cached_lines
    end

    def line_at(n)
      self.lines[n.to_i - 1]
    end

    def rule_at(n)
      if l = self.line_at(n)
        l.as_acl(self)
      else
        warn "Not a rule at #{n.to_i - 1}"
        nil
      end
    end

    def chains
      RuleChain.all_by_hash(sha)
    end

    def groups
      Table.find(:sha => sha).map do |t|
        [t.name, t]
      end.to_hash
    end

    def chains_by_name
      RuleChain.all_by_hash(sha).map do |rc|
        [rc.name, rc]
      end.to_hash
    end

    def each_rule_for_chain(x)
      chrules = @rule_cache[x]
      #puts "loading cache" unless chrules
      
      chrules ||=  chains_by_name[x.to_s].rules.map do |lno|
        CiscoLine.find(:sha => sha, :number => lno).first
      end
      @rule_cache[x] = chrules unless @rule_cache[x]
      chrules.each do |rule|
        yield rule
      end
    end
  end
end
