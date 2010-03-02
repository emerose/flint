module Flint
  PORT_MAX = 0xFFFF

  def self.resolve_port(p, prot="tcp")
    case p
    when String
      (p =~ /^\d+$/) ?  p.to_i : ServiceResolver.lookup_service(p.downcase,prot).first
    when PortName : ServiceResolver.lookup_service(p.name,prot).first
    when PortNumber : p.value
    end
  end
  
  # A PortSet contains zero or more RangePorts objects and knows how to add,
  # subtract, merge, and iterate over them in various ways.
  class PortSet < RangeSet
    def self.max_val
      PORT_MAX
    end

    # A RangePorts represents a contiguous range of ports.
    # (our goofy name is to avoid a conflict with the PortRange supplied by the
    # parser)
    class RangePorts < RangeSetMember
      # extend a Range object with this module
      def self._resolve(p)
        return p if (p.kind_of?(Integer) and (0..PORT_MAX).include?(p))
        Flint.resolve_port(p) or raise(ArgumentError, "invalid port : #{p.inspect}")
      end

      def self.coerce(obj)
        case obj
        when Range
          new(obj)
        when PortRange
          new(_resolve(obj.start) .. _resolve(obj.stop))
        when /^\s*([^- ]+)\s*-\s*([^- ]+)\s*$/
          if(p1=_resolve($1) and p2=_resolve($2) and (p1 <= p2))
            new(p1 .. p2)
          else
            raise(ArgumentError, "invalid range #{obj}")
          end
        else
          p = _resolve(obj) 
          new(p .. p)
        end
      end 

      def each_port
        each{|p| yield p}
      end

      def ports
        to_enum(:each_port)
      end

      def all
        ports.to_a
      end
    end # RangePorts


    @@max_val = PORT_MAX

    def ports
      to_enum(:each_port)
    end

    def all
      ports.to_a
    end

    # Iterates over each port in the set
    def each_port
      @ranges.each {|range| range.each_port {|port| yield port }}
    end

    private
      def coerce(obj)
        RangePorts.coerce(obj)
      end
    public
  end

end # Flint
