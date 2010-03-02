module Flint

  class NetSpec
    attr_reader :ast
    def initialize(rep)
      @ast = rep
    end

    def ==(spec)
      raise "unimplemented"
    end

    def includes?(x)
      raise "unimplemented"
    end

    def addresses
      raise "unimplemented"
    end
  end

  class NetBlockSpec < NetSpec
    attr_reader :ipaddr
    def initialize(ipaddr, rep)
      super rep
      ipaddr = IPAddr.lite(ipaddr) if ipaddr.kind_of? String
      @ipaddr = ipaddr
    end

    def includes?(x)
      x = x.ipaddr if x.kind_of? NetBlockSpec
      x = IPAddr.lite(x) if x.kind_of? String
      ( self.ipaddr.bottom <= x.bottom and
        self.ipaddr.top >= x.top )
    end

    def ==(spec)
      return true if spec.kind_of? AnyNetSpec
      spec.kind_of? NetSpec and self.ipaddr == spec.ipaddr
    end

    def addresses
      [@ipaddr]
    end
  end

  class NetSetSpec < NetSpec
    attr_reader :ipset
    def initialize(ipset, rep)
      super rep
      @ipset = ipset
    end

    def includes?(x)
      @ipset.bottom.to_i >= x.to_i and @ipset.top.to_i <= x.to_i
    end

    def ==(spec)
      spec.kind_of? NetSetSpec and self.ipset = spec.ipset
    end

    def addresses
      [[@ipset.bottom, @ipset.top]]
    end
  end

  class NetTableSpec < NetSpec
    attr_reader :table
    def initialize(table, rep)
      super rep
      @table = table
    end

    def ==(spec)
      spec.kind_of? NetTableSpec and self.table == spec.table
    end

    def includes?(x)
      table.members.find {|y| y.addresses.include? x} ? true : false
    end

    def addresses
      table.members.map do |entry|
        entry.addresses
      end
    end
  end

  class AnyNetSpec < NetSpec
    def initialize(rep)
      super rep
    end

    def includes?(netspec)
      true
    end

    def ==(spec)
      spec.kind_of? AnyNetSpec
    end


    def addresses
      [IPAddr.lite("0.0.0.0/0")]
    end
  end

  class EmptyNetSpec < NetSpec
    def initialize(rep)
      super rep
    end

    def includes?(netspec)
      false
    end

    def ==(spec)
      spec.kind_of? EmptyNetSpec
    end

    def addresses
      [IPAddr.lite("255.255.255.255/32")]
    end
  end
end
