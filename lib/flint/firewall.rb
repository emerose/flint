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
    end

    def validate
      assert_unique :sha
    end
    
    # we model three specific realms of the firewall, external, dmz, and internal
    def external? iface
      iface = iface.name if iface.kind_of? Interface
      options[:external_interfaces].member?(iface)
    end

    def internal? iface
      iface = iface.name if iface.kind_of? Interface
      options[:internal_interfaces].member?(iface)
    end

    def dmz? iface
      iface = iface.name if iface.kind_of? Interface
      options[:dmz_interfaces].member?(iface)
    end

    def interface_realm iface
      if external? iface
        :external
      elsif internal? iface
        :internal
      elsif dmz? iface
        :dmz
      else
        nil
      end
    end
  end
end
