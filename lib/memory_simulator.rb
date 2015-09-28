# encoding: utf-8

class MemorySimulator


  def initialize
  end

  @@instance = MemorySimulator.new

  def self.instance
    return @@instance
  end

  def read_command
    print "[ep2] : "
    command = gets.chomp
  end

  def run_command
  end
end