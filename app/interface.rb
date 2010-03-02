# Stuff for the Interface tab goes here
def collect_interfaces
  bones = {"internal" => [], "external" => [], "dmz" => [], "unknown" => []}
  begin
    fw = Flint::CiscoFirewall.find(:sha => @current_sha).first
    ifs = fw.interfaces
    ifs.each do |x|
      if fw.internal? x[0]
        bones["internal"] << x
      elsif fw.external? x[0]
        bones["external"] << x
      elsif fw.dmz? x[0]
        bones["dmz"] << x
      else
        bones["unknown"] << x
      end
    end
    return bones
  rescue
    return []
  end
end

get "/interface" do
  connect_to_model
  redirect "/overview" unless @current_sha
  @interfaces = collect_interfaces()
  haml :interface
end
