module Flint

  class ResolverCache < Ohm::Model
    attribute :sha
    attribute :name
    attribute :address

    index :sha
    index :name
    index :address

    def self.cached?(sha)
      if ResolverCache.find(:sha => sha).size <= 1
        false
      else
        true
      end
    end
  end

  class Resolver
    def initialize(sha)
      @sha = sha
      @hostnames = {}
      @addresses = {}
      self.name("localhost", IPAddr.new("127.0.0.1/255.255.255.255"))
    end

    def hostname(address)
      if(x = @hostnames[address.to_s])
        return x
      elsif (x = ResolverCache.find(:sha => @sha, :address => address).all[0])
        return x.name
      else
        nil
      end
    end
    alias_method :hostname_for, :hostname # XXX

    def address(hostname)
      if (x = @addresses[hostname.to_s])
        return x
      elsif (x = ResolverCache.find(:sha => @sha, :name => hostname).all[0])
        return x.address
      else
        nil
      end
    end
    alias_method :address_for, :address # XXX

    def name(hostname, address)
      @hostnames[address.to_s] = hostname
      @addresses[hostname.to_s] = address

      c = ResolverCache.new
      c.sha = @sha
      c.name = hostname
      c.address = address
      c.save
    end
  end
end
