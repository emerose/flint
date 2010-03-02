x2i_check :database, "Cannot speak database protocols to internal network from outside" do
  database_ports = [
    [ 1521, "oracle enterprise listener",],
    [ 1526, "oracle listener",],
    [ 1675, "oracle names"],
    [ 1630, "oracle connection manager"],
    [ 1701, "oracle jdbc thin"],
    [ 1748, "oracle agent"],
    [ 1754, "oracle agent"],
    [ 1808, "oracle agent"],
    [ 1809, "oracle agent"],
    [ 1810, "oracle manager servlet"],
    [ 1830, "oracle connection manager"],
    [ 1831, "oracle connection manager admin"],
    [ 1850, "oracle RMI"],
    [ 2481, "oracle CORBA"],
    [ 2482, "oracle CORBA SSL"],
    [ 3938, "oracle manager"],
    [ 1158, "oracle console HTTP"],
    [ 5520, "oracle console RMI"],
    [ 5540, "oracle enterprise manager console"],
    [ 5560, "oracle isqlplus"],
    [ 5580, "oracle isqlplus"],

    [ 1433, "microsoft sql server"],

    # XXX NEED:
    
    # the rest of mssql
    # mysql
    # postgres
    # db2
    # sybase
  ]
  
  check_ports = database_ports.map{|x| x.first }

  permit_select do |rule|
    match_acl(rule, :protocol => [:tcp, :udp],
              :destination_port => check_ports,
              :destination_net => self.target_cidrset)
  end.each do |line|
    fail(line)
    affected_netblocks(line[:destination_net])
  end
end

