module Flint
  class ProtocolMap < Ohm::Model
    attribute :sha
    attribute :name
    attribute :risk

    # a list of interfaces [in out in out in out ...]
    list :interfaces
    
    list :from_realms
    list :to_realms
    
    index :name
    index :sha
    index :interfaces
    index :risk
    index :from_realms
    index :to_realms

    def interface_pairs
      it = interfaces.all.clone
      pairs = []
      until it.empty?
        pairs << [it.shift, it.shift]
      end
      pairs
    end
    
    def self.build_protocol_map(firewall)
      ProtocolBlurb.all.all.each do |pb|
        tcp_ports = pb.tcp_port.all.map { |p| p.to_i }.compact
        udp_ports = pb.udp_port.all.map { |p| p.to_i }.compact
        
        pmap = ProtocolMap.find(:sha => firewall.sha, :name => pb.name).first
        
        paths = []
        
        tcp_ports.each do |port|
          paths.concat(ServicePath.find( :sha => firewall.sha,
                                         :protocol => "tcp",
                                         :port => port).all)
        end
        
        udp_ports.each do |port|
          paths.concat(ServicePath.find( :sha => firewall.sha,
                                         :protocol => "udp",
                                         :port => port).all)
        end
        
        interface_pairs = []
        from_realms = []
        to_realms = []

        paths.each do |path|
          pair = [path.in_interface_name, path.out_interface_name]
          from_realm = firewall.interface_realm path.in_interface_name
          to_realm = firewall.interface_realm path.out_interface_name
          
          unless interface_pairs.member?(pair)
            interface_pairs << pair
          end

          unless from_realms.member?(from_realm)
            from_realms << from_realm
          end

          unless to_realms.member?(to_realm)
            to_realms << to_realm
          end
        end
        
        unless interface_pairs.empty?
          pm = ProtocolMap.create(:sha => firewall.sha, 
                                  :name => pb.name,
                                  :risk => pb.risk )
          if pb.risk.empty? 
            pm.risk = "unspecified"
          end
          pm.interfaces.concat(interface_pairs.flatten)
          pm.from_realms.concat(from_realms)
          pm.to_realms.concat(to_realms)
          pm.save
        end
        
      end
      true
    end
  end
end
