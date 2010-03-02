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
  d.sha = @current_firewall.sha
  d.save
  session[:current_sha] = @current_firewall.sha
  redirect "/upload_process"
end

get "/upload_process" do
  connect_to_model
  Flint::TestResult.find(:sha => @current_firewall.sha).all.each { |r| r.delete }
  redirect "/overview"
end

