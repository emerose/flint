module Flint

  class Firewall < Ohm::Model
    attribute :rule_text
    attribute :options_dump
    attribute :sha
    
    index :sha

    def self.factory(rule_text, options = { })
      sha = Digest::SHA1.hexdigest(rule_text)
      f = self.find(:sha => sha).all.first
      
      f ||= create(:rule_text => rule_text,
                   :sha => Digest::SHA1.hexdigest(rule_text),
                   :options_dump => Marshal.dump(options))
      if f.new?
        raise "Unable to save firewall: #{f.errors}"
      end
      f.parse
      f
    end

    def options
      @options ||=  Marshal.load(self.options_dump)
      @options
    end

    def options=(newopts)
      @options = newopts.clone
      self.options_dump = Marshal.dump(@options)
      @options
    end

    def self.from_file(filename)
      data = File.read(filename)
      self.factory(data)
    end

    def self.load_from_sha(sha)
      f = self.find(:sha => sha).all.first
      f.parse if f
      f
    end

    def parse
      self
    end

    def analyze
      self
    end

    def validate
      assert_unique :sha
    end
    
    def interfaces
      Interface.find(:sha => sha).all.map do |ifa|
        [ifa.name, ifa]
      end.to_hash
    end

    # we model three specific realms of the firewall, external, dmz, and internal
    def external? iface
      interface_realm(iface) == :external
    end

    def internal? iface
      interface_realm(iface) == :internal
    end

    def dmz? iface
      interface_realm(iface) == :dmz
    end

    def interface_realm iface
      iface = iface.name if iface.kind_of? Interface
      options[:realm_map].fetch(iface, nil)
    end
    
    def set_interface_realm(iface, realm)
      iface = iface.name if iface.kind_of? Interface
      updating_options do |opts|
        opts[:realm_map] =  {} unless opts[:realm_map]
        opts[:realm_map][iface] = realm
      end
    end
    
    def updating_options(&block)
      opts = self.options.clone
      yield opts
      self.options = opts
      save
    end

    def realmless? iface
      ! interface_realm(iface)
    end

  end
end
