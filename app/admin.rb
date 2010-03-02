# User administration stuff

get "/admin" do
	@users = User.all
	haml :admin
end

get "/admin/user/edit/:name" do |name|
	haml :edit_user, :layout => false
end

get "/admin/user/new" do
	haml :new_user, :layout => false
end

post "/admin/user/new" do
	if params[:password1] == params[:password2]
		## XXX ToDo: I break these out because we'll want to sanitize them later.
		password = params[:password1]
		username = params[:username]
		isadmin = params[:isadmin].nil? ? "0" : "1"
		full_name = params[:full_name]
		User.add_user(username, password, full_name, isadmin)
	end
	redirect "/admin"
end

post "/admin/user/edit/:name" do |name|
  User.update_attributes(params)
end

get "/admin/user/delete/:id" do |id|
	user = User[id]
	user.delete
	redirect "/admin"
end