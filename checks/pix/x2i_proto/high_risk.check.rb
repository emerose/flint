x2i_check :high_risk_protocol, "Block high risk protocols" do
  
  ProtocolBlurb.find(:risk => "high").all.each do |pb|
    tcp_ports = pb.tcp_port.all.map { |p| p.to_i }.compact
    udp_ports = pb.udp_port.all.map { |p| p.to_i }.compact
    if ( not tcp_ports.empty? or not udp_ports.empty? )
      with_result do
        set_title "Block #{pb.name}, a high risk protocol (#{@interface.name} -> #{@out_interface.name})"
      
        describe "The #{pb.name} protocol presents a high risk to your network, and should not be allowed into your internal networks from the outside."

        paths = []
        tcp_ports.each do |port|
          if port
            paths.concat(Flint::ServicePath.find( :sha => firewall.sha,
                                                  :protocol => "tcp",
                                                  :out_interface_name => @out_interface.name,
                                                  :in_interface_name => interface.name,
                                                  :port => port ).all)
          end
        end

        udp_ports.each do |port|
          if port
            paths.concat(Flint::ServicePath.find( :sha => firewall.sha,
                                                  :protocol => :udp,
                                                  :out_interface_name => @out_interface.name,
                                                  :in_interface_name => interface.name,
                                                  :port => port ).all)
          end
        end

        paths.each do |path|
          path.lines.all.each do |ln|
            affected_netblocks(path.destination_as_cidr)
            if r = firewall.rule_at(ln)
              if policy_for(r) == :permit
                fail(ln) 
              end
            end
          end
        end
      end
    end
  end
  supress_result # we made all the results explicitely
end
