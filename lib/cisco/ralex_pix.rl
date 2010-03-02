# An example subclassing of Ralex

require 'ralex'


module Cisco
class RalexPix < Ralex::Base


    %%{ 

  machine ralex_pix;
  include ralex_base "ralex_base.rl";

  # new compound token definitions

  
  id = (alnum | '_' | '-' | '.' | '/')+
    @collect_token
    >{ start_token(:ID) }
  ; 

  range = '>' '<'
    @collect_token
    >{ start_token(:PORTRANGE) }
    ;

  inverserange = '<' '>'
    @collect_token
    >{ start_token(:PORTINVERSERANGE) }
    ;

  lessorequal  = '<' '='
    @collect_token
    >{ start_token(:LESSOREQUAL) }
    ;

  greaterorequal = '>' '='
    @collect_token
    >{ start_token(:GREATEROREQUAL) }
    ;


  arrow = '-' '>'
    @collect_token
    >{ start_token(:ARROW) }
    ;

  url = ('http' | 'https') ':' @collect_token ( any* - space )
    @collect_token    
    >{ start_token(:URL) }
    ;

  ipset = ipaddr '-' @collect_token ipaddr
    @collect_token    
    >{ start_token(:IPSET) }
    ;

  portset = digit+ '-' @collect_token digit+
    @collect_token    
    >{ start_token(:PORTSET) }
    ;

  token = ( id
  	    | url
            | ipaddr
	    | ipset
	    | portset
            | number
            | percentage
            | bytecount
            | range
            | inverserange
            | lessorequal
            | greaterorequal
	    | open_paren
	    | close_paren
	    | comma
	    | arrow
	    | hashcomment
	    | quote
	    ) %{ finish_token; };

  unknown = ( any - (space | token) ) @collect_token
    >{ start_token(:UNKNOWN) }
    %{ finish_token; }
    ;
  
  main := ( token | space | unknown )**
  ;

}%%


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


        %% write data;
    end

    def ragel_machine(data,stack=[],top=0)
            %% write init;
        %% write exec;
    end
end


end # end of module