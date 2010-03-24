## Stuff that we didn't write goes here:
require 'pp'
require 'digest/md5'
require 'digest/sha1'

# include the base of our flint project
$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"
require 'flint'
require 'sinatra' 
require 'haml' 


unless File.exists?('app_secret.txt')
  srand
  seed = "--#{rand(10000)}--#{Time.now}--"
  sec = Digest::SHA1.hexdigest(seed)
  File.open('app_secret.txt','w').write(sec)
end

sec=File.read('app_secret.txt')
use Rack::Session::Cookie, :key => 'rack.session',
:secret => sec

# Don't put any actions in this file.
require 'helpers'
require 'models'
require 'lib/flint_hook'

# actions go here
require 'login'
require 'admin'
require 'overview'
require 'network'
require 'new_report'
require 'protocol'
require 'interface'


# compile sass 
`bundle exec sass public/ui/style/main.sass public/ui/style/main.css || echo "Could not find sass"`

if User.all.empty?
  User.add_user("admin", "admin77", "Administrator", "1")
  puts "First user created. Login in with admin/admin77"
end


def connect_to_model
  @current_sha = session[:current_sha]
  last_rule = Rules.all.all[-1]
  (@current_sha ||= last_rule.sha) if last_rule
  @current_firewall = Flint::CiscoFirewall.find(:sha => @current_sha).all.first unless @current_sha.empty?
  
  # we got a bad sha
  unless @current_firewall
    @current_sha = nil
  end

  if session[:user] and u = User[session[:user]]
    @current_user = u
  end
end

unless ENV['RACK_ENV'] == "production"
  set :host, '127.0.0.1'
end

set :environment, Proc.new { if ( ENV['RACK_ENV'].empty? )
                               :production
                             else
                               :development
                             end 
}

set :haml, {:escape_html => :true}

# needed until we get Ohm behaving better.
set :lock, true

get "/" do
    redirect "/overview"
end
