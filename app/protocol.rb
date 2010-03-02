# The stuff for the protocol tab goes in here
## XXX ToDo: Tom said to only do tcp and udp. You can see this in views/protocol.haml.
## But at some point, the view needs to show the other protocols as well

def getprots(sha)
  fw = Flint::CiscoFirewall.find(:sha => @current_sha).first
  p = {}
  fw.chains.each do |c|
    fw.each_rule_for_chain(c.name) do |a|
      ast = a.ast.to_hash
      port = ast[:destination_port]
      port ||= ast[:source_port]
      port ||= ["NA", "NA"]
      port << a.number << a.source
      if p.has_key? ast[:protocol]
        p[ast[:protocol]] << port
      else
        p[ast[:protocol]] = [port]
      end
    end
  end
  return p
end

get "/protocol" do
  connect_to_model
  redirect "/overview" unless @current_sha

  @protocols = Flint::ProtocolMap.find(:sha => @current_sha).all
  
  if params[:sort_by] == "risk"
    @protocols.sort! { |a,b| a.risk <=> b.risk }
  else
    @protocols.sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end

  haml :protocol
end
