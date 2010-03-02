# line.rb -- Firewall rule line model
# Copyright (c) 2007 Matasano Security, LLC
# All Rights Reserved.
#
# Purpose:
# - base class for firewall rule line
#
# Outline:
# - Line
#     abstract base



## A firewall rule line, how to render it, and how to pull information
## out of it. "Line" is an abstract class. See PixLine for an example.

module Flint

  class Line < Ohm::Model
    attribute :sha
    attribute :number
    attribute :source

    # marshalled objects
    attribute :ast_dump
    attribute :error_dump
    attribute :tokens_dump

    index :sha
    index :number

    def self.factory(sha, src, num = nil)
      l = new(:sha => sha, 
              :source => src,
              :number => num)
      l.parse   # we parse before we save
      l.create  # we save it here
      if l.new?
        raise "Unable to save line: #{l.errors}"
      end
      l
    end
      
    def ast
      return @ast if @ast
      if self.ast_dump
        @ast = Marshal.load(self.ast_dump).
          concat([[:lineno, self.number.to_i]])
      end
      @ast
    end

    def as_acl(firewall)
      @acl ||= Flint::acl(self.ast, firewall)
      @acl
    end
  

    alias_method :load_ast, :ast
    alias_method :tree, :ast

    def error
      if self.error_dump
        @error ||= Marshal.load(self.error_dump)
      end
    end

    def tokens
      if self.tokens_dump
        @tokens ||= Marshal.load(self.tokens_dump)
      end
    end
    
    # Parse the rule, shoudl populate ast_dump and/or error_dump
    def parse(opts = {})
      nil
    end
    
    # tag the rule, should populate token_dump
    def tag(opts = {})
      nil
    end
    
  end
end # end of module
