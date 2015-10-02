# encoding: utf-8

class MemorySimulator

  attr_reader :exit_flag
  COMMANDS = {
    load:       "carregar",
    space:      "espaco",
    replace:    "substitui",
    execute:    "executa",
    undefined:  "undefined",
    exit:       "sai",
  }

  def initialize
    @exit_flag = false
  end

  @@instance = MemorySimulator.new

  def self.instance
    return @@instance
  end

  def self.new_method
    return @@instance
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
