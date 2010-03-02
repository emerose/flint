x2i_check :ftp, "Cannot FTP directly to internal network from outside" do
  describe "Allowing FTP connections from outside presents a high risk to your network. If it is necessary to allow file transfer connections from outside, consider using a VPN instead."
  permit_select do |rule| 
    match_acl(rule,
              :protocol => :tcp,
              :destination_port => "FTP",
              :destination_new => self.target_cidrset)
              
  end.each do |line|
    fail(line)
    affected_netblocks(line[:destination_net])
  end
end

