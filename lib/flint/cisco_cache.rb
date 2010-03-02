module Flint
  class CiscoLineParse < Ohm::Model
    attribute :line
    attribute :ast
    attribute :number
    attribute :sha

    index :number
    index :sha

    def tree
      x = Marshal.load(self.ast)
      x.ast ? x.ast.concat([[:lineno, number.to_i]]) : nil
    end
    alias_method :load_ast, :tree

    def source
      self.line
    end

    def comment?
      self.line =~ /^\s*!/
    end

    def error
      Marshal.load(self.ast).try(:error)
    end
  end

  class CiscoParse < Ohm::Model
    attribute :sha
    list :lines, CiscoLineParse
    index :sha
  end

  def self.cisco_parse_to_ohm(lines)
    if (x = CiscoParse.find(:sha => (h = Digest::SHA1::hexdigest(lines)))).empty?
      p = CiscoParse.new
      p.sha = h
      p.save

      lno = 0
      lines.split("\n").each do |line|
        lp = CiscoLineParse.new
        lp.sha = p.sha
        lp.number = lno += 1
        lp.line = line
        lp.ast = Marshal.dump(CiscoLine.new(line, :number => lno).parse)
        lp.save
        p.lines.add(lp)
      end
    else
      p = x.first
    end
    return p
  end
end
