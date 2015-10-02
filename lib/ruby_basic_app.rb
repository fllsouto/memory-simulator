# encoding: utf-8
# require "ruby_basic_app/version"
require_relative 'memory_simulator'

module RubyBasicApp

  COMMANDS = {
    load:       "carregar",
    space:      "espaco",
    replace:    "substitui",
    execute:    "executa",
    undefined:  "undefined",
    exit:       "sai",
  }

  def main
    simulator = MemorySimulator.instance

    while !simulator.exit_flag
      comamnd = simulator.read_command
      simulator.parse_command(comamnd)
      simulator.run_command(comamnd)
    end
  end

  def read_command
    print "[ep2] : "
    command = gets.chomp
  end

  def parse_command command
    case command
    when COMMANDS[:load]
      puts "Comando inserido : #{command}"
    when COMMANDS[:space]
      puts "Comando inserido : #{command}"
    when COMMANDS[:replace]
      puts "Comando inserido : #{command}"
    when COMMANDS[:execute]
      puts "Comando inserido : #{command}"
    when COMMANDS[:exit]
      puts "Comando inserido : #{command}"
      puts "Vou sair"
      @exit_flag = true
    else
      puts "Comando inserido Desconhecido"
    end
  end

  def run_command command

  end
end

RubyBasicApp.main
