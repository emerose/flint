module Flint

  class RangeSet
    # Returns a RangeSet representing any possible value
    def self.any
      new(0 .. max_val)
    end

    # Returns a RangeSet representing NONE
    def self.empty
      new()
    end

    # This is an abstract method that must be overridden in subclasses.
    #
    def coerce(obj)
      raise(NotImplementedError, "coerce is not implemented for #{self.class}")
    end

    attr_reader :ranges

    def initialize(*set)
      @ranges = []
      if set.size == 1 and set.first.kind_of?(Array)
        set = set.first
      end
      set.each {|range| self.add(range)}
    end

    def max_val
      self.class.max_val
    end

    def == (other)
      return false unless self.class === other
      other.ranges == @ranges
    end

    def include?(other)
      not @ranges.find{|range| range.contains?(coerce(other)) }.nil?
    end

    # subtracts ranges from the RangeSet
    def subtract(other)
      self.invert!
      self.add(other)
      self.invert!
    end

    alias remove subtract
    
    # Adds to the RangeSet, merging port ranges as necessary.
    def add(other)
      if other.kind_of?(self.class)
        other.ranges.each {|x| self.add(x)}
        return self
      end

      obj = coerce(other)
      if @ranges.empty?
        @ranges << obj
      elsif @ranges.first.first-1 > obj.last
        @ranges.unshift(obj)
      elsif obj.contains?( @ranges.first.first .. @ranges.last.last)
        @ranges = [obj]
      else
        top = btm = nil

        @ranges.each_with_index do |range, idx|
          return self if range.contains?(obj)
          top = idx if range.include?(obj.first-1)
          if range.include?(obj.last+1)
            btm = idx
            break
          elsif( n=@ranges[idx+1] and
              coerce(@ranges[idx].last+1 .. n.first-1).contains?(obj))
            @ranges[idx+1,0]=obj
            return self
          end
        end

        if top and btm
          @ranges[top..btm] = coerce(@ranges[top].first .. @ranges[btm].last)
        elsif top
          @ranges[top] = coerce(@ranges[top].first .. obj.last)
        elsif btm
          @ranges[btm] = coerce(obj.first .. @ranges[btm].last)
        else
          @ranges << obj
        end
      end
    end


    # returns a new RangeSet with overlapped ranges between this and another 
    # set provided by the 'other' argument. The other set will be coerced to a 
    # RangeSet as needed.
    def overlap(*other)
      obj = class_coerce(*other)
      ret = []
      fidx = 0
      @ranges.each do |my_range|
        obj.ranges[fidx..-1].each_with_index do |other_range, i|
          if x=my_range.overlap(other_range)
            fidx = i
            ret << x
          end
        end
      end
      return self.class.new(*ret) if not ret.empty?
    end

    # Indicates whether this RangeSet overlaps another. The other will be 
    # coerced into a RangePorts if possible.
    def overlap?(*other)
      not self.overlap(*other).nil?
    end

    # Identify whether this set is a superset of another port, range, or
    # set. Raises an ArgumentError exception if other is an empty set.
    # The other will be coerced into a RangePorts if possible.
    def superset_of?(*other)
      obj = class_coerce(*other)
      raise(ArgumentError, "empty set specified") if obj.count == 0

      obj.ranges.select do |other_range|
        @ranges.find do |range| 
          range.first <= other_range.first and range.last >= other_range.last
        end
      end.size == obj.ranges.size
    end
    alias superset? superset_of?


    # Identify whether this set is a subset of another port, range, or
    # set. Raises an ArgumentError exception if other is an empty set.
    # The other will be coerced into a RangePorts if possible.
    def subset_of?(*other)
      obj = class_coerce(*other)
      raise(ArgumentError, "empty set specified") if obj.count == 0
      obj.superset_of?(self)
    end
    alias subset? subset_of?

    # Returns a separate copy of this RangeSet
    def copy
      cp = @ranges.clone
      self.class.new.instance_eval{ self.ranges = cp ; self }
    end

    # Performs an in-place inversion of the RangeSet. Returns self.
    def invert!
      p = 0
      tmp = @ranges
      @ranges = []
      if tmp.empty?
        @ranges = [coerce(0 .. self.max_val)]
      else
        tmp.each do |range|
          unless range.include?(p)
            @ranges << coerce(p .. range.first-1)
          end
          x = range.last+1
          p = x < self.max_val ? x : self.max_val
        end

        n = self.max_val
        if tail=tmp.last and not tail.include?(n)
          @ranges << coerce(tail.last+1 .. n)
        end
      end

      return self
    end

    # Returns an inverted copy of the RangeSet
    def invert
      copy.invert!
    end

    # Returns the total count of adresses in the set
    def count
      i = 0
      @ranges.each {|range| i += (range.last - range.first + 1) }
      return i
    end
    alias size count

    # Indicates whether this RangeSet is "ANY" or equal to "0 - self.max_val"
    def any?
      @ranges == [0..self.max_val]
    end

    # indicates whether this RangeSet is empty
    def empty?
      @ranges.empty?
    end

    private
      def normalize(*other)
        ret = []
        other.each do |o| 
          r = 
            if o.kind_of?(self.class)
              ret.concat(o.ranges)
            elsif block_given?
              ret.concat(yield(o))
            else
              ret << coerce(o)
            end
        end
        return ret
      end


      def class_coerce(*other)
        if other.size == 1 and other.first.kind_of?(self.class)
          other.first
        else
          self.class.new(*other)
        end
      end

      def ranges=(other)
        @ranges = other
      end
    public

    class RangeSetMember < Range
      def initialize(*args)
        if args.size == 1 and Range === args.first
          super(args[0].first, args[0].last)
        else
          super(*args)
        end
        yield self if block_given?
      end

      def ==(other)
        ( Range === other and 
          other.first == self.first and 
          other.last == self.last )
      end

      # Returns the overlapping ranges between this and another range or
      # nil if there are none.
      def overlap(other)
        if self.include?(other.first) 
          (other.first .. (self.last < other.last ? self.last : other.last) )
        elsif self.include?(other.last)
          (self.first .. other.last )
        elsif other.include?(self.first) and other.include?(self.last)
          (self.first .. self.last)
        end
      end

      # Indicates whether this range overlaps with another range object
      def overlap?(other)
        not self.overlap(other).nil?
      end

      # Indicates whether this range contains another range object
      def contains?(other)
        self.include?(other.first) and self.include?(other.last)
      end

    end # RangePorts

  end
end
