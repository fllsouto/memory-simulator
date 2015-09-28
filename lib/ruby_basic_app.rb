# encoding: utf-8
# require "ruby_basic_app/version"
require_relative 'memory_simulator'

module RubyBasicApp
  
  def self.main
    simulator = MemorySimulator.instance

    while !simulator.exit_flag
      comamnd = simulator.read_command
      simulator.parse_command(comamnd)
      simulator.run_command(comamnd)
    end
  end

end


RubyBasicApp.main

