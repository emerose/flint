x2i_check :ssh, "Cannot SSH to internal network from outside" do
  describe "Allowing SSH connections from outside presents a high risk to your network. While SSH is generally considered secure, it has been known to have vulnerabilities. If it is necessary to forward connections from outside, consider using a VPN instead."
  permit_select do |rule| 
    match_acl(rule, :protocol => :tcp,
              :destination_net => self.target_cidrset,
              :destination_port => 22)
  end.each do |line|
    fail(line)
    affected_interface(interface)
    affected_netblocks(line[:destination_net])
  end
end

