class IPAddr
  def +(i)
    IPAddr.inet_addr(self.to_i + i.to_i)
  end

  def -(i)
    IPAddr.inet_addr(self.to_i - i.to_i)
  end
end

module Flint
  def self.bubbleup(range)
    acc = []

    top = range.last
    bottom = range.first

    while bottom <= top
      ob = bottom

      # mop up odd-numbered starting addresses, which we can't coalesce

      if(bottom & 1 == 1)
        acc << [bottom, 32]
        bottom += 1
      else
        # find the first bit from /32 down to /0 (note the loop count
        # is reversed) that is either set in the start address, or for
        # which a block starting at that address with that width would
        # overrun the range

        0.upto(31) do |bit|
          if (bottom & (1 << bit)) != 0 or (top < (bottom + (1<<(bit))))

#            pp [IPAddr.inet_addr(bottom), IPAddr.inet_addr(top), IPAddr.inet_addr(bottom + (1<<bit)), bit]

            # the netblock to add can't be any wider than "bit" (see
            # above), so walk backwards to find which bit it should
            # actually be

            (bit).downto(0) do |nbit|

              if(top >= (bottom + (1<<(nbit-1))) && bottom & (1 << (nbit-1)) == 0)
#                pp [IPAddr.inet_addr(bottom), IPAddr.inet_addr(top), top, IPAddr.inet_addr((mb = bottom + (1<<nbit))), mb, nbit]

                acc << [bottom, 32 - (nbit - 1)]
                bottom += (1 << (nbit - 1))
                bit = -1
                break
              end
            end

            if(bottom == ob)
              acc << [bottom, 32]
              bottom += 1
            end

            break
          end
        end

        if(bottom == ob)
          acc << [bottom, 32]
          bottom += 1
        end
      end
    end

    acc.map do |tup|
      IPAddr.inet_addr(tup[0]).mask(tup[1])
    end
  end

  class CidrSet
    attr_accessor :set

    def initialize(set = [])
      @set = set
    end

    def subtract(hit)
      @set.select {|x| hit.top >= x.bottom and hit.bottom <= x.top }.
        each do |cand|

        @set.delete cand

        hb, ht, cb, ct = [ hit.bottom.to_i,
                           hit.top.to_i,
                           cand.bottom.to_i,
                           cand.top.to_i ]
        hb = cb if hb < cb
        ht = ct if ht > ct

        if hb == cb
          @set.concat(Flint::bubbleup((ht+1)..ct))
        elsif ht == ct
          @set.concat(Flint::bubbleup(cb..(ht-1)))
        else
          @set.concat(Flint::bubbleup(cb..(hb-1)))
          @set.concat(Flint::bubbleup((ht+1)..ct))
        end
      end

      @set.sort! {|x, y| x.bottom <=> y.bottom}
    end

    def add(hit)
      @set << hit
      @set.sort! {|x, y| x.bottom <=> y.bottom}
    end

    def include?(i)
      @set.find {|x| x.contains(i)}
    end

    def overlap?(i)
      @set.find {|x| x.contains(i) or i.contains(x)}
    end
  end
end
