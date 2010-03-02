x2i_check :smb, "Cannot speak Microsoft file-sharing protocols directly to internal network from outside" do
  
  describe "Microsoft file-sharing protocol (SMB) presents a high risk to your internal network and should not be accessible from outside your firewall. "

  # XXX it should really be possible to handle a port group with permit_select
  # but we cannot do this until the permit_map_select method splits on and 
  # includes additional info in the maps (specifically in this case 
  # destination_port).
  [137,138,139,445].each do |port|
    permit_select do |rule| 
      match_acl(rule, :protocol => [:tcp, :udp], 
                :destination_port => port,
                :destination_new => self.target_cidrset )
    end.each do |line|
      fail(line)
      affected_interface(interface)
      affected_netblocks(line[:destination_net])
    end
  end
end

