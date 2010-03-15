require 'rubygems'
require 'ralex/ralextask.rb'

# Ralex files
Ralex::RalexTask.new('lib/cisco/ralex_pix.rb')
RACC="racc"
FLINT_VERSION = File.read('VERSION')
# Racc file

file 'lib/cisco/pix_parser.rb' =>  [ 'lib/cisco/pix_parser.racc',
                                       'lib/cisco/ralex_pix.rb'] do
  sh "cd lib/cisco; #{RACC} -gv -e `which ruby` pix_parser.racc -o pix_parser.rb"
end

task :racc => ['lib/cisco/pix_parser.rb']
task :ralex => ['lib/cisco/ralex_pix.rb']

task :spec => [:racc, :ralex] do
    sh "spec --format nested --colour spec/flint/*_spec.rb"
end

task :build => [:racc, :ralex]

task :init => [:build, :redis] do
  sh "./script/init"
end

task :redis do
  # restarts the redis if it is already running
  if File.exists?('redis.pid')
    rpid = File.read('redis.pid').to_i
    puts "redis-server already running (pid: #{rpid})"
  else
    sh "redis-server redis.conf"
  end
end

task :redis_down do
  if File.exists?('redis.pid')
    rpid = File.read('redis.pid').to_i
    Process.kill(15,rpid)
    File.delete('redis.pid')
  end
end

task :reset  => [:redis] do
  sh "./script/reset"
end

task :app => [:redis, :init] do
  sh "cd app; ruby app.rb"	
  sh "rake redis_down"
end

task :gems do
end

task :tarball do
  sh "git archive --format=tar --prefix=flint-#{FLINT_VERSION}/ HEAD | gzip > flint-#{FLINT_VERSION}.tgz"
end

task :upload_tarball do
  sh "scp flint-#{FLINT_VERSION}.tgz deployer@runplaybook.com:/root/runplaybook-staging/shared/system/storage/flint/flint-#{FLINT_VERSION}.tgz"
end

task :make_current_release do
  # put the readme in place
  sh "scp README deployer@runplaybook.com:/root/runplaybook-staging/shared/system/storage/flint/README"

  # link the flint-current.tgz to the tarball
  sh "ssh deployer@runplaybook.com ln -sf /root/runplaybook-staging/shared/system/storage/flint/flint-#{FLINT_VERSION}.tgz /root/runplaybook-staging/shared/system/storage/flint/flint-current.tgz"

  # and at this old location too
  sh "ssh deployer@runplaybook.com ln -sf /root/runplaybook-staging/shared/system/storage/flint/flint-#{FLINT_VERSION}.tgz /root/runplaybook-staging/shared/system/storage/flint-current.tgz"

end

task :push_release => [:tarball, :upload_tarball, :make_current_release ]

begin
  require 'rake/rdoctask'
rescue => e
    puts "Install the rdoc gem please."
end

if defined?(RDoc) then
  DOC = RDoc::Task.new(:rdoc) do |rd|
    rd.title = 'Flint -- Documentation'
    rd.main = 'README'
    rd.rdoc_dir = 'doc/api'
    rd.options << '--line-numbers' << '--main' << 'README' << '--title' << 'Flint -- Documentation'
    rd.rdoc_files.include %w(README LICENSE.txt lib/**/*.rb)
  end
end
 
