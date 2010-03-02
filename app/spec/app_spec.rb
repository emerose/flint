require File.dirname(__FILE__) + '/spec_helper'
require 'tempfile'

describe "Flint" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  def session
    last_request.env['rack.session']
  end

  it "should respond to /login" do
    get "/login"
    last_response.should be_ok
    assert last_response.body.include?("login_form")
  end

  it "should respond to /" do 
    get "/"
    last_response.status.should be 302
  end
  
  it "should log admin in" do
   post "/login", params={:login => "admin", :password => "admin77"} 
   follow_redirect!
   assert_equal "/overview", last_request.path
   # COOKIE = last_response.headers["Set-Cookie"]
   # last_response.headers["Location"].should match /overview/
  end
  
  it "should upload a file" do
    post "/login", params={:login => "admin", :password => "admin77"} 
    # set_cookie(COOKIE)
    post "/upload", "data" => Rack::Test::UploadedFile.new("rules.txt", "text/plain")
    last_response.headers["Location"].should match /upload_process/
    ## XXXToDo: follow redirect, look on page for evidence of this file having been uploaded.
  end
  it "should respond to /overview" do
    post "/login", params={:login => "admin", :password => "admin77"} 
    get "/overview"
    last_response.body.should match /Overall Rating/
  end

  it "should respond to /network" do
    post "/login", params={:login => "admin", :password => "admin77"} 
    get "/network"
    last_response.body.should match /Network Details/
  end

  it "should respond to /interface" do
    post "/login", params={:login => "admin", :password => "admin77"} 
    get "/interface"
    last_response.body.should match /Interfaces Details/
  end

  it "should respond to /protocol" do
    post "/login", params={:login => "admin", :password => "admin77"} 
    get "/protocol"
    last_response.body.should match /Protocol Details/
  end  



end