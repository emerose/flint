
class Array
  def tail
    self[1..-1]
  end
end


class Symbol
  def match(reg)
    self.to_s.match(reg)
  end
end

module Ohm
  class Model
    def self.flush
      all.map { |o| o.delete }
    end
  end
  module Attributes
    class Collection
      def at(idx)
        k = self.key
        model[Ohm.redis.instance_eval { call_command([:lindex, k, idx])}]
      end

      def [](idx)
        self.at(idx)
      end
    end
  end
end
