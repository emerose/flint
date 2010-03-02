module Flint
  class Table < Ohm::Model
    attribute :sha
    attribute :name
    list :objects

    index :sha
    index :name

    def [](idx)
      Marshal.load(objects[idx])
    end
    
    def add(entry)
      self.objects << Marshal.dump(entry)
      self.save
    end
    
    def members
      self.objects.all.map {|x| Marshal.load(x)}
    end
  end
end
