module Flint
  # see http://www.iana.org/assignments/protocol-numbers/
  CISCO_PROTOCOL_NAMES = {
    "ah" => 51,
    "eigrp" => 88,
    "esp" => 50,
    "gre" => 47,
    "icmp" => 1,
    "icmp6" => 58,
    "igmp" => 2,
    "igrp" => 9,
    "ip" => 0,
    "ipinip" => 4,
    "ipsec" => 50,
    "nos" => 94,
    "ospf" => 89,
    "pcp" => 108,
    "pim" => 103,
    "pptp" => 47,
    "snp" => 109,
    "tcp" => 6,
    "udp" => 17,
  }


  class ProtocolSet < RangeSet
    PROTOCOL_MAX = 0xff

    def self.resolve_protocol(n)
      case n
      when Numeric
        raise("Invalid Protocol: #{n}") unless (0..PROTOCOL_MAX).include?(n)
        n
      when String, Symbol
        ::Flint::CISCO_PROTOCOL_NAMES[n.to_s] or raise("Invalid Protocol: #{n}")
      else
        raise(TypeError, "Invalid Protocol: #{n.class}")
      end
    end

    def self.max_val
      PROTOCOL_MAX
    end

    def coerce(obj)
      ProtocolRange.coerce(obj)
    end

    def to_protocols
      if any?
        [:any]
      else
        @ranges.map {|x| x.to_protocols }.flatten
      end
    end

    ###
    # here we add a number of convenience methods based on the ENUM
    
    ::Flint::CISCO_PROTOCOL_NAMES.keys.each do |proto|
      define_method(:"is_#{proto}?"){ __send__(:==, ProtocolSet.new(proto)) }
    end

    class ProtocolRange < RangeSetMember
      def self._resolve(n)
        ProtocolSet.resolve_protocol(n)
      end

      def self.coerce(obj)
        case obj
        when :ip, "ip", _resolve("ip"), :any, nil
          new(0 .. PROTOCOL_MAX)
        when Range # this is only really ever used internally
          if obj.last <= PROTOCOL_MAX
            new(obj.first .. obj.last)
          else
            raise("Protocol numbers can't be higher than #{PROTOCOL_MAX}: #{n}")
          end
        else
          n = _resolve(obj)
          new(n .. n)
        end
      end

      def to_protocols
        self.to_a.map {|x| (n=CISCO_PROTOCOL_NAMES.invert[x]) ? n : x }
      end
    end

  end
end

