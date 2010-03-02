module Flint
  
  class StaticMap < Ohm::Model
    attribute :real
    attribute :mapped
    attribute :real_interface_name
    attribute :mapped_interface_name
    attribute :type
    
    # only present if this is a type "pat"
    list :ports
    list :protocols

    # "sat" or "pat"
    index :type
    index :real_interface_name
    index :mapped_interface_name
    index :real
    index :mapped
    index :protocols
  
    def real_as_cidrset
      CidrSet.new(self.real)
    end
  
    def mapped_as_cidrset
      CidrSet.new(self.mapped)
    end
    
    def ports_as_portset
      Portset.new(self.ports.all)
    end
    
    def real_interface
      Interface.find(:name => self.real_interface_name).first
    end
    
    def mapped_interface
      Interface.find(:name => self.mapped_interface_name).first
    end
  end
end
