
# line 1 "lib/cisco/ralex_pix.rl"
# An example subclassing of Ralex

require 'ralex'


module Cisco
class RalexPix < Ralex::Base


    
# line 94 "lib/cisco/ralex_pix.rl"



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
	0, 0, 9, 126, 9, 126, 
	9, 126, 9, 126, 9, 
	126, 9, 126, 9, 126, 
	9, 126, 9, 126, 9, 126, 
	9, 126, 9, 126, 9, 
	126, 9, 32, 0, 0, 
	9, 126, 9, 126, 9, 126, 
	9, 126, 9, 126, 9, 
	126, 9, 126, 9, 126, 
	9, 126, 9, 126, 9, 126, 
	9, 126, 9, 126, 9, 
	126, 9, 126, 0, 0, 
	0, 0, 0, 0, 0, 0, 
	0
]

class << self
	attr_accessor :_ralex_pix_key_spans
	private :_ralex_pix_key_spans, :_ralex_pix_key_spans=
end
self._ralex_pix_key_spans = [
	0, 118, 118, 118, 118, 118, 118, 118, 
	118, 118, 118, 118, 118, 118, 24, 0, 
	118, 118, 118, 118, 118, 118, 118, 118, 
	118, 118, 118, 118, 118, 118, 118, 0, 
	0, 0, 0
]

class << self
	attr_accessor :_ralex_pix_index_offsets
	private :_ralex_pix_index_offsets, :_ralex_pix_index_offsets=
end
self._ralex_pix_index_offsets = [
	0, 1, 120, 239, 358, 477, 596, 715, 
	834, 953, 1072, 1191, 1310, 1429, 1548, 1573, 
	1574, 1693, 1812, 1931, 2050, 2169, 2288, 2407, 
	2526, 2645, 2764, 2883, 3002, 3121, 3240, 3359, 
	3360, 3361, 3362
]

class << self
	attr_accessor :_ralex_pix_indicies
	private :_ralex_pix_indicies, :_ralex_pix_indicies=
end
self._ralex_pix_indicies = [
	0, 2, 2, 2, 2, 2, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	2, 3, 4, 5, 6, 7, 8, 4, 
	9, 10, 11, 12, 13, 14, 15, 16, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 18, 19, 20, 21, 22, 23, 
	24, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 25, 1, 26, 27, 28, 
	29, 15, 15, 15, 15, 15, 15, 15, 
	30, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 31, 1, 32, 33, 1, 
	35, 35, 35, 35, 35, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 35, 
	36, 37, 38, 39, 40, 41, 37, 42, 
	43, 44, 45, 46, 47, 48, 49, 50, 
	50, 50, 50, 50, 50, 50, 50, 50, 
	50, 51, 52, 53, 54, 55, 56, 57, 
	48, 48, 48, 48, 48, 48, 48, 48, 
	48, 48, 48, 48, 48, 48, 48, 48, 
	48, 48, 48, 48, 48, 48, 48, 48, 
	48, 48, 58, 34, 59, 60, 61, 62, 
	48, 48, 48, 48, 48, 48, 48, 63, 
	48, 48, 48, 48, 48, 48, 48, 48, 
	48, 48, 48, 48, 48, 48, 48, 48, 
	48, 48, 64, 34, 65, 66, 34, 68, 
	68, 68, 68, 68, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 68, 69, 
	70, 71, 72, 73, 74, 70, 75, 76, 
	77, 78, 79, 80, 81, 82, 83, 83, 
	83, 83, 83, 83, 83, 83, 83, 83, 
	84, 85, 86, 87, 88, 89, 90, 81, 
	81, 81, 81, 81, 81, 81, 81, 81, 
	81, 81, 81, 81, 81, 81, 81, 81, 
	81, 81, 81, 81, 81, 81, 81, 81, 
	81, 91, 67, 92, 93, 94, 95, 81, 
	81, 81, 81, 81, 81, 81, 96, 81, 
	81, 81, 81, 81, 81, 81, 81, 81, 
	81, 81, 81, 81, 81, 81, 81, 81, 
	81, 97, 67, 98, 99, 67, 68, 68, 
	68, 68, 68, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 68, 69, 70, 
	71, 72, 73, 74, 70, 75, 76, 77, 
	78, 79, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 84, 
	85, 86, 87, 101, 89, 90, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	91, 67, 92, 93, 100, 95, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	97, 67, 98, 99, 67, 68, 68, 68, 
	68, 68, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 68, 69, 70, 71, 
	72, 73, 74, 70, 75, 76, 77, 78, 
	79, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 84, 85, 
	86, 87, 88, 89, 90, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 91, 
	67, 92, 93, 100, 95, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 97, 
	67, 98, 99, 67, 68, 68, 68, 68, 
	68, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 68, 69, 70, 71, 72, 
	73, 74, 70, 75, 76, 77, 78, 79, 
	80, 81, 82, 83, 83, 83, 83, 83, 
	83, 83, 83, 83, 83, 84, 85, 86, 
	102, 103, 89, 90, 81, 81, 81, 81, 
	81, 81, 81, 81, 81, 81, 81, 81, 
	81, 81, 81, 81, 81, 81, 81, 81, 
	81, 81, 81, 81, 81, 81, 91, 67, 
	92, 93, 94, 95, 81, 81, 81, 81, 
	81, 81, 81, 96, 81, 81, 81, 81, 
	81, 81, 81, 81, 81, 81, 81, 81, 
	81, 81, 81, 81, 81, 81, 97, 67, 
	98, 99, 67, 68, 68, 68, 68, 68, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 68, 69, 70, 71, 72, 104, 
	74, 70, 75, 76, 77, 78, 79, 105, 
	106, 100, 107, 107, 107, 107, 107, 107, 
	107, 107, 107, 107, 84, 85, 86, 87, 
	88, 89, 90, 100, 100, 100, 100, 100, 
	100, 108, 100, 100, 100, 108, 100, 108, 
	100, 100, 100, 100, 100, 100, 108, 100, 
	100, 100, 100, 100, 100, 91, 67, 92, 
	93, 100, 95, 100, 100, 100, 100, 100, 
	100, 108, 100, 100, 100, 108, 100, 108, 
	100, 100, 100, 100, 100, 100, 108, 100, 
	100, 100, 100, 100, 100, 97, 67, 98, 
	99, 67, 68, 68, 68, 68, 68, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 68, 69, 70, 71, 72, 73, 74, 
	70, 75, 76, 77, 78, 79, 100, 100, 
	100, 109, 109, 109, 109, 109, 109, 109, 
	109, 109, 109, 84, 85, 86, 87, 88, 
	89, 90, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 91, 67, 92, 93, 
	100, 95, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 97, 67, 98, 99, 
	67, 68, 68, 68, 68, 68, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	68, 69, 70, 71, 72, 73, 74, 70, 
	75, 76, 77, 78, 79, 80, 81, 82, 
	83, 83, 83, 83, 83, 83, 83, 83, 
	83, 83, 84, 85, 110, 111, 88, 89, 
	90, 81, 81, 81, 81, 81, 81, 81, 
	81, 81, 81, 81, 81, 81, 81, 81, 
	81, 81, 81, 81, 81, 81, 81, 81, 
	81, 81, 81, 91, 67, 92, 93, 94, 
	95, 81, 81, 81, 81, 81, 81, 81, 
	96, 81, 81, 81, 81, 81, 81, 81, 
	81, 81, 81, 81, 81, 81, 81, 81, 
	81, 81, 81, 97, 67, 98, 99, 67, 
	68, 68, 68, 68, 68, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 68, 
	69, 70, 71, 72, 73, 74, 70, 75, 
	76, 77, 78, 79, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 84, 85, 86, 87, 88, 89, 90, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 91, 67, 92, 93, 100, 95, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 112, 100, 100, 100, 100, 
	100, 100, 97, 67, 98, 99, 67, 68, 
	68, 68, 68, 68, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 68, 69, 
	70, 71, 72, 73, 74, 70, 75, 76, 
	77, 78, 79, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	84, 85, 86, 87, 88, 89, 90, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 91, 67, 92, 93, 100, 95, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 113, 100, 100, 100, 100, 100, 
	100, 97, 67, 98, 99, 67, 68, 68, 
	68, 68, 68, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 68, 69, 70, 
	71, 72, 73, 74, 70, 75, 76, 77, 
	78, 79, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 84, 
	85, 86, 87, 88, 89, 90, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	91, 67, 92, 93, 100, 95, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 114, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	97, 67, 98, 99, 67, 68, 68, 68, 
	68, 68, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 68, 69, 70, 71, 
	72, 73, 74, 70, 75, 76, 77, 78, 
	79, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 115, 85, 
	86, 87, 88, 89, 90, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 91, 
	67, 92, 93, 100, 95, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 116, 
	100, 100, 100, 100, 100, 100, 100, 97, 
	67, 98, 99, 67, 118, 118, 118, 118, 
	118, 117, 117, 117, 117, 117, 117, 117, 
	117, 117, 117, 117, 117, 117, 117, 117, 
	117, 117, 117, 118, 117, 0, 68, 68, 
	68, 68, 68, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 68, 69, 70, 
	71, 72, 73, 74, 70, 75, 76, 77, 
	78, 79, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 115, 
	85, 86, 87, 88, 89, 90, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	91, 67, 92, 93, 100, 95, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	97, 67, 98, 99, 67, 68, 68, 68, 
	68, 68, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 68, 69, 70, 71, 
	72, 73, 74, 70, 75, 76, 77, 78, 
	79, 100, 100, 100, 119, 119, 119, 119, 
	119, 119, 119, 119, 119, 119, 84, 85, 
	86, 87, 88, 89, 90, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 91, 
	67, 92, 93, 100, 95, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 97, 
	67, 98, 99, 67, 68, 68, 68, 68, 
	68, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 68, 69, 70, 71, 72, 
	73, 74, 70, 75, 76, 77, 78, 79, 
	100, 120, 100, 119, 119, 119, 119, 119, 
	119, 119, 119, 119, 119, 84, 85, 86, 
	87, 88, 89, 90, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 91, 67, 
	92, 93, 100, 95, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 97, 67, 
	98, 99, 67, 68, 68, 68, 68, 68, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 68, 69, 70, 71, 72, 73, 
	74, 70, 75, 76, 77, 78, 79, 100, 
	100, 100, 121, 121, 121, 121, 121, 121, 
	121, 121, 121, 121, 84, 85, 86, 87, 
	88, 89, 90, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 91, 67, 92, 
	93, 100, 95, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 97, 67, 98, 
	99, 67, 68, 68, 68, 68, 68, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 68, 69, 70, 71, 72, 73, 74, 
	70, 75, 76, 77, 78, 79, 100, 122, 
	100, 121, 121, 121, 121, 121, 121, 121, 
	121, 121, 121, 84, 85, 86, 87, 88, 
	89, 90, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 91, 67, 92, 93, 
	100, 95, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 97, 67, 98, 99, 
	67, 68, 68, 68, 68, 68, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	68, 69, 70, 71, 72, 73, 74, 70, 
	75, 76, 77, 78, 79, 100, 100, 100, 
	123, 123, 123, 123, 123, 123, 123, 123, 
	123, 123, 84, 85, 86, 87, 88, 89, 
	90, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 91, 67, 92, 93, 100, 
	95, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 97, 67, 98, 99, 67, 
	68, 68, 68, 68, 68, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 68, 
	69, 70, 71, 72, 73, 74, 70, 75, 
	76, 77, 78, 79, 124, 100, 100, 125, 
	125, 125, 125, 125, 125, 125, 125, 125, 
	125, 84, 85, 86, 87, 88, 89, 90, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 91, 67, 92, 93, 100, 95, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 97, 67, 98, 99, 67, 68, 
	68, 68, 68, 68, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 68, 69, 
	70, 71, 72, 73, 74, 70, 75, 76, 
	77, 78, 79, 100, 100, 100, 126, 126, 
	126, 126, 126, 126, 126, 126, 126, 126, 
	84, 85, 86, 87, 88, 89, 90, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 91, 67, 92, 93, 100, 95, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 97, 67, 98, 99, 67, 68, 68, 
	68, 68, 68, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 68, 69, 70, 
	71, 72, 73, 74, 70, 75, 76, 77, 
	78, 79, 100, 127, 100, 128, 128, 128, 
	128, 128, 128, 128, 128, 128, 128, 84, 
	85, 86, 87, 88, 89, 90, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	91, 67, 92, 93, 100, 95, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	97, 67, 98, 99, 67, 68, 68, 68, 
	68, 68, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 68, 69, 70, 71, 
	72, 73, 74, 70, 75, 76, 77, 78, 
	79, 100, 100, 100, 129, 129, 129, 129, 
	129, 129, 129, 129, 129, 129, 84, 85, 
	86, 87, 88, 89, 90, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 91, 
	67, 92, 93, 100, 95, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 97, 
	67, 98, 99, 67, 68, 68, 68, 68, 
	68, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 68, 69, 70, 71, 72, 
	73, 74, 70, 75, 76, 77, 78, 79, 
	100, 130, 100, 129, 129, 129, 129, 129, 
	129, 129, 129, 129, 129, 84, 85, 86, 
	87, 88, 89, 90, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 91, 67, 
	92, 93, 100, 95, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 97, 67, 
	98, 99, 67, 68, 68, 68, 68, 68, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 68, 69, 70, 71, 72, 73, 
	74, 70, 75, 76, 77, 78, 79, 100, 
	100, 100, 131, 131, 131, 131, 131, 131, 
	131, 131, 131, 131, 84, 85, 86, 87, 
	88, 89, 90, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 91, 67, 92, 
	93, 100, 95, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 97, 67, 98, 
	99, 67, 68, 68, 68, 68, 68, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 68, 69, 70, 71, 72, 73, 74, 
	70, 75, 76, 77, 78, 79, 100, 132, 
	100, 131, 131, 131, 131, 131, 131, 131, 
	131, 131, 131, 84, 85, 86, 87, 88, 
	89, 90, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 91, 67, 92, 93, 
	100, 95, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 97, 67, 98, 99, 
	67, 68, 68, 68, 68, 68, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	68, 69, 70, 71, 72, 73, 74, 70, 
	75, 76, 77, 78, 79, 100, 100, 100, 
	133, 133, 133, 133, 133, 133, 133, 133, 
	133, 133, 84, 85, 86, 87, 88, 89, 
	90, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 91, 67, 92, 93, 100, 
	95, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 97, 67, 98, 99, 67, 
	68, 68, 68, 68, 68, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 67, 
	67, 67, 67, 67, 67, 67, 67, 68, 
	69, 70, 71, 72, 73, 74, 70, 75, 
	76, 77, 78, 79, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 84, 85, 86, 87, 88, 89, 90, 
	100, 134, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 91, 67, 92, 93, 100, 95, 
	100, 134, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 100, 100, 100, 100, 100, 100, 
	100, 100, 97, 67, 98, 99, 67, 135, 
	136, 137, 138, 0
]

class << self
	attr_accessor :_ralex_pix_trans_targs
	private :_ralex_pix_trans_targs, :_ralex_pix_trans_targs=
end
self._ralex_pix_trans_targs = [
	15, 2, 1, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 4, 5, 
	5, 7, 3, 3, 6, 3, 9, 3, 
	3, 3, 3, 3, 5, 3, 10, 3, 
	3, 3, 2, 1, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 4, 
	5, 5, 7, 3, 3, 6, 3, 9, 
	3, 3, 3, 3, 3, 5, 3, 10, 
	3, 3, 3, 2, 1, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	4, 5, 5, 7, 3, 3, 6, 3, 
	9, 3, 3, 3, 3, 3, 5, 3, 
	10, 3, 3, 3, 5, 3, 3, 3, 
	3, 8, 17, 7, 30, 5, 3, 3, 
	11, 12, 13, 14, 16, 15, 0, 18, 
	19, 20, 21, 22, 23, 22, 24, 25, 
	24, 26, 27, 28, 29, 5, 5, 32, 
	32, 34, 34
]

class << self
	attr_accessor :_ralex_pix_trans_actions
	private :_ralex_pix_trans_actions, :_ralex_pix_trans_actions=
end
self._ralex_pix_trans_actions = [
	1, 2, 0, 3, 4, 5, 6, 7, 
	8, 9, 10, 11, 12, 13, 14, 15, 
	16, 17, 18, 19, 20, 21, 22, 23, 
	24, 25, 26, 27, 28, 29, 15, 30, 
	31, 32, 34, 33, 35, 36, 37, 38, 
	39, 40, 41, 42, 43, 44, 45, 46, 
	47, 48, 49, 50, 51, 52, 53, 54, 
	55, 56, 57, 58, 59, 60, 61, 47, 
	62, 63, 64, 66, 65, 67, 68, 69, 
	70, 71, 72, 73, 74, 75, 76, 77, 
	78, 79, 80, 81, 82, 83, 84, 85, 
	86, 87, 88, 89, 90, 91, 92, 93, 
	79, 94, 95, 96, 1, 97, 98, 99, 
	100, 1, 1, 1, 1, 101, 102, 103, 
	1, 1, 1, 1, 1, 105, 106, 1, 
	1, 1, 1, 107, 1, 1, 108, 1, 
	1, 1, 1, 1, 1, 107, 109, 111, 
	112, 114, 116
]

class << self
	attr_accessor :_ralex_pix_eof_actions
	private :_ralex_pix_eof_actions, :_ralex_pix_eof_actions=
end
self._ralex_pix_eof_actions = [
	0, 0, 33, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 104, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 110, 
	0, 113, 115
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


# line 289 "lib/cisco/ralex_pix.rl"
    end

    def ragel_machine(data,stack=[],top=0)
            
# line 778 "lib/cisco/ralex_pix.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = ralex_pix_start
	top = 0
end

# line 293 "lib/cisco/ralex_pix.rl"
        
# line 788 "lib/cisco/ralex_pix.rb"
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
	when 112 then
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
	when 116 then
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
	when 106 then
# line 51 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:URL) 		end
	when 65 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
	when 33 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
	when 5 then
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
	when 107 then
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 158 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:IPADDR) 		end
	when 109 then
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 183 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:BYTECOUNT) 		end
	when 108 then
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 56 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:IPSET) 		end
	when 101 then
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 61 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:PORTSET) 		end
	when 30 then
# line 34 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 31 then
# line 35 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 25 then
# line 36 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 26 then
# line 37 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 3 then
# line 38 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:BANG) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 13 then
# line 39 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:COMMA) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 21 then
# line 40 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:EQUALS) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 9 then
# line 41 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 10 then
# line 42 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 20 then
# line 43 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:LESS_THAN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 22 then
# line 44 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:GREATER_THAN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 8 then
# line 45 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:AMPERSAND) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 24 then
# line 46 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:AT) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 6 then
# line 47 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:DOLLAR) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 7 then
# line 48 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:PERCENT) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 32 then
# line 49 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:TILDE)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 27 then
# line 50 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:HAT)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 11 then
# line 51 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:ASTERISK)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 12 then
# line 54 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:PLUS)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 23 then
# line 55 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:QUESTION)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 18 then
# line 56 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:COLON)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 19 then
# line 57 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:SEMICOLON)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 29 then
# line 58 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:BACKTICK)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 4 then
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
	when 111 then
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
	when 114 then
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
	when 100 then
# line 188 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:PERCENTAGE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 15 then
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 102 then
# line 25 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:PORTRANGE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 99 then
# line 30 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:PORTINVERSERANGE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 98 then
# line 35 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:LESSOREQUAL) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 103 then
# line 40 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:GREATEROREQUAL) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 97 then
# line 46 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ARROW) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 105 then
# line 51 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:URL) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 2 then
# line 87 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:UNKNOWN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 14 then
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 52 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:DASH)		end
	when 28 then
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 53 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:UNDERLINE)		end
	when 16 then
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 59 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:SLASH)		end
	when 17 then
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 148 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:NUMBER) 		end
	when 69 then
# line 84 "lib/cisco/ralex_pix.rl"
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
	when 94 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 34 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 95 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 35 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 89 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 36 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 90 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 37 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 67 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 38 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:BANG) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 77 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 39 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:COMMA) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 85 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 40 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:EQUALS) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 73 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 41 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 74 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 42 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 84 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 43 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:LESS_THAN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 86 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 44 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:GREATER_THAN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 72 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 45 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:AMPERSAND) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 88 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 46 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:AT) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 70 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 47 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:DOLLAR) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 71 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 48 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:PERCENT) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 96 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 49 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:TILDE)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 91 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 50 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:HAT)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 75 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 51 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:ASTERISK)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 76 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 54 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:PLUS)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 87 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 55 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:QUESTION)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 82 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 56 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:COLON)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 83 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 57 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:SEMICOLON)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 93 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 58 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:BACKTICK)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 68 then
# line 84 "lib/cisco/ralex_pix.rl"
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
	when 79 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 66 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 87 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:UNKNOWN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 37 then
# line 88 "lib/cisco/ralex_pix.rl"
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
	when 62 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 34 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 63 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 35 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 57 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 36 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 58 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 37 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_BRACE) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 35 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 38 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:BANG) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 45 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 39 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:COMMA) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 53 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 40 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:EQUALS) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 41 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 41 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:OPEN_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 42 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 42 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:CLOSE_PAREN)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 52 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 43 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:LESS_THAN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 54 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 44 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:GREATER_THAN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 40 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 45 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:AMPERSAND) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 56 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 46 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:AT) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 38 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 47 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:DOLLAR) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 39 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 48 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:PERCENT) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 64 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 49 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:TILDE)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 59 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 50 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:HAT)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 43 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 51 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:ASTERISK)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 44 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 54 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:PLUS)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 55 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 55 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:QUESTION)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 50 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 56 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:COLON)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 51 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 57 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:SEMICOLON)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 61 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 58 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:BACKTICK)		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 36 then
# line 88 "lib/cisco/ralex_pix.rl"
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
	when 47 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 34 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 87 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:UNKNOWN) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
	when 78 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 52 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:DASH)		end
	when 92 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 53 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:UNDERLINE)		end
	when 80 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 59 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:SLASH)		end
	when 81 then
# line 84 "lib/cisco/ralex_pix.rl"
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
	when 46 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 52 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:DASH)		end
	when 60 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 53 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:UNDERLINE)		end
	when 48 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 20 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:ID) 		end
# line 8 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 token << data[p] 		end
# line 59 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:SLASH)		end
	when 49 then
# line 88 "lib/cisco/ralex_pix.rl"
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
# line 2011 "lib/cisco/ralex_pix.rb"
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
	when 110 then
# line 118 "/Users/craig/.gem/ruby/1.8/gems/Ralex-0.1/lib/ralex/ralex_base.rl"
		begin
 start_token(:STRING) 		end
	when 115 then
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
	when 65 then
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
	when 33 then
# line 88 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
	when 113 then
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
	when 104 then
# line 51 "lib/cisco/ralex_pix.rl"
		begin
 start_token(:URL) 		end
# line 84 "lib/cisco/ralex_pix.rl"
		begin
 finish_token; 		end
# line 2069 "lib/cisco/ralex_pix.rb"
	  end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end

# line 294 "lib/cisco/ralex_pix.rl"
    end
end


end # end of module