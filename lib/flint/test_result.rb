module Flint
  class TestResult < Ohm::Model
    
    attribute :sha
    attribute :name
    attribute :title
    attribute :group
    attribute :result
    attribute :grade
    attribute :description
    attribute :summary

    list :effected_rules
    list :effected_netblocks
    list :effected_interfaces

    index :sha
    index :name
    index :group
    index :result

    index :effected_rules
    index :effected_netblocks
    index :effected_interfaces

    def self.create(attrs = {})
      attrs[:result] ||= :pass
      super(attrs)
    end

    alias_method :affected_rules, :effected_rules
    alias_method :affected_interfaces, :effected_interfaces
    alias_method :affected_netblocks, :effected_netblocks

    def validate
      assert_present :name
      assert_present :sha
      assert_present :title
      assert([:pass, :fail, :error, :warning, :notice].member?(self.result),
             :result_invalid)
    end

    def to_s
      s = "(#{name})\n#{title} - #{result.to_s.upcase}\n#{description}"
      if summary 
        s+= "\n#{summary}"
      end
      if not effected_rules.empty?
        s += "\n\nRules:\n"
        s += effected_rules.all.join(", ")
      end
      if not effected_interfaces.empty?
        s += "\n\nInterfaces:\n"
        s += effected_interfaces.all.join(", ")
      end
      if not effected_netblocks.empty?
        s += "\n\nNetblocks:\n"
        s += effected_netblocks.all.join(", ")
      end
      s
    end
  end
end # end of module
