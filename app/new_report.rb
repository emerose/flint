# View to run a new report

get "/new" do
    haml :new_report, :layout => false
end

post "/upload" do
  ## XXXToDo @current_user is nil.
  if params[:data]
    d = Rules.create(:filename => params[:data][:filename],
                     :owner => @current_user,
                     :date => Time.now)
    rlines = params[:data][:tempfile].readlines
    d.rule_text.concat(rlines.join)
  elsif params[:rule_text]
    d = Rules.create(:filename => "rules_uploaded_#{Time.now.to_i}.txt",
                     :owner => @current_user,
                     :date => Time.now)
    d.rule_text.concat(params[:rule_text].split("\r"))
  end
  d.save
  @current_firewall = Flint::CiscoFirewall.factory(d.rule_text.all.join)
  session[:current_sha] = @current_firewall.sha
  d.sha = @current_firewall.sha
  d.save
  haml :preprocess
end


# preps a firewall for analysis
post "/preprocess" do
  connect_to_model
  if @current_firewall
    @current_firewall.interfaces.each do |ipair|
      irealm = params["#{ipair[0]}_realm"]
      puts "Interface #{ipair[0]} set to #{irealm}"
      if irealm == "external"
        @current_firewall.set_interface_realm(ipair[0],:external)
      elsif irealm == "internal"
        @current_firewall.set_interface_realm(ipair[0],:internal)
      elsif irealm == "dmz"
        @current_firewall.set_interface_realm(ipair[0],:dmz)
      else
        @current_firewall.set_interface_realm(ipair[0],nil)
      end
    end

    runthese = []
    get_test_groups.each do |tg|
      r = params["run_#{tg.code}"]
      if r == "YES"
        runthese.push(tg.code)
      end
    end
    @current_firewall.updating_options do |opts|
      opts[:test_groups] = runthese
    end
    redirect "/run_tests"
  end
  haml :preprocess
end

get "/run_tests" do
  connect_to_model
  if @current_firewall
    Flint::TestResult.find(:sha => @current_firewall.sha).each { |r| r.delete }
  end
  redirect "/overview"
end
