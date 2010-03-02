module Flint

  class RuleChainCache < Ohm::Model
    attribute :sha
    attribute :name
    list :rules

    index :name
    index :sha
  end

  class RuleChain
    attr_accessor :name, :interfaces

    def self.all_by_hash(sha)
      RuleChainCache.find(:sha => sha).map do |r|
        RuleChain.new(r.name, r.sha, :cached => r)
      end
    end

    def initialize(name, sha, opts={})
      @name = name
      # keyed on interface name, value is a direction
      @interfaces = {}
      @sha = sha

      if opts[:cached]
        @c = opts[:cached]
      elsif (r = RuleChainCache.find(:sha => sha, :name => name)).empty?
        @c = RuleChainCache.new
        @c.name = name
        @c.sha = sha
        @c.save
      else
        @c = r.first
      end
    end

    def rules
      @c.rules
    end
  end
end
