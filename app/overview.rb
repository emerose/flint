## The Overview tab stuff goes here.

get "/overview" do
  connect_to_model
  ## XXXToDo: if you reset and haven't cleared your session, the welcome does not fire. --ep
  @welcome = true unless @current_sha
  @testresults =  Flint::TestHook.new(@current_sha).run
  haml :overview
end

get "/test_result/:id" do |id|
  tr = Flint::TestResult[id]
  haml :test_result_detail, :layout => false, :locals => {:r => tr}
end
