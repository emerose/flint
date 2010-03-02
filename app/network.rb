# Stuff for the Network view goes here

def mocknetdata
{"192.168.93.0/24" => {:interfaces => "en1,en0", :protocols => "FTP, SMTP, HTTP"},
"192.168.9.0/24" => {:interfaces => "en1,en0", :protocols => "FTP, SMTP, HTTP"},
"192.168.95.0/24" => {:interfaces => "en1,en0", :protocols => "FTP, SMTP, HTTP"},
"192.168.76.0/24" => {:interfaces => "en1,en0", :protocols => "FTP, SMTP, HTTP"},
"192.168.87.0/24" => {:interfaces => "en1,en0", :protocols => "FTP, SMTP, HTTP"}}
end


get "/network" do
  connect_to_model
  redirect "/overview" unless @current_sha

  @testresults = mocknetdata
  haml :network
end
