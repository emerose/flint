
module Flint
  # see http://www.iana.org/assignments/icmp-parameters
  ICMP_TYPES = {
    "echo-reply"                  => 0,
    "unreachable"                 => 3,
    "source-quench"               => 4,
    "redirect"                    => 5,
    "alternate-address"           => 6,
    "unassigned"                  => 7,
    "echo"                        => 8,
    "router-advertisement"        => 9,
    "router-solicitation"         => 10,
    "time-exceeded"               => 11,
    "parameter-problem"           => 12,
    "timestamp-request"           => 13,
    "timestamp-reply"             => 14,
    "information-request"         => 15,
    "information-reply"           => 16,
    "mask-request"                => 17,
    "mask-reply"                  => 18,
    "traceroute"                  => 30,
    "conversion-error"            => 31,
    "mobile-host-redirect"        => 32,
    "ipv6-where-are-you"          => 33,
    "ipv6-i-am-here"              => 34,
    "mobile-registration-request" => 35,
    "mobile-registration-reply"   => 36,
    "domain-name-request"         => 37,
    "domain-name-reply"           => 38,
    "photuris"                    => 40,
  }

  class IcmpTypeSet < RangeSet
    ICMP_TYPE_MAX = 0xff

    def self.resolve_type(n)
      if n.kind_of?(Numeric) and (0..ICMP_TYPE_MAX).include?(n)
        return n
      elsif (n.kind_of?(String) or n.kind_of?(Symbol)) and
            (x=ICMP_TYPES[n.to_s])
        return x
      else
        raise(ArgumentError, "Invalid ICMP type: #{n.inspect}")
      end
    end

    def self.max_val
      ICMP_TYPE_MAX
    end

    def coerce(obj)
      IcmpTypeRange.coerce(obj)
    end

    def to_icmp_types
      @ranges.map {|m| m.to_icmp_types }.flatten
    end
    class IcmpTypeRange < RangeSetMember
      def self.coerce(obj)
        case obj
        when Range
          new(obj.first .. obj.last)
        else
          val = IcmpTypeSet.resolve_type(obj)
          new(val .. val)
        end
      end

      def to_icmp_types
        self.to_a.map {|x| (n=ICMP_TYPES.invert[x])? n : x }
      end
    end
  end

end
