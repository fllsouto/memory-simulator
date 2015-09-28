# encoding: utf-8
# require "ruby_basic_app/version"
require_relative 'memory_simulator'

module RubyBasicApp
  
  def self.main
    simulator = MemorySimulator.new
    while true
      puts simulator.read_command
    end
  end

end


RubyBasicApp.main

