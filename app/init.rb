require 'yaml'

INCLUDE_PATTERN = /\(\[(.*?):\s*(.*?)\]\)/

class InitFlint  
  def self.inhume(filename="protocols.yml")
    puts "Please wait while Flint loads some data. This will only happen once."
    blob = []
    data = YAML.load(File.read(filename))
    data.each do |k,v|
      opts = v.gsub("-","_").scan(INCLUDE_PATTERN)
      opts << ["name", k.downcase]
      desc = v.split("([")[0].gsub(/\n{1,}/," ")
      opts << ["description", desc]
      ret = {}
      opts.each do |x|
        if ret.has_key? x[0]
          ret[x[0]] << ",#{x[1]}"
        else
          ret[x[0]] = x[1]
        end
        blob << ret
      end
    end
    blob.each do |b|
      pb = ProtocolBlurb.create :name => b["name"]
      pb.save
      pb.update b
    end
  end
end
