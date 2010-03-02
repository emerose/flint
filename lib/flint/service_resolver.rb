module Flint

  class ServiceResolver < Ohm::Model
    attribute :service
    attribute :port
    attribute :protocol

    index :service
    index :port
    index :protocol

    def self.init_from_file(fname = (FLINT_ROOT + "/lib/services.txt"))
      ServiceResolver.all.each { |r| r.delete }
      mapping = File.read(fname).split("\n").reject do |x|
        x =~ /^\s*#/
      end.map do |x|
        y = x.split;
        if y.size >= 2
          port, protocol = y[1].split("/") 
          ServiceResolver.map_service(y[0],port,protocol)
        end
      end
      true
    end
    
    def self.map_service(service, port, protocol)
      if r = ServiceResolver.find(:service => service,
                                  :port => port,
                                  :protocol => protocol) and
          not r.empty?
        r
      else
        r = ServiceResolver.create(:service => service,
                                   :port => port,
                                   :protocol => protocol)
        if r.new?
          warn "Error mapping service #{service} to #{port}/#{protocol}: #{r.errors}"
        end
        r
      end
    end

    def self.lookup_service(service, protocol = nil)
      args = {:service => service, :protocol => "tcp"}
      args[:protocol] = protocol if protocol
      res = ServiceResolver.find(args).map { |sr|
        sr.port.to_i
      }
      if res.empty?
        res = ServiceResolver.find(:service => service).map { |sr|
          sr.port.to_i
        }
      end
      if res.empty?

        raise "Unknown service: #{service} for protocol #{protocol}"
      else
        res
      end
    end

  end

end

