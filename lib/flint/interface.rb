module Flint
  class Interface < Ohm::Model
    attribute :sha
    attribute :name
    attribute :security_level
    attribute :address
    attribute :netmask
    
    list :chains
    
    # networks attached to this interface
    list :networks
    
    index :sha
    index :name

    def networks_as_cidrset
      CidrSet.new(self.networks.all)
    end

    def mapped_to_interface(realiface)
      realiface = realiface.name if realiface.kind_of? Interface
      mnets = StaticMap.find(:mapped_interface_name => self.name,
                             :real_interface_name => realiface).all.map { |m|
        m.mapped_as_cidrset 
      }
      CidrSet.new(*mnets)
    end
  end
end
