module Flint
  VERSION = "0.1"

  def self.flush_data
    CiscoFirewall.flush
    CiscoLine.flush
    Line.flush
    Interface.flush
    ResolverCache.flush
    Firewall.flush
    RuleChainCache.flush
    Table.flush
    TestResult.flush
    StaticMap.flush
    ServicePath.flush
    true
  end

  # Connects to Ohm
  def self.start
    Ohm.connect
  end

  module TestHelpers
    
  end

end



FLINT_ROOT = File.expand_path(File.dirname(__FILE__) + "/..") unless defined?(FLINT_ROOT)

require 'ralex'
require 'matasano_utils'
require 'ohm'
require 'enumerator'

require 'flint/extensions'
require "flint/util"
require 'flint/range_set'
require "flint/cidr_set"
require "flint/port_set"
require "flint/protocol_set"
require "flint/icmp_type_set"

require 'flint/test'
require 'flint/test_group'
require 'flint/test_runner'
require 'flint/test_result'

require 'flint/firewall'
require 'flint/line'
require 'flint/service_resolver'
require 'flint/protocol_blurb'
require 'flint/resolver'
require 'flint/table'
require 'flint/interface'
require 'flint/rule_chain'
require 'flint/static_map'
require 'flint/service_path'
require 'flint/protocol_map'


require 'cisco/ralex_pix'
require 'cisco/pix_parser'
require "flint/cisco_line"
require "flint/cisco_firewall"

Flint::start
