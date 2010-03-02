module Flint
  def self.quickload(name)
    Dir["#{ FLINT_ROOT }/checks/#{ name }/*.ftg"].map do |fn|
      TestGroup.load(fn)
    end
  end

  class TestGroup
    attr_accessor :code, :title, :tests, :description, :options

    def initialize(code, title, tests = { }, options = { }, description = "")
      @code = code
      @title = title
      @tests = tests
      @description = description
      @options = options
    end

    require 'ruby-debug'
    def grade(sha)
      raise "Must be given a sha to identify the firewall we are grading" if sha.empty?
      results = TestResult.find(:group => self.code, :sha => sha)
      total = results.all.select { |r| r.result != "error" }.size
      passes = results.all.select { |r| r.result == "pass" }.size
      if total == 0
        # no checks run means you get an A, woot.
        100
      else
        (passes.to_f / total) * 100
      end
    end

    def self.load(filename)
      TestGroupLoader.load(filename)
    end

  end

  class TestGroupLoader
    def self.load(filename)
      @tg = TestGroup.new(:unnamed, "Unnamed")
      unless File.exist?(filename)
        raise "TestGroup definition file, #{filename} does not exist."
      end
      self.instance_eval(File.read(filename), filename)
      @tg
    end

    def self.code(code)
      @tg.code = code
    end

    def self.title(title)
      @tg.title = title
    end

    def self.description(desc)
      @tg.description = desc
    end

    def self.add_test(test)
      test.group_code = @tg.code
      @tg.tests[test.title] = test      
    end
    
    # Defines a new test
    def self.check(code, title, options = { }, &block)
      test = Test.new(code, title, options)
      test.block = block
      add_test(test)
    end

    # Defines a new test
    def self.interface_check(code, title, options = { }, &block)
      test = InterfaceTest.new(code, title, options)
      test.block = block
      add_test(test)
    end

    # Defines a new test
    def self.x2i_check(code, title, options = { }, &block)
      test = X2ITest.new(code, title, options)
      test.block = block
      add_test(test)
    end
    def self.x2d_check(code, title, options = { }, &block)
      test = X2DTest.new(code, title, options)
      test.block = block
      add_test(test)
    end

    def self.d2i_check(code, title, options = { }, &block)
      test = D2ITest.new(code, title, options)
      test.block = block
      add_test(test)
    end

    def self.d2x_check(code, title, options = { }, &block)
      test = D2XTest.new(code, title, options)
      test.block = block
      add_test(test)
    end

    def self.i2d_check(code, title, options = { }, &block)
      test = I2DTest.new(code, title, options)
      test.block = block
      add_test(test)
    end
    def self.i2x_check(code, title, options = { }, &block)
      test = I2XTest.new(code, title, options)
      test.block = block
      add_test(test)
    end
    def self.interface_pair_check(code, title, options = { }, &block)
      test = InterfacePairTest.new(code, title, options)
      test.block = block
      add_test(test)
    end
  end
end
