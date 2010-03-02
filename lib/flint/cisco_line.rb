
module Flint

  class CiscoLine < Line
    # Ohm models don't inherit attributes!!!
    attribute :sha
    attribute :number
    attribute :source

    # marshalled objects
    attribute :ast_dump
    attribute :error_dump
    attribute :tokens_dump

    index :sha
    index :number
    
    def comment?
      !source.empty? && source[0,1] == "!"
    end

    def parse(parser_opts={})
      return self if comment?
      res = Cisco::PixParser.new(parser_opts).safe_parse(self.source)
      if res.kind_of? Array
        self.ast_dump = Marshal.dump(res)
      else
        self.error_dump = Marshal.dump(res)
      end
      self
    end

  end
end
