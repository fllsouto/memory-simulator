# encoding: utf-8
require 'readline'

require_relative 'memory_manager'
require_relative 'process_manager'

class RubyBasicApp

  COMMANDS = {
    "carregar"  => :load,
    "espaco"    => :space,
    "substitui" => :replace,
    "executa"   => :execute,
    "sai"       => :exit
  }

  def initialize
    @exit_flag = false

    @process_manager = ProcessManager.new()
    @memory_manager = MemoryManager.instance()
  end

  def main

    while !@exit_flag
      command, args = read_command
      run_command(command, args)
    end
  end

  def read_command
    input = Readline.readline('[ep2]: ', true)
    command = input.chomp.split
    [command.first, command.drop(1)]
  end

  def run_command command, args
    if COMMANDS.keys.include? command
      if command != "sai" && args.size < 1
        puts "Argumentos faltando"
        return
      end
      # executa o método do comando
      self.send(COMMANDS[command], args)
    else
      puts "Comando não reconhecido"
    end
  end

  def load args
    trace = File.new(args[0], 'r')
    physical_mem, virtual_mem = trace.gets.split.map(&:to_i)
    trace.close

    @memory_manager.set_mem_sizes(physical_mem, virtual_mem)
    @process_manager.set_trace_file(args[0])
  end

  def space args
    @memory_manager.space = args[0].to_i
  end

  def replace args
    @memory_manager.replace = args[0].to_i
  end

  def execute args
    # Uma thread para cada manager, se comunicam por Queues
  end

  def exit
    #Apaga arquivos de memória
    puts "Saindo"
    @@exit_flag = true
  end
end

RubyBasicApp.new.main
