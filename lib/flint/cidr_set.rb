class IPAddr
  def +(i)
    IPAddr.inet_addr(self.to_i + i.to_i)
  end

  def -(i)
    IPAddr.inet_addr(self.to_i - i.to_i)
  end
end

module Flint
  
  # A CidrSet contains zero or more CidrRange objects and knows how to add,
  # subtract, merge, and iterate over them in various ways.
  class CidrSet < RangeSet
    ADDR_MAX = IPAddr::IN4MASK

    def self.max_val
      ADDR_MAX
    end

    # A CidrRange represents a contiguous block of IP addresses. Despite the
    # name, it need not begin or end on CIDR block boundaries. It is so named
    # because it is the internal object used within a CidrSet. In general,
    # you probably want to use the CidrSet functions for managing and working
    # with contained CidrRanges as opposed to working directly with the range.
    class CidrRange < RangeSetMember

      def self.coerce(obj)
        new(
          case obj
          when Range
            obj
          when IPAddr
            (obj.bottom.to_i .. obj.top.to_i)
          when String
            if obj =~ /^\s*([^- ]+)\s*-\s*([^- ]+)\s*$/
              unless(ip1=IPAddr.lite($1) and ip2=IPAddr.lite($2) and
                     ip1.bottom.to_i <= ip2.top.to_i)
                raise(ArgumentError, "invalid range #{obj}")
              end

              (ip1.bottom.to_i .. ip2.top.to_i)
            else # IP address string
              unless ip = IPAddr.lite(obj) 
                raise(ArgumentError, "invalid address #{obj}")
              end
              (ip.bottom.to_i .. ip.top.to_i)
            end
          end
        )
      end 


      # Returns a string representing the beginning to end IP address range.
      # i.e. "x.x.x.x-y.y.y.y"
      def to_iprange
        "#{IPAddr.inet_addr(first)}-#{IPAddr.inet_addr(last)}"
      end
      alias to_s to_iprange
      alias inspect to_iprange

      # Iterates over each address in a range (as an IPv4 address string)
      def each_address
        self.each{|addr| yield IPAddr.inet_addr(addr).to_s }
      end

      # Returns an enumerator for each address in a range
      def addresses
        self.to_enum(:each_address)
      end

      # Returns the range as a list of the largest possible CIDR blocks
      def to_cidr
        acc = []

        bottom = self.first
        top = self.last

        if bottom == top
          acc << [bottom, 32]
        else
          while (bottom <= top)
            if bottom & 1 == 1 or bottom == top
                acc << [bottom, 32]
                bottom += 1
            else
              32.downto(0) do |shift_bits| 
                mask = ((ADDR_MAX << shift_bits) & ADDR_MAX) ^ ADDR_MAX
                space = (2 << (shift_bits-1)) - 1
                if (bottom & mask == 0) and (top - bottom) >= space
                  acc << [bottom, 32 - mask.to_s(2).size]
                  bottom += space + 1
                  break
                end
              end
            end
          end
        end

        acc.map {|tup| IPAddr.inet_addr(tup[0]).mask(tup[1]) }
      end

    end # CidrRange


    attr_reader :ranges

    # returns IP range string for each contiguous range in the set
    def to_iprange
      @ranges.map {|x| x.to_iprange}.flatten
    end

    # Iterates over each address in the set
    def each_address
      @ranges.each {|range| range.each_address {|addr| yield addr }}
    end

    # returns an enumerator for all addresses in the set
    def addresses
      self.to_enum(:each_address)
    end

    # Returns the set as an array consisting of the largest possible CIDR 
    # blocks grouped together that are contained in this CidrSet
    def to_cidr
      @ranges.map {|range| range.to_cidr }.flatten
    end

    def to_cidr_s
      to_cidr.map {|x| x.to_cidr_s}
    end

    private
      def coerce(obj)
        CidrRange.coerce(obj)
      end
    public

    # for backward compatability
    def self.bubbleup(range)
      CidrRange.coerce(range).to_cidr
    end

  end # CidrSet
end # Flint
