module Flint
  class ProtocolBlurb < Ohm::Model
    attribute :name
    attribute :description
    attribute :rfc
    attribute :exposes_data
    attribute :exposes_integrity
    attribute :exposes_connectivity
    attribute :risk
    attribute :strong_encryption
    attribute :strong_auth
    attribute :complexity
    attribute :history
    attribute :exotic

    list :alias
    list :app
    list :is
    list :islike
    list :setting
    list :tcp_port
    list :udp_port
    list :lockdown
    list :ip_protocol

    index :name
    index :risk
    index :alias
    index :is
    index :islike
    index :tcp_port
    index :udp_port
    index :exposes_data
    index :exposes_integrity
    index :exposes_connectivity
    index :strong_auth
    index :strong_encryption

    def alias=(str)
      self.alias.concat(str.split(","))
    end
    
    def app=(str)
      self.app.concat(str.split(","))
    end
    
    def is=(str)
      self.is.concat(str.split(","))
    end
    
    def islike=(str)
      self.islike.concat(str.split(","))
    end

    def setting=(str)
      self.setting.concat(str.split(","))
    end 
    
    def tcp_port=(str)
      self.tcp_port.concat(str.split(","))
    end

    def udp_port=(str)
      self.udp_port.concat(str.split(","))
    end 
    
    def lockdown=(str)
      self.lockdown.concat(str.split(","))
    end
    
    def ip_protocol=(str)
      self.ip_protocol.concat(str.split(","))
    end
  end

end
