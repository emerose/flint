## The Overview tab stuff goes here.

get "/overview" do
  connect_to_model
  ## XXXToDo: if you reset and haven't cleared your session, the welcome does not fire. --ep
  if @current_firewall
    @testresults =  Flint::TestHook.new(@current_sha).run
  else
    @welcome = true unless @current_firewall
  end

  haml :overview
end

get "/test_result/:id" do |id|
  tr = Flint::TestResult[id]
  haml :test_result_detail, :layout => false, :locals => {:r => tr}
end
