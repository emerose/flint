
# line 1 "lib/cisco/ralex_pix.rl"
# An example subclassing of Ralex

require 'ralex'


module Cisco
class RalexPix < Ralex::Base


    
# line 92 "lib/cisco/ralex_pix.rl"



    def transform_token(tclass, tok)
        if (key = @keywords.fetch(tok.downcase, nil))
            return key, Keyword.new(tok,key)
        end    

	if tclass == :IPADDR 
            addr = IPAddr.parse(tok)
            return tclass, addr if addr
        end

        case tok
        when /^0x[\dA-Fa-f]+$/
            return :NUMBER, tok.to_i(16)
        when /^\d+$/
            # yield :NUMBER, tok.to_i
            return :NUMBER, tok.to_i #PortNumber.new(tok.to_i)
        else
            return tclass, tok
        end
    end

    
    def initialize(verbose=nil)
        @verbose = verbose

  @keywords  = {
    "no"        =>  :NO,
    "clear"     =>  :CLEAR,
    "conduit"   =>  :CONDUIT,
    "icmp"      =>  :ICMP,
    "ip"      =>  :IP,
    "object-group"    =>  :OBJECT_GROUP,
    "group-object"    =>  :GROUP_OBJECT,
    "network-object"  =>  :NETWORK_OBJECT,
    "protocol-object" =>  :PROTOCOL_OBJECT,
    "icmp-object"   =>  :ICMP_OBJECT,
    "port-object"   =>  :PORT_OBJECT,
    "service-object" => :SERVICE_OBJECT,
    "icmp-type"   =>  :ICMP_TYPE,
    "network"   =>  :NETWORK,
    "protocol"    =>  :PROTOCOL,
    "service"   =>  :SERVICE,
    "tcp-udp"   =>  :TCP_UDP,
    "static"    =>  :STATIC,
    "cdp"    =>  :CDP,
    "both"    =>  :BOTH,
    "interface"   =>  :INTERFACE,
    "netmask"   =>  :NETMASK,
    "norandomseq"   =>  :NORANDOMSEQ,
    "access-list"   =>  :ACCESS_LIST,
    "access-group" => :ACCESS_GROUP,
    "in" => :IN,
    "out" => :OUT,
    "inside"    =>  :INSIDE,
    "device-id" => :DEVICE_ID,
    "buffered" => :BUFFERED,
    "facility" => :FACILITY,
    "timestamp" => :TIMESTAMP,
    "message" => :MESSAGE,
    "history" => :HISTORY,
    "monitor" => :MONITOR,
    "console" => :CONSOLE,
    "queue" => :QUEUE,
    "standby" => :STANDBY,
    "trap" => :TRAP,
    "transparent" => :TRANSPARENT,
    "emblem" => :EMBLEM,
    "format" => :FORMAT,
    "outside"   =>  :OUTSIDE,
    "global"    =>  :GLOBAL,
    "eq"      =>  :EQ,
    "lt"      =>  :LT,
    "gt"      =>  :GT,
    "neq"     =>  :NEQ,
    "range"     =>  :RANGE,
    "permit"    =>  :PERMIT,
    "deny"      =>  :DENY,
    "tcp"     =>  :TCP,
    "udp"     =>  :UDP,
    "any"     =>  :ANY,
    "line"      =>  :LINE,
    "host"      =>  :HOST,
    "alert-interval" => :ALERT_INTERVAL,
    "deny-flow-max" => :DENY_FLOW_MAX,
    "mpls-unicast" => :MPLS_UNICAST,
    "mpls-multicast" => :MPLS_MULTICAST,
    "ipx" => :IPX,
    "bpdu" => :BPDU,
    "ethertype" => :ETHERTYPE,
    "rename" => :RENAME,
    "extended" => :EXTENDED,
    "log" => :LOG,
    "time-range" => :TIME_RANGE,
    "inactive" => :INACTIVE,
    "remark" => :REMARK,
    "standard" => :STANDARD,
    "compiled" => :COMPILED,
    "object-group-search" => :OBJECT_GROUP_SEARCH,
    "webtype" => :WEBTYPE,
    "url" => :URL,
    "per-user-override" => :PER_USER_OVERRIDE,
    "control-plane" => :CONTROL_PLANE,
    "nat" => :NAT,
    "nat-rewrite" => :NAT_REWRITE,
    "nat-control" => :NAT_CONTROL,
    "norandomseq" => :NORANDOMSEQ,
    "dns" => :DNS ,
    "fixup" => :FIXUP,
    "firewall" => :FIREWALL,
    "static" => :STATIC,
    "logging" => :LOGGING,
    "floodguard" => :FLOODGUARD,
    "sysopt" => :SYSOPT,
    "filter" => :FILTER,
    "activex" => :ACTIVEX,
    "except" => :EXCEPT,
    "java" => :JAVA,
    "ftp" => :FTP,
    "url-server" => :URL_SERVER,
    "enable" => :ENABLE,
    "disable" => :DISABLE,
    "allow" => :ALLOW,
    "interact-block" => :INTERACT_BLOCK,
    "cgi-truncate" => :CGI_TRUNCTATE,
    "longurl-truncate" => :LONGURL_TRUNCATE,
    "proxy-block" => :PROXY_BLOCK,
    "class-map" => :CLASS_MAP,
    "description" => :DESCRIPTION,
    "match" => :MATCH,
    "reject" => :REJECT,
    "inspect" => :INSPECT,
    "policy" => :POLICY,
    "policy-map" => :POLICY_MAP,
    "class" => :CLASS,	
    "echo-reply" => :ECHO_REPLY,
    "unreachable" => :UNREACHABLE,
    "source-quench" => :SOURCE_QUENCH, 
    "redirect" => :REDIRECT, 
    "alternate-address" => :ALTERNATE_ADDRESS ,
    "echo" => :ECHO,
    "router-advertisement" => :ROUTER_ADVERTISEMENT,
    "router-solicitation" => :ROUTER_SOLICITATION, 
    "time-exceeded" => :TIME_EXCEEDED, 
    "parameter-problem" => :PARAMETER_PROBLEM,
    "timestamp-request" => :TIMESTAMP_REQUEST,
    "timestamp-reply" => :TIMESTAMP_REPLY,
    "information-request" => :INFORMATION_REQUEST,
    "information-reply" => :INFORMATION_REPLY,
    "mask-request" => :MASK_REQUEST,
    "mask-reply" => :MASK_REPLY,
    "conversion-error" => :CONVERSION_ERROR,
    "mobile-redirec" => :MOBILE_REDIRECT,
    "rate-limit" => :RATE_LIMIT,
    "burst-size" => :BURST_SIZE,
    "same-security-traffic" => :SAME_SECURITY_TRAFFIC,
    "inter-interface" => :INTER_INTERFACE,
    "intra-interface" => :INTRA_INTERFACE,
    "set" => :SET,
    "type" => :TYPE,
    "inspect" => :INSPECT,
    "mode" => :MODE,
    "passive" => :PASSIVE,
    "name" => :NAME,
    "port" => :PORT,
    "nameif" => :NAMEIF,
    "address" => :ADDRESS,
    "security-level" => :SECURITY_LEVEL,
    "shutdown" => :SHUTDOWN,
    "ssh" => :SSH,
    "rip" => :RIP,
    "snmp-server" => :SNMP_SERVER,
    "http" => :HTTP,
    "tftp" => :TFTP,
    "telnet" => :TELNET,
    "trap" => :TRAP,
    "version" => :VERSION,
    "copy" => :COPY,
    "scopy" => :SCOPY,
    "contact" => :CONTACT,
    "location" => :LOCATION,
    "community" => :COMMUNITY,
    "listen-port" => :LISTEN_PORT,
    "traps" => :TRAPS,
    "authentication-certificate" => :AUTHENTICATION_CERTIFICATE,
    "server" => :SERVER,
    "timeout" => :TIMEOUT,
    "route" => :ROUTE

  }


        
# line 210 "lib/cisco/ralex_pix.rb"
class << self
	attr_accessor :_ralex_pix_trans_keys
	private :_ralex_pix_trans_keys, :_ralex_pix_trans_keys=
end
self._ralex_pix_trans_keys = [
	0, 0, 9, 122, 9, 122, 
	9, 122, 9, 122, 9, 
	122, 9, 122, 9, 122, 
	9, 122, 9, 122, 9, 122, 
	9, 122, 9, 122, 9, 
	122, 9, 32, 0, 0, 
	9, 122, 9, 122, 9, 122, 
	9, 122, 9, 122, 9, 
	122, 9, 122, 9, 122, 
	9, 122, 9, 122, 9, 122, 
	9, 122, 9, 122, 9, 
	122, 9, 122, 0, 0, 
	0, 0, 0, 0, 0, 0, 
	0
]

class << self
	attr_accessor :_ralex_pix_key_spans
	private :_ralex_pix_key_spans, :_ralex_pix_key_spans=
end
self._ralex_pix_key_spans = [
	0, 114, 114, 114, 114, 114, 114, 114, 
	114, 114, 114, 114, 114, 114, 24, 0, 
	114, 114, 114, 114, 114, 114, 114, 114, 
	114, 114, 114, 114, 114, 114, 114, 0, 
	0, 0, 0
]

class << self
	attr_accessor :_ralex_pix_index_offsets
	private :_ralex_pix_index_offsets, :_ralex_pix_index_offsets=
end
self._ralex_pix_index_offsets = [
	0, 1, 116, 231, 346, 461, 576, 691, 
	806, 921, 1036, 1151, 1266, 1381, 1496, 1521, 
	1522, 1637, 1752, 1867, 1982, 2097, 2212, 2327, 
	2442, 2557, 2672, 2787, 2902, 3017, 3132, 3247, 
	3248, 3249, 3250
]

class << self
	attr_accessor :_ralex_pix_indicies
	private :_ralex_pix_indicies, :_ralex_pix_indicies=
end
self._ralex_pix_indicies = [
	0, 2, 2, 2, 2, 2, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	2, 1, 3, 4, 1, 1, 1, 3, 
	5, 6, 1, 1, 7, 8, 9, 9, 
	10, 10, 10, 10, 10, 10, 10, 10, 
	10, 10, 1, 1, 11, 1, 12, 1, 
	1, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 1, 1, 1, 1, 9, 
	1, 9, 9, 9, 9, 9, 9, 9, 
	13, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 1, 15, 15, 15, 15, 
	15, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 15, 14, 16, 17, 14, 
	14, 14, 16, 18, 19, 14, 14, 20, 
	21, 22, 22, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 14, 14, 24, 
	14, 25, 14, 14, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 14, 14, 
	14, 14, 22, 14, 22, 22, 22, 22, 
	22, 22, 22, 26, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 14, 28, 
	28, 28, 28, 28, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 28, 27, 
	29, 30, 27, 27, 27, 29, 31, 32, 
	27, 27, 33, 34, 35, 35, 36, 36, 
	36, 36, 36, 36, 36, 36, 36, 36, 
	27, 27, 37, 27, 38, 27, 27, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 27, 27, 27, 27, 35, 27, 35, 
	35, 35, 35, 35, 35, 35, 39, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 27, 28, 28, 28, 28, 28, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 28, 27, 29, 30, 27, 27, 27, 
	29, 31, 32, 27, 27, 33, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 27, 27, 37, 27, 41, 
	27, 27, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 27, 27, 27, 27, 
	40, 27, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 27, 28, 28, 28, 
	28, 28, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 28, 27, 29, 30, 
	27, 27, 27, 29, 31, 32, 27, 27, 
	33, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 27, 27, 
	37, 27, 38, 27, 27, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 27, 
	27, 27, 27, 40, 27, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 27, 
	15, 15, 15, 15, 15, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 15, 
	14, 16, 17, 14, 14, 14, 16, 18, 
	19, 14, 14, 20, 21, 22, 22, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 14, 14, 24, 42, 43, 14, 14, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 14, 14, 14, 14, 22, 14, 
	22, 22, 22, 22, 22, 22, 22, 26, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 14, 28, 28, 28, 28, 28, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 28, 27, 29, 30, 27, 44, 
	27, 29, 31, 32, 27, 27, 33, 45, 
	46, 40, 47, 47, 47, 47, 47, 47, 
	47, 47, 47, 47, 27, 27, 37, 27, 
	38, 27, 27, 40, 40, 40, 40, 40, 
	40, 48, 40, 40, 40, 48, 40, 48, 
	40, 40, 40, 40, 40, 40, 48, 40, 
	40, 40, 40, 40, 40, 27, 27, 27, 
	27, 40, 27, 40, 40, 40, 40, 40, 
	40, 48, 40, 40, 40, 48, 40, 48, 
	40, 40, 40, 40, 40, 40, 48, 40, 
	40, 40, 40, 40, 40, 27, 28, 28, 
	28, 28, 28, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 28, 27, 29, 
	30, 27, 27, 27, 29, 31, 32, 27, 
	27, 33, 40, 40, 40, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 27, 
	27, 37, 27, 38, 27, 27, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	27, 27, 27, 27, 40, 27, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	27, 15, 15, 15, 15, 15, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	15, 14, 16, 17, 14, 14, 14, 16, 
	18, 19, 14, 14, 20, 21, 22, 22, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 14, 14, 50, 51, 25, 14, 
	14, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 14, 14, 14, 14, 22, 
	14, 22, 22, 22, 22, 22, 22, 22, 
	26, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 14, 28, 28, 28, 28, 
	28, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 28, 27, 29, 30, 27, 
	27, 27, 29, 31, 32, 27, 27, 33, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 27, 27, 37, 
	27, 38, 27, 27, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 27, 27, 
	27, 27, 40, 27, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 52, 
	40, 40, 40, 40, 40, 40, 27, 28, 
	28, 28, 28, 28, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 28, 27, 
	29, 30, 27, 27, 27, 29, 31, 32, 
	27, 27, 33, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	27, 27, 37, 27, 38, 27, 27, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 27, 27, 27, 27, 40, 27, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 53, 40, 40, 40, 40, 40, 
	40, 27, 28, 28, 28, 28, 28, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 28, 27, 29, 30, 27, 27, 27, 
	29, 31, 32, 27, 27, 33, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 27, 27, 37, 27, 38, 
	27, 27, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 27, 27, 27, 27, 
	40, 27, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 54, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 27, 28, 28, 28, 
	28, 28, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 28, 27, 29, 30, 
	27, 27, 27, 29, 31, 32, 27, 27, 
	33, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 55, 27, 
	37, 27, 38, 27, 27, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 27, 
	27, 27, 27, 40, 27, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 56, 
	40, 40, 40, 40, 40, 40, 40, 27, 
	58, 58, 58, 58, 58, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 58, 
	57, 0, 28, 28, 28, 28, 28, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 28, 27, 29, 30, 27, 27, 27, 
	29, 31, 32, 27, 27, 33, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 55, 27, 37, 27, 38, 
	27, 27, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 27, 27, 27, 27, 
	40, 27, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 27, 28, 28, 28, 
	28, 28, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 28, 27, 29, 30, 
	27, 27, 27, 29, 31, 32, 27, 27, 
	33, 40, 40, 40, 59, 59, 59, 59, 
	59, 59, 59, 59, 59, 59, 27, 27, 
	37, 27, 38, 27, 27, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 27, 
	27, 27, 27, 40, 27, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 27, 
	28, 28, 28, 28, 28, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 28, 
	27, 29, 30, 27, 27, 27, 29, 31, 
	32, 27, 27, 33, 40, 60, 40, 59, 
	59, 59, 59, 59, 59, 59, 59, 59, 
	59, 27, 27, 37, 27, 38, 27, 27, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 27, 27, 27, 27, 40, 27, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 27, 28, 28, 28, 28, 28, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 28, 27, 29, 30, 27, 27, 
	27, 29, 31, 32, 27, 27, 33, 40, 
	40, 40, 61, 61, 61, 61, 61, 61, 
	61, 61, 61, 61, 27, 27, 37, 27, 
	38, 27, 27, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 27, 27, 27, 
	27, 40, 27, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 27, 28, 28, 
	28, 28, 28, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 28, 27, 29, 
	30, 27, 27, 27, 29, 31, 32, 27, 
	27, 33, 40, 62, 40, 61, 61, 61, 
	61, 61, 61, 61, 61, 61, 61, 27, 
	27, 37, 27, 38, 27, 27, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	27, 27, 27, 27, 40, 27, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	27, 28, 28, 28, 28, 28, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	28, 27, 29, 30, 27, 27, 27, 29, 
	31, 32, 27, 27, 33, 40, 40, 40, 
	63, 63, 63, 63, 63, 63, 63, 63, 
	63, 63, 27, 27, 37, 27, 38, 27, 
	27, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 27, 27, 27, 27, 40, 
	27, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 27, 28, 28, 28, 28, 
	28, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 28, 27, 29, 30, 27, 
	27, 27, 29, 31, 32, 27, 27, 33, 
	64, 40, 40, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 27, 27, 37, 
	27, 38, 27, 27, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 27, 27, 
	27, 27, 40, 27, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 27, 28, 
	28, 28, 28, 28, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 28, 27, 
	29, 30, 27, 27, 27, 29, 31, 32, 
	27, 27, 33, 40, 40, 40, 66, 66, 
	66, 66, 66, 66, 66, 66, 66, 66, 
	27, 27, 37, 27, 38, 27, 27, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 27, 27, 27, 27, 40, 27, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 27, 28, 28, 28, 28, 28, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 28, 27, 29, 30, 27, 27, 27, 
	29, 31, 32, 27, 27, 33, 40, 67, 
	40, 68, 68, 68, 68, 68, 68, 68, 
	68, 68, 68, 27, 27, 37, 27, 38, 
	27, 27, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 27, 27, 27, 27, 
	40, 27, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 27, 28, 28, 28, 
	28, 28, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 28, 27, 29, 30, 
	27, 27, 27, 29, 31, 32, 27, 27, 
	33, 40, 40, 40, 69, 69, 69, 69, 
	69, 69, 69, 69, 69, 69, 27, 27, 
	37, 27, 38, 27, 27, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 27, 
	27, 27, 27, 40, 27, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 27, 
	28, 28, 28, 28, 28, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 28, 
	27, 29, 30, 27, 27, 27, 29, 31, 
	32, 27, 27, 33, 40, 70, 40, 69, 
	69, 69, 69, 69, 69, 69, 69, 69, 
	69, 27, 27, 37, 27, 38, 27, 27, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 27, 27, 27, 27, 40, 27, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 27, 28, 28, 28, 28, 28, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 28, 27, 29, 30, 27, 27, 
	27, 29, 31, 32, 27, 27, 33, 40, 
	40, 40, 71, 71, 71, 71, 71, 71, 
	71, 71, 71, 71, 27, 27, 37, 27, 
	38, 27, 27, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 27, 27, 27, 
	27, 40, 27, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 27, 28, 28, 
	28, 28, 28, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 28, 27, 29, 
	30, 27, 27, 27, 29, 31, 32, 27, 
	27, 33, 40, 72, 40, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 27, 
	27, 37, 27, 38, 27, 27, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	27, 27, 27, 27, 40, 27, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	27, 28, 28, 28, 28, 28, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	28, 27, 29, 30, 27, 27, 27, 29, 
	31, 32, 27, 27, 33, 40, 40, 40, 
	73, 73, 73, 73, 73, 73, 73, 73, 
	73, 73, 27, 27, 37, 27, 38, 27, 
	27, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 27, 27, 27, 27, 40, 
	27, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 27, 28, 28, 28, 28, 
	28, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 28, 27, 29, 30, 27, 
	27, 27, 29, 31, 32, 27, 27, 33, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 27, 27, 37, 
	27, 38, 27, 27, 40, 74, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 27, 27, 
	27, 27, 40, 27, 40, 74, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 27, 75, 
	76, 77, 78, 0
]

class << self
	attr_accessor :_ralex_pix_trans_targs
	private :_ralex_pix_trans_targs, :_ralex_pix_trans_targs=
end
self._ralex_pix_trans_targs = [
	15, 2, 1, 3, 3, 3, 3, 3, 
	4, 5, 7, 6, 9, 10, 2, 1, 
	3, 3, 3, 3, 3, 4, 5, 7, 
	6, 9, 10, 2, 1, 3, 3, 3, 
	3, 3, 4, 5, 7, 6, 9, 10, 
	5, 3, 3, 3, 3, 8, 17, 7, 
	30, 5, 3, 3, 11, 12, 13, 14, 
	16, 15, 0, 18, 19, 20, 21, 22, 
	23, 22, 24, 25, 24, 26, 27, 28, 
	29, 5, 5, 32, 32, 34, 34
]

class << self
	attr_accessor :_ralex_pix_trans_actions
	private :_ralex_pix_trans_actions, :_ralex_pix_trans_actions=
end
self._ralex_pix_trans_actions = [
	1, 2, 0, 3, 4, 5, 6, 7, 
	8, 8, 9, 2, 2, 8, 11, 10, 
	12, 13, 14, 15, 16, 17, 17, 18, 
	11, 11, 17, 20, 19, 21, 22, 23, 
	24, 25, 26, 26, 27, 20, 20, 26, 
	1, 28, 29, 30, 31, 1, 1, 1, 
	1, 32, 33, 34, 1, 1, 1, 1, 
	1, 36, 37, 1, 1, 1, 1, 38, 
	1, 1, 39, 1, 1, 1, 1, 1, 
	1, 38, 40, 42, 43, 45, 47
]

class << self
	attr_accessor :_ralex_pix_eof_actions
	private :_ralex_pix_eof_actions, :_ralex_pix_eof_actions=
end
self._ralex_pix_eof_actions = [
	0, 0, 10, 19, 19, 19, 10, 19, 
	19, 10, 19, 19, 19, 19, 35, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 41, 
	0, 44, 46
]

class << self
	attr_accessor :ralex_pix_start
end
self.ralex_pix_start = 1;
class << self
	attr_accessor :ralex_pix_first_final
end
self.ralex_pix_first_final = 1;
class << self
	attr_accessor :ralex_pix_error
end
self.ralex_pix_error = -1;

class << self
	attr_accessor :ralex_pix_en_quoted_string
end
self.ralex_pix_en_quoted_string = 31;
class << self
	attr_accessor :ralex_pix_en_scarf_comment
end
self.ralex_pix_en_scarf_comment = 33;
class << self
	attr_accessor :ralex_pix_en_main
end
self.ralex_pix_en_main = 1;


# line 287 "lib/cisco/ralex_pix.rl"
    end

    def ragel_machine(data,stack=[],top=0)
            
# line 748 "lib/cisco/ralex_pix.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = ralex_pix_start
	top = 0
end

# line 291 "lib/cisco/ralex_pix.rl"
        
# line 758 "lib/cisco/ralex_pix.rb"
begin
	testEof = false
	_slen, _trans, _keys, _inds, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	end
	if _goto_level <= _resume
	_keys = cs << 1
	_inds = _ralex_pix_index_offsets[cs]
	_slen = _ralex_pix_key_spans[cs]
	_trans = if (   _slen > 0 && 
			_ralex_pix_trans_keys[_keys] <= data[p] && 
			data[p] <= _ralex_pix_trans_keys[_keys + 1] 
		    ) then
			_ralex_pix_indicies[ _inds + data[p] - _ralex_pix_trans_keys[_keys] ] 
		 else 
			_ralex_pix_indicies[ _inds + _slen ]
		 end
	cs = _ralex_pix_trans_targs[_trans]
	if _ralex_pix_trans_actions[_trans] != 0
	case _ralex_pix_trans_actions[_trans]
	when 1 then
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 43 then
# line 95 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 
	c = data[p..p]
		if c == token[0..0]
			if @escape
				token << c            
				@escape = false
			else
				@escape = false
				token << c            
				finish_token
					begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end

			end
		else
			if c == '\\'
				@escape = true
				token << c
			else
				@escape = false
				token << c
			end
		end
		end
	when 47 then
# line 125 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
  c = data[p..p]
                           if (c == '\n' or p == pe)
                              finish_token
                              	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end

                            else 
                              token << c
                            end
                         		end
	when 37 then
# line 51 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:URL) 		end
	when 19 then
# line 82 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
	when 10 then
# line 86 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
	when 4 then
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 123 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 33
		_goto_level = _again
		next
	end
 		end
	when 38 then
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 158 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:IPADDR) 		end
	when 40 then
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 183 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:BYTECOUNT) 		end
	when 39 then
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 56 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:IPSET) 		end
	when 32 then
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 61 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:PORTSET) 		end
	when 7 then
# line 39 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:COMMA) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 5 then
# line 41 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 6 then
# line 42 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 3 then
# line 95 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 
	c = data[p..p]
		if c == token[0..0]
			if @escape
				token << c            
				@escape = false
			else
				@escape = false
				token << c            
				finish_token
					begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end

			end
		else
			if c == '\\'
				@escape = true
				token << c
			else
				@escape = false
				token << c
			end
		end
		end
# line 94 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 @inquote = data[p..p]; 	begin
		stack[top] = cs
		top+= 1
		cs = 31
		_goto_level = _again
		next
	end
 		end
	when 42 then
# line 118 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:STRING) 		end
# line 95 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 
	c = data[p..p]
		if c == token[0..0]
			if @escape
				token << c            
				@escape = false
			else
				@escape = false
				token << c            
				finish_token
					begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end

			end
		else
			if c == '\\'
				@escape = true
				token << c
			else
				@escape = false
				token << c
			end
		end
		end
	when 45 then
# line 133 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:COMMENT) 		end
# line 125 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
  c = data[p..p]
                           if (c == '\n' or p == pe)
                              finish_token
                              	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end

                            else 
                              token << c
                            end
                         		end
	when 31 then
# line 188 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:PERCENTAGE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 8 then
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 33 then
# line 25 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:PORTRANGE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 30 then
# line 30 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:PORTINVERSERANGE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 29 then
# line 35 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:LESSOREQUAL) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 34 then
# line 40 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:GREATEROREQUAL) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 28 then
# line 46 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ARROW) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 36 then
# line 51 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:URL) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 2 then
# line 85 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:UNKNOWN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 9 then
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 148 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:NUMBER) 		end
	when 22 then
# line 82 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 123 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 33
		_goto_level = _again
		next
	end
 		end
	when 25 then
# line 82 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 39 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:COMMA) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 23 then
# line 82 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 41 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 24 then
# line 82 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 42 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 21 then
# line 82 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 95 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 
	c = data[p..p]
		if c == token[0..0]
			if @escape
				token << c            
				@escape = false
			else
				@escape = false
				token << c            
				finish_token
					begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end

			end
		else
			if c == '\\'
				@escape = true
				token << c
			else
				@escape = false
				token << c
			end
		end
		end
# line 94 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 @inquote = data[p..p]; 	begin
		stack[top] = cs
		top+= 1
		cs = 31
		_goto_level = _again
		next
	end
 		end
	when 26 then
# line 82 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 20 then
# line 82 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 85 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:UNKNOWN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 13 then
# line 86 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 123 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 33
		_goto_level = _again
		next
	end
 		end
	when 16 then
# line 86 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 39 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:COMMA) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 14 then
# line 86 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 41 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 15 then
# line 86 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 42 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 12 then
# line 86 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 95 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 
	c = data[p..p]
		if c == token[0..0]
			if @escape
				token << c            
				@escape = false
			else
				@escape = false
				token << c            
				finish_token
					begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end

			end
		else
			if c == '\\'
				@escape = true
				token << c
			else
				@escape = false
				token << c
			end
		end
		end
# line 94 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 @inquote = data[p..p]; 	begin
		stack[top] = cs
		top+= 1
		cs = 31
		_goto_level = _again
		next
	end
 		end
	when 17 then
# line 86 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 11 then
# line 86 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 85 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:UNKNOWN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 27 then
# line 82 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 148 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:NUMBER) 		end
	when 18 then
# line 86 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 148 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:NUMBER) 		end
# line 1333 "lib/cisco/ralex_pix.rb"
	end
	end
	end
	if _goto_level <= _again
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	  case _ralex_pix_eof_actions[cs]
	when 41 then
# line 118 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:STRING) 		end
	when 46 then
# line 134 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 finish_token
        	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 19 then
# line 82 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
	when 10 then
# line 86 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
	when 44 then
# line 133 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:COMMENT) 		end
# line 134 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 finish_token
        	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 35 then
# line 51 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:URL) 		end
# line 82 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 1391 "lib/cisco/ralex_pix.rb"
	  end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end

# line 292 "lib/cisco/ralex_pix.rl"
    end
end


end # end of module