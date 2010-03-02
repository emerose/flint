before do
	
	## XXX -- ToDo
	## The bootstrap view is insecure. But if you've recently updated and now cannot get into
	## the app because there is no default login, this will allow you to create one. But since
	## it does not get disabled, eventually someone can do bad things with it -- especially since
	## any user created with this form is automatically an admin. We will have to TAKE THIS OUT
	## before we ship. I only put it here so that we wouldn't lock ourselves out of the app
	## after an update. -- Erin
	
	if request.path == "/favicon.ico"
		send_file "public/favicon.ico"
		redirect "/overview"
	end
	
	if not request.path =~ /\/(ui\/|ass)/
  	if not session[:user] and not request.path[0,6] == "/login"
  		session[:login_uri] = request.path
  		redirect "/login"
  	end
	end

  ## XXX ToDo: This is a tell.

	if session[:user] and request.path[0,8] == "/admin"
		redirect "/overview " unless User[session[:user]].is_admin?
	end
end

get "/login" do
    haml :login, :layout => false
end

post "/login" do
  if (user = User.login(params[:login], params[:password]))
    session[:user] = user.id
		nexthop = session[:login_uri]
    nexthop = "/overview" if nexthop.nil?
    redirect nexthop
	else
		redirect "/login"
	end
end

get "/logout" do
	session = nil
	redirect "/login"
end