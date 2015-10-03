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
    key = MemoryManager::SPACE_ALGORITHM.key(args[0].to_i) rescue nil 
    if(key.nil?)
      puts "Algoritmo de gerenciamento de espaço livre não encontrado! \n1. First Fit \n2. Next Fit \n3. Quick Fit"
    else
      @memory_manager.space = key
    end
  end

  def replace args
    key = MemoryManager::REPLACE_ALGORITHM.key(args[0].to_i) rescue nil 
    if(key.nil?)
      puts "Algoritmo de substituição de páginas não encontrado! \n1. Not Recently Used Page\n2. First-In, First-Out\n3. Second-Chance Page\n4. Least Recently Used Page"
    else
      @memory_manager.replace = key
    end
  end

  def execute args
    interval_time = args[0].to_i
    if (@memory_manager.can_execute? && interval_time > 0)
      @process_manager.set_interval_time(interval_time)
      process_manager = Thread.new { @process_manager.start_simulation }
      @memory_manager.start_simulation
    else
      puts "Execução falhou, verifique suas configurações"
      puts "\nArquivo : #{@process_manager.trace_file.inspect}\nAlgoritmo de espaço : #{@memory_manager.space.inspect}\nAlgoritmo de página : #{@memory_manager.replace.inspect}\n"
    end
    # Uma thread para cada manager, se comunicam por Queues
  end

  def exit args
    #Apaga arquivos de memória
    puts "Saindo"
    @exit_flag = true
  end

end

RubyBasicApp.new.main
