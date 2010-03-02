require 'ralex/ralextask.rb'

# Ralex files
Ralex::RalexTask.new('lib/cisco/ralex_pix.rb')
RACC="racc"

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

task :init => [:build] do
  sh "./script/init"
end

task :reset  do
  sh "./script/reset"
end

task :app => [:init] do
  sh "cd app; ruby app.rb"	
end

task :gems do

end

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
 
