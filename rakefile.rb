begin
  require 'rubygems'
rescue LoadError
  puts "******************************************************************************"
  puts "Please install RubyGems, see: http://docs.rubygems.org/read/chapter/3"
  puts "******************************************************************************"
  exit 1
end

begin
  require 'ralex/ralextask.rb'
  # Ralex files
  Ralex::RalexTask.new('lib/cisco/ralex_pix.rb')
  # Racc file
rescue LoadError
  #puts "Cannot load Ralex, so you will not be able to update the lexers"
end

RACC="racc"
FLINT_VERSION = File.read('VERSION')


namespace "bundler" do
  task :gem do
    # install bundler
    maj,min,rev = `gem --version`.split(".").map{|n| n.to_i}
    current_gem_version = ( maj * 1000) + (min * 100) + (rev * 10 )
    target_gem_version = ( 1 * 1000) + ( 3 * 100) + ( 6 * 10 )
    unless current_gem_version >= target_gem_version  
      puts "******************************************************************************"
      puts " Please upgrade your rubygems to 1.3.6 or better:"
      puts "    sudo gem install rubygems-update"
      puts "    sudo update_rubygems"
      puts "******************************************************************************"
      exit 1
    end
    sh("[ -e vendor/bin/bundle ] || gem install vendor/cache/bundler*.gem --no-rdoc --no-ri --user-install --bindir vendor/bin")
  end
  
  task :uninstall do
    sh("gem uninstall -i vendor")
  end
  
  task :install => [ :gem ] do
    # install our dependencies
    sh("vendor/bin/bundle check || vendor/bin/bundle install vendor --disable-shared-gems --without development")
  end
end

namespace "redis" do

  task :uninstall do
    sh("[ -e vendor/bin/redis-server ] && rm vendor/bin/redis-server")
  end

  task :install do
    sh("[ -e vendor/bin/redis-server ] || ( cd vendor && tar xzvf redis-1.2.5.tar.gz && cd redis-1.2.5 && make && cp redis-server ../bin/redis-server )" )
  end
end

task :install => [ "bundler:install", "redis:install"] 

task :uninstall => [ "bundler:uninstall", "redis:uninstall"] 

file 'lib/cisco/pix_parser.rb' =>  [ 'lib/cisco/pix_parser.racc',
                                       'lib/cisco/ralex_pix.rb'] do
  sh "cd lib/cisco; #{RACC} -gv -e `which ruby` pix_parser.racc -o pix_parser.rb"
end

task :racc => ['lib/cisco/pix_parser.rb']
task :ralex => ['lib/cisco/ralex_pix.rb']

task :spec => [:racc, :ralex, :redis] do
    sh "spec --format nested --colour spec/flint/*_spec.rb"
end

task :build => [:racc, :ralex]

task :init => [:build, :redis] do
  sh "./script/init"
end

task :redis do
  # restarts the redis if it is already running
  rpid = nil
  if File.exists?('redis.pid')
    rpid = File.read('redis.pid').to_i
    begin
      Process.kill(0,rpid)
      puts "redis-server already running (pid: #{rpid})"
    rescue 
      puts "redis.pid file is stale, removing"
      File.delete('redis.pid')
      rpid = nil
    end
  end
  
  unless rpid
    sh "vendor/bin/redis-server redis.conf"
  end
end

task :redis_down do
  if File.exists?('redis.pid')
    rpid = File.read('redis.pid').to_i
    File.delete('redis.pid')
    Process.kill(15,rpid)
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

namespace "release" do
  task :changelog do
    sh "script/git-changelog > ChangeLog"
  end
  task :tarball do
    sh "git archive --format=tar --prefix=flint-#{FLINT_VERSION}/ HEAD | gzip > flint-#{FLINT_VERSION}.tgz"
  end

  task :upload_tarball do
    sh "scp flint-#{FLINT_VERSION}.tgz deployer@runplaybook.com:/root/runplaybook-staging/shared/system/storage/flint/flint-#{FLINT_VERSION}.tgz"
  end

  task :make_current do
    # put the readme in place
    sh "scp README deployer@runplaybook.com:/root/runplaybook-staging/shared/system/storage/flint/README"

    # link the flint-current.tgz to the tarball
    sh "ssh deployer@runplaybook.com ln -sf /root/runplaybook-staging/shared/system/storage/flint/flint-#{FLINT_VERSION}.tgz /root/runplaybook-staging/shared/system/storage/flint/flint-current.tgz"

    # and at this old location too
    sh "ssh deployer@runplaybook.com ln -sf /root/runplaybook-staging/shared/system/storage/flint/flint-#{FLINT_VERSION}.tgz /root/runplaybook-staging/shared/system/storage/flint-current.tgz"

  end

  task :push => [:tarball, :upload_tarball, :make_current ]
end

begin
  require 'rake/rdoctask'
rescue LoadeError => e
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
 
