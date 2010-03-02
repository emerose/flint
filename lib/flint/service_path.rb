module Flint
  class ServicePath < Ohm::Model
    attribute :sha
    attribute :protocol_name
    attribute :source_cidrset_dump
    attribute :destination_cidrset_dump
    attribute :port
    attribute :protocol
    attribute :in_interface_name
    attribute :out_interface_name
    
    list :lines
    
    index :sha
    index :protocol_name
    index :in_interface_name
    index :out_interface_name
    index :port
    index :protocol

    def destination_as_cidr
      @dest ||= Marshal.load(self.destination_cidrset_dump)
      @dest
    end

    def source_as_cidr
      @src ||= Marshal.load(self.destination_cidrset_dump)
      @src
    end
    
    def self.scan_firewall_for_port(firewall, port, protocol,name)
      
      # if we already scanned it, don't do it again
      return true unless ServicePath.find(:sha => firewall.sha,
                                          :protocol_name => name)

      test = InterfacePairTest.new( :service_path_scan,
                                    "Service Path Scan", {} ) do

        interface_types :external, :dmz
        unless ( firewall.internal?(@out_interface) or
                 firewall.dmz?(@out_interface) )
          raise TestNotApplicable.new("Not building service path index for (#{interface.name} -> #{@out_interface.name})")
        end

        
        dnset = self.target_cidrset
        snset = self.source_cidrset
        protset = ProtocolSet.new(protocol)
        portset = PortSet.new(port)

        m, lines = permit_map_select do |rule|
          match_acl( rule, 
                #     :destination_net => dnset,
                #     :source_net => snset,
                     :protocol => protset,
                     :destination_port => portset )
        end
        
        m.each do |path|
          dnlap = dnset.overlap(path[0])
          snlap = snset.overlap(path[1])
          if ( dnlap and snlap )
            attrs = {:sha => firewall.sha,
              :protocol_name => name,
              :destination_cidrset_dump => Marshal.dump(dnlap),
              :source_cidrset_dump => Marshal.dump(snlap),
              :port => port,
              :protocol => protocol,
              :in_interface_name => interface.name,
              :out_interface_name => @out_interface.name
            }
            p = ServicePath.create(attrs)
            lines.each { |l| 
              p.lines << l[:lineno] 
            }
            p.save
          end
        end
        suppress_result
        true
      end
      test.run(firewall)
      true
    end

    def self.build_service_paths(firewall)
      ProtocolBlurb.all.all.each do |pb|
        pb.tcp_port.all.each do |p|
          p = p.to_i
          next if p == 0
          #puts "Scanning for #{p}:tcp for #{pb.name}"
          Flint::ServicePath.scan_firewall_for_port(firewall,p,:tcp,pb.name)
        end
        pb.udp_port.all.each do |p|
          p = p.to_i
          next if p == 0
          #puts "Scanning for #{p}:udp for #{pb.name}"
          Flint::ServicePath.scan_firewall_for_port(firewall,p,:udp,pb.name)
        end
      end
    end


  end
end
