module Flint

  # map fuzzy keywords to :permit/:deny
  def self.policy(x)
    if(x.kind_of? Hash and x.include? :policy)
      return self.policy(x[:policy])
    end

    case x
    when /permit/i
      :permit
    when :permit
      :permit
    when /deny/i
      :deny
    when :deny
      :deny
    else
      :permit
    end
  end
  
  # well that got hairy real quick
  def self.references? (x, p)
    if x.kind_of? Hash
      if((d = x[:destination_port]))
        check = lambda do |d|
          if p.kind_of? String
            p = PortName.new(p).resolve
          elsif p.kind_of? Array
            raise "if we need name + proto" # XXXX
          end

          if d.kind_of? Range or d.kind_of? Numeric
            d === p
          elsif d.kind_of? Array
            if d.respond_to? :exclusion?
              d.first === p or d.last === p
            else
              d.find {|x| check.call(x)}
            end
          end
        end
        return check.call(d)
      end
      return false
    else
      raise "notimp + #{ x.inspect } " # XXX
    end
  end

  # @param ports
  #    The port or ports. Can be an array, range, port number or port name 
  #    string
  #
  # @param pspec
  #    The port spec from the ACL to look for the port in.
  #
  def self.ports_include? (ports, pspec)
    check = lambda do |port, pspec|
      if port.kind_of? String
        port = PortName.new(port).resolve
      elsif port.kind_of? Array
        raise "if we need name + proto" # XXXX
      end
      
      if pspec.kind_of? Range or pspec.kind_of? Numeric
        pspec === port
      elsif pspec.kind_of? Array
        if pspec.respond_to? :exclusion?
          pspec.first === port or pspec.last === port
        else 
          pspec.flatten.include?(port)
        end
      end
    end
    ports = [ports] unless ports.kind_of? Array
    return (not ports.find{|port| check.call(port, pspec)}.nil?)
  end


  # @param ports
  #    The port or ports. Can be an array, range, port number or port name 
  #    string
  #
  # @param pspec
  #    The port spec from the ACL to look for the port in.
  #
  def self.ports_superset?(ports, pspec)
    ports = [ports] unless ports.kind_of?(Enumerable)
    ports.each {|port| return false unless ports_include?(port, pspec) }
    return true
  end

  def self.permits? acl, port
    references(acl, port) and policy(acl) == :permit
  end

  def self.denies? acl, port
    references(acl, port) and policy(acl) == :deny
  end

  def self.normed(v, f)
    r = f.normalize_netspec(v)
  end

  # select down to access-lists
  def self.acl(astn, firewall)
    if astn and astn.first == "access-list"
      node = astn[1..-1].to_hash

      if node.include? :protocol
        node[:protocol] = firewall.normalize_protocol(node[:protocol])
      end

      if node.include? :destination_net
        node[:destination_net] = normed(node[:destination_net], firewall)
      end

      if node.include? :source_net
        node[:source_net] = normed(node[:source_net], firewall)
      end

      if node.include? :source_port
        node[:source_port] = firewall.normalize_portspec(node[:source_port])
      end

      if node.include? :destination_port
        node[:destination_port] = firewall.normalize_portspec(node[:destination_port])
      end

      if block_given?
        yield node
      else
        return node
      end
    end
    nil
  end

end
